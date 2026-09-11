package DAO;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Security.PasswordHasher;

public class AdminDAO {
    private DBConnectionMgr pool;

    public AdminDAO() {
        pool = DBConnectionMgr.getInstance();
    }

    // 로그인 처리 메서드
    public boolean login(String id, String pwd, String email, String inputCode, String sessionCode) {
        Connection con = null;
        boolean result = false;
        boolean reusable = false;

        try {
            con = pool.getConnection();

            con.setAutoCommit(false);
            reusable = true;
            String sql = "SELECT admin_pwd, admin_email, admin_fail_login, admin_lock_state "
                    + "FROM admin WHERE admin_id = ? FOR UPDATE";
            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setString(1, id);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("admin_pwd");
                        String storedEmail = rs.getString("admin_email");
                        int failCount = rs.getInt("admin_fail_login");
                        boolean locked = "Y".equals(rs.getString("admin_lock_state"));

                        if (locked) {
                            insertAdminLog(con, id, "로그인 시도");
                        } else {
                            boolean passwordMatches = PasswordHasher.verify(pwd, storedPassword);
                            boolean emailMatches = email != null && email.equals(storedEmail);
                            boolean codeMatches = inputCode != null && inputCode.equals(sessionCode);

                            if (passwordMatches && emailMatches && codeMatches) {
                                if (!PasswordHasher.isEncoded(storedPassword)) {
                                    migrateAdminPassword(con, id, storedPassword, pwd);
                                }
                                updateAdminFailLogin(con, 0, id);
                                insertAdminLog(con, id, "로그인");
                                result = true;
                            } else {
                                int nextFailCount = failCount + 1;
                                updateAdminFailLogin(con, nextFailCount, id);
                                if (nextFailCount >= 5) {
                                    updateAdminLock(con, "Y", id);
                                }
                                insertAdminLog(con, id, "로그인 시도");
                            }
                        }
                    }
                }
            }
            // A failed commit has an uncertain outcome; never reuse that connection.
            reusable = false;
            con.commit();
            reusable = true;
        } catch (Exception e) {
            if (con != null) {
                try {
                    if (!con.isClosed() && !con.getAutoCommit()) {
                        con.rollback();
                    } else {
                        reusable = false;
                    }
                } catch (SQLException rollbackError) {
                    reusable = false;
                }
            }
            result = false;
        } finally {
            if (con != null) {
                if (reusable) {
                    try {
                        con.setAutoCommit(true);
                    } catch (SQLException resetError) {
                        reusable = false;
                        result = false;
                    }
                }
                if (reusable) {
                    pool.freeConnection(con);
                } else {
                    pool.removeConnection(con);
                }
            }
        }

        return result;
    }

    private void migrateAdminPassword(Connection con, String id, String legacyPassword, String password)
            throws SQLException {
        String sql = "UPDATE admin SET admin_pwd = ? WHERE admin_id = ? AND admin_pwd = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, PasswordHasher.hash(password));
            pstmt.setString(2, id);
            pstmt.setString(3, legacyPassword);
            if (pstmt.executeUpdate() != 1) {
                throw new SQLException("Legacy administrator password migration failed.");
            }
        }
    }

    private void updateAdminFailLogin(Connection con, int count, String id) throws SQLException {
        String sql = "UPDATE admin SET admin_fail_login = ? WHERE admin_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, count);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        }
    }

    private void updateAdminLock(Connection con, String state, String id) throws SQLException {
        String sql = "UPDATE admin SET admin_lock_state = ? WHERE admin_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, state);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        }
    }

    private void insertAdminLog(Connection con, String id, String type) throws SQLException {
        String sql = "INSERT INTO admin_log VALUES (NULL, ?, NOW(), ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, type);
            try {
                pstmt.setString(3, InetAddress.getLocalHost().getHostAddress());
            } catch (Exception e) {
                throw new SQLException("Unable to resolve administrator login log address.", e);
            }
            pstmt.executeUpdate();
        }
    }

    public boolean idCheck(String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        try {
            con = pool.getConnection();
            String sql = "SELECT admin_id FROM admin WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            exists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return exists;
    }

    // 관리자 인증메일 수신자 확인용 read-only 조회.
    // 요청자가 수신 주소를 임의로 지정하지 못하게, DB 에 등록된 주소와 일치할 때만 true.
    // 실패 횟수/잠금 상태는 변경하지 않는다.
    public boolean isVerificationRecipient(String id, String email) {
        if (id == null || id.isBlank() || email == null || email.isBlank()) return false;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean match = false;
        try {
            con = pool.getConnection();
            String sql = "SELECT 1 FROM admin WHERE admin_id = ? AND admin_email = ? AND admin_lock_state <> 'Y'";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, email);
            rs = pstmt.executeQuery();
            match = rs.next();
        } catch (Exception e) {
            // 조회 실패는 상세 정보 없이 거부로 처리한다.
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return match;
    }

    public boolean checkLock(String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean locked = false;
        try {
            con = pool.getConnection();
            String sql = "SELECT admin_lock_state FROM admin WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getString(1).equals("Y")) {
                locked = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return locked;
    }

    public int showFailLogin(String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int cnt = 0;
        try {
            con = pool.getConnection();
            String sql = "SELECT admin_fail_login FROM admin WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                cnt = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return cnt;
    }

    public void updateFailLogin(int cnt, String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            String sql = "UPDATE admin SET admin_fail_login = ? WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, cnt);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
    }

    public void updateLock(String state, String id) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = pool.getConnection();
            String sql = "UPDATE admin SET admin_lock_state = ? WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, state);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
    }

    public void insertLog(String id, String type) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            String ip = InetAddress.getLocalHost().getHostAddress();
            con = pool.getConnection();
            String sql = "INSERT INTO admin_log VALUES (NULL, ?, NOW(), ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, type);
            pstmt.setString(3, ip);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
    }

    // 관리자 ID로 관리자 이름 가져오기
    public String getAdminName(String adminId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String adminName = "관리자";  // 기본값
        
        try {
            con = pool.getConnection();
            String sql = "SELECT admin_name FROM admin WHERE admin_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, adminId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                adminName = rs.getString("admin_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return adminName;
    }
}
