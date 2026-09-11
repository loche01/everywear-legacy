package DAO;

import java.sql.*;
import java.util.*;

public class AdminDeliveryDAO {
    private DBConnectionMgr pool;
    
    public AdminDeliveryDAO() {
        pool = DBConnectionMgr.getInstance();
    }
    
    // 배송 목록 조회 (페이징 포함)
    public List<Map<String, Object>> getDeliveryList(int start, int pageSize) {
        List<Map<String, Object>> deliveryList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT d.*, o.o_num, o.o_name, o.o_phone " +
                         "FROM delivery d " +
                         "JOIN orders o ON d.o_id = o.o_id " +
                         "ORDER BY d.d_id DESC LIMIT ?, ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, start);
            pstmt.setInt(2, pageSize);
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, Object> delivery = new HashMap<>();
                
                delivery.put("d_id", rs.getInt("d_id"));
                delivery.put("o_id", rs.getInt("o_id"));
                delivery.put("o_num", rs.getString("o_num"));
                delivery.put("o_name", rs.getString("o_name"));
                delivery.put("d_name", rs.getString("d_name"));
                delivery.put("recv_name", rs.getString("recv_name"));
                delivery.put("recv_phone", rs.getString("recv_phone"));
                delivery.put("recv_zipcode", rs.getString("recv_zipcode"));
                delivery.put("recv_addr_road", rs.getString("recv_addr_road"));
                delivery.put("recv_addr_detail", rs.getString("recv_addr_detail"));
                delivery.put("d_status", rs.getString("d_status"));
                delivery.put("d_courier", rs.getString("d_courier"));
                delivery.put("d_tracking_num", rs.getString("d_tracking_num"));
                delivery.put("shipped_at", rs.getTimestamp("shipped_at"));
                delivery.put("started_at", rs.getTimestamp("started_at"));
                delivery.put("completed_at", rs.getTimestamp("completed_at"));
                delivery.put("d_memo", rs.getString("d_memo"));
                
                deliveryList.add(delivery);
            }
            
        } catch (Exception e) {
            System.err.println("Admin delivery list retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return deliveryList;
    }
    
    // 배송 정보 검색 (송장번호로 검색)
    public List<Map<String, Object>> searchDeliveryByTrackingNumber(String trackingNumber) {
        List<Map<String, Object>> deliveryList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT d.*, o.o_num, o.o_name, o.o_phone " +
                         "FROM delivery d " +
                         "JOIN orders o ON d.o_id = o.o_id " +
                         "WHERE d.d_tracking_num LIKE ? " +
                         "ORDER BY d.d_id DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + trackingNumber + "%");
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, Object> delivery = new HashMap<>();
                
                delivery.put("d_id", rs.getInt("d_id"));
                delivery.put("o_id", rs.getInt("o_id"));
                delivery.put("o_num", rs.getString("o_num"));
                delivery.put("o_name", rs.getString("o_name"));
                delivery.put("d_name", rs.getString("d_name"));
                delivery.put("recv_name", rs.getString("recv_name"));
                delivery.put("recv_phone", rs.getString("recv_phone"));
                delivery.put("recv_zipcode", rs.getString("recv_zipcode"));
                delivery.put("recv_addr_road", rs.getString("recv_addr_road"));
                delivery.put("recv_addr_detail", rs.getString("recv_addr_detail"));
                delivery.put("d_status", rs.getString("d_status"));
                delivery.put("d_courier", rs.getString("d_courier"));
                delivery.put("d_tracking_num", rs.getString("d_tracking_num"));
                delivery.put("shipped_at", rs.getTimestamp("shipped_at"));
                delivery.put("started_at", rs.getTimestamp("started_at"));
                delivery.put("completed_at", rs.getTimestamp("completed_at"));
                delivery.put("d_memo", rs.getString("d_memo"));
                
                deliveryList.add(delivery);
            }
            
        } catch (Exception e) {
            System.err.println("Admin delivery search failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return deliveryList;
    }
    
    // 배송 상태별 목록 조회
    public List<Map<String, Object>> getDeliveryListByStatus(String status) {
        List<Map<String, Object>> deliveryList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT d.*, o.o_num, o.o_name, o.o_phone " +
                         "FROM delivery d " +
                         "JOIN orders o ON d.o_id = o.o_id " +
                         "WHERE d.d_status = ? " +
                         "ORDER BY d.d_id DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                Map<String, Object> delivery = new HashMap<>();
                
                delivery.put("d_id", rs.getInt("d_id"));
                delivery.put("o_id", rs.getInt("o_id"));
                delivery.put("o_num", rs.getString("o_num"));
                delivery.put("o_name", rs.getString("o_name"));
                delivery.put("d_name", rs.getString("d_name"));
                delivery.put("recv_name", rs.getString("recv_name"));
                delivery.put("recv_phone", rs.getString("recv_phone"));
                delivery.put("recv_zipcode", rs.getString("recv_zipcode"));
                delivery.put("recv_addr_road", rs.getString("recv_addr_road"));
                delivery.put("recv_addr_detail", rs.getString("recv_addr_detail"));
                delivery.put("d_status", rs.getString("d_status"));
                delivery.put("d_courier", rs.getString("d_courier"));
                delivery.put("d_tracking_num", rs.getString("d_tracking_num"));
                delivery.put("shipped_at", rs.getTimestamp("shipped_at"));
                delivery.put("started_at", rs.getTimestamp("started_at"));
                delivery.put("completed_at", rs.getTimestamp("completed_at"));
                delivery.put("d_memo", rs.getString("d_memo"));
                
                deliveryList.add(delivery);
            }
            
        } catch (Exception e) {
            System.err.println("Admin delivery status list retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return deliveryList;
    }
    
    // 전체 배송 개수 조회
    public int getTotalDeliveryCount() {
        int count = 0;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM delivery";
            
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("Admin delivery count retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return count;
    }
    
    // 배송 상태 업데이트
    public boolean updateDeliveryStatus(int d_id, String status) {
        return updateMultipleDeliveryStatus(new int[] {d_id}, status);
    }
    
    // 배송 정보 업데이트 (송장번호, 택배사 등)
    public boolean updateDeliveryInfo(int d_id, String courier, String trackingNum, String memo) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            con = pool.getConnection();
            String sql = "UPDATE delivery SET d_courier = ?, d_tracking_num = ?, d_memo = ? WHERE d_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, courier);
            pstmt.setString(2, trackingNum);
            pstmt.setString(3, memo);
            pstmt.setInt(4, d_id);
            
            int affectedRows = pstmt.executeUpdate();
            if(affectedRows > 0) {
                success = true;
            }
            
        } catch (Exception e) {
            System.out.println("updateDeliveryInfo 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        
        return success;
    }
    
    // 일괄 배송 상태 업데이트
    public boolean updateMultipleDeliveryStatus(int[] d_ids, String status) {
        if (d_ids == null || d_ids.length == 0) return false;
        try {
            inDeliveryTransaction(pool, con -> {
                for (int d_id : d_ids) {
                    updateDeliveryStatus(con, d_id, status);
                }
            });
            return true;
        } catch (SQLException e) {
            System.err.println("Delivery status transaction failed.");
            return false;
        }
    }

    // 화면의 배송/주문 쌍을 모두 잠금 검증한 뒤 요청 전체를 저장한다.
    public boolean updateMultipleDeliveryStatus(int[] deliveryIds, int[] orderIds, String[] statuses) {
        if (deliveryIds == null || orderIds == null || statuses == null
                || deliveryIds.length == 0 || deliveryIds.length != orderIds.length
                || deliveryIds.length != statuses.length) return false;
        Set<Integer> seen = new HashSet<>();
        for (int i = 0; i < deliveryIds.length; i++) {
            if (deliveryIds[i] <= 0 || orderIds[i] <= 0 || !seen.add(deliveryIds[i])) return false;
            if (!"배송준비중".equals(statuses[i]) && !"배송중".equals(statuses[i])
                    && !"배송완료".equals(statuses[i])) return false;
        }
        try {
            inDeliveryTransaction(pool, con -> {
                for (int i = 0; i < deliveryIds.length; i++) {
                    lockDelivery(con, deliveryIds[i], orderIds[i]);
                }
                for (int i = 0; i < deliveryIds.length; i++) {
                    updateDeliveryStatus(con, deliveryIds[i], statuses[i]);
                }
            });
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    // 두 관리자 DAO가 같은 상태/시간 계약을 사용한다. Connection은 호출자가 소유한다.
    static void updateDeliveryStatus(Connection con, int deliveryId, String status) throws SQLException {
        String sql = "UPDATE delivery SET d_status = ?";
        if ("배송준비중".equals(status)) {
            sql += ", shipped_at = NULL, started_at = NULL, completed_at = NULL";
        } else if ("배송중".equals(status)) {
            sql += ", shipped_at = COALESCE(shipped_at, started_at, NOW())"
                 + ", started_at = COALESCE(shipped_at, started_at, NOW()), completed_at = NULL";
        } else if ("배송완료".equals(status)) {
            sql += ", completed_at = COALESCE(completed_at, NOW())";
        } else {
            throw new SQLException("Unsupported delivery status.");
        }
        lockDelivery(con, deliveryId);
        try (PreparedStatement pstmt = con.prepareStatement(sql + " WHERE d_id = ?")) {
            pstmt.setString(1, status);
            pstmt.setInt(2, deliveryId);
            checkDeliveryUpdateCount(pstmt.executeUpdate());
        }
    }

    static void lockDelivery(Connection con, int deliveryId) throws SQLException {
        lockDelivery(con, deliveryId, null);
    }

    static void lockDelivery(Connection con, int deliveryId, Integer orderId) throws SQLException {
        try (PreparedStatement pstmt = con.prepareStatement(
                "SELECT d_id FROM delivery WHERE d_id = ?"
                + (orderId == null ? "" : " AND o_id = ?") + " FOR UPDATE")) {
            pstmt.setInt(1, deliveryId);
            if (orderId != null) pstmt.setInt(2, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next() || rs.next()) {
                    throw new SQLException("Expected exactly one delivery row.");
                }
            }
        }
    }

    static void checkDeliveryUpdateCount(int count) throws SQLException {
        // PK로 한 행을 잠근 뒤 호출한다. changed-rows 모드의 동일 값 재저장은 0일 수 있다.
        if (count < 0 || count > 1) {
            throw new SQLException("Unexpected delivery update count.");
        }
    }

    @FunctionalInterface
    interface DeliveryUpdate {
        void execute(Connection con) throws SQLException;
    }

    static void inDeliveryTransaction(DBConnectionMgr pool, DeliveryUpdate update) throws SQLException {
        Connection con = null;
        boolean transactionStarted = false;
        boolean settled = false;
        try {
            con = pool.getConnection();
            if (!con.getAutoCommit()) {
                throw new SQLException("Connection is not in its default transaction state.");
            }
            con.setAutoCommit(false);
            transactionStarted = true;
            update.execute(con);
            con.commit();
            settled = true;
        } catch (Exception e) {
            SQLException failure = e instanceof SQLException ? (SQLException) e
                    : new SQLException("Delivery transaction failed.", e);
            if (transactionStarted) {
                try {
                    con.rollback();
                    settled = true;
                } catch (SQLException rollbackError) {
                    failure.addSuppressed(rollbackError);
                }
            }
            throw failure;
        } finally {
            if (con != null) {
                // rollback 실패 시 autoCommit(true)로 미확정 변경을 commit하지 않는다.
                if (settled) {
                    try {
                        con.setAutoCommit(true);
                    } catch (SQLException resetError) {
                        settled = false;
                    }
                }
                if (settled) {
                    pool.freeConnection(con);
                } else {
                    pool.removeConnection(con);
                }
            }
        }
    }
} 