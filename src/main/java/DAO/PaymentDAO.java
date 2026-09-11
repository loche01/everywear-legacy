
package DAO;

import java.sql.*;

public class PaymentDAO {
    private DBConnectionMgr pool;
    
    public PaymentDAO() {
        pool = DBConnectionMgr.getInstance();
    }
    
    // 결제 정보 저장 메소드
    public int insertPayment(String userId, String userType, String payStatus, 
                             String payImpUid, String payApplyNum, String payCardName) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int payId = -1;
        
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO payment (user_id, user_type, pay_status, paid_at, pay_imp_uid, pay_apply_num, pay_card_name) " +
                         "VALUES (?, ?, ?, NOW(), ?, ?, ?)";
            
            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setString(2, userType);
            pstmt.setString(3, payStatus);
            pstmt.setString(4, payImpUid);
            pstmt.setString(5, payApplyNum);
            pstmt.setString(6, payCardName);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    payId = rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return payId;
    }
    
    // 결제 정보 조회 메소드
    public boolean getPaymentByImpUid(String impUid) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT * FROM payment WHERE pay_imp_uid = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, impUid);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                exists = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return exists;
    }
    
    // 결제 상태 업데이트 메소드
    public boolean updatePaymentStatus(String impUid, String status) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            con = pool.getConnection();
            String sql = "UPDATE payment SET pay_status = ? WHERE pay_imp_uid = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, impUid);
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                success = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        
        return success;
    } 

		
		//결제
		public boolean insertPay(String id, String type, String imp_uid, String apply_num, String card_name) {
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			boolean flag = false;
			try {
				con = pool.getConnection();
				sql = "insert payment values (null, ?, ?, '결제 완료', now(), ?, ?, ?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, type);
				pstmt.setString(3, imp_uid);
				pstmt.setString(4, apply_num);
				pstmt.setString(5, card_name);
				if(pstmt.executeUpdate() == 1)
					flag = true;

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt);
			}
			return flag;
		}
		
		//pay_id 가져오기
		public int getPay_id(String id, String type, String imp_uid) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			int pay_id = 0;
			try {
				con = pool.getConnection();
				sql = "select pay_id from payment where user_id = ? and user_type = ? and pay_imp_uid = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, type);
				pstmt.setString(3, imp_uid);
				rs = pstmt.executeQuery();
				if(rs.next())
					pay_id = rs.getInt(1);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return pay_id;
		}
}

