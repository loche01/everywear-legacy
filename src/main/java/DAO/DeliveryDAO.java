
package DAO;

import java.sql.*;
import java.util.Vector;

public class DeliveryDAO {
    private DBConnectionMgr pool;
    
    public DeliveryDAO() {
        pool = DBConnectionMgr.getInstance();
    }
    
    // 배송 정보 저장 메소드
    public int insertDelivery1(int orderId, String deliveryName, String receiverName, 
                             String receiverPhone, String receiverZipcode, 
                             String receiverAddrRoad, String receiverAddrDetail) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int deliveryId = -1;
        
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO delivery (o_id, d_name, recv_name, recv_phone, " + 
                         "recv_zipcode, recv_addr_road, recv_addr_detail, d_status, d_courier, d_tracking_num) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            // 송장번호 생성
            String trackingNumber = generateTrackingNumber();
            
            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, orderId);
            pstmt.setString(2, deliveryName);
            pstmt.setString(3, receiverName);
            pstmt.setString(4, receiverPhone);
            pstmt.setString(5, receiverZipcode);
            pstmt.setString(6, receiverAddrRoad);
            pstmt.setString(7, receiverAddrDetail);
            pstmt.setString(8, "배송준비중"); // 기본 배송 상태
            pstmt.setString(9, "CJ 대한통운"); // 기본 택배사
            pstmt.setString(10, trackingNumber); // 송장번호
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    deliveryId = rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return deliveryId;
    }
    
    // 특정 주문 ID로 배송 정보 조회
    public boolean existsDeliveryWithOrderId(int orderId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM delivery WHERE o_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            
            rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return exists;
    }
    
    // 송장번호 생성 메소드
    private String generateTrackingNumber() {
        // 'EW' 접두사 + 9자리 랜덤 숫자 (EW로 시작하는 CJ대한통운 송장번호 형식)
        StringBuilder trackingNum = new StringBuilder("EW");
        
        // 9자리 랜덤 숫자 생성
        for (int i = 0; i < 9; i++) {
            int digit = (int) (Math.random() * 10); // 0-9 사이의 랜덤 숫자
            trackingNum.append(digit);
        }
        
        return trackingNum.toString();
    }
    
    // 송장번호 조회 메소드
    public String getTrackingNumber(int deliveryId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String trackingNumber = "";
        
        try {
            con = pool.getConnection();
            String sql = "SELECT d_tracking_num FROM delivery WHERE d_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, deliveryId);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                trackingNumber = rs.getString("d_tracking_num");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return trackingNumber;
    }
	
	//배송 
	public void insertDelivery(int o_id, String alias, String name, String phone, String zipcode, String address1, String address2, String tracking_num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "insert delivery values (null, ?, ?, ?, ?, ?, ?, ?, '배송준비중', 'CJ 대한통운', ?, null, null, null, null)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, o_id);
			pstmt.setString(2, alias);
			pstmt.setString(3, name);
			pstmt.setString(4, phone);
			pstmt.setString(5, zipcode);
			pstmt.setString(6, address1);
			pstmt.setString(7, address2);
			pstmt.setString(8, tracking_num);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public Vector<String> getDeliState(int o_id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<String> slist = new Vector<String>();
		try {
			con = pool.getConnection();
			sql = "select d_status from delivery where o_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, o_id)	;
			rs = pstmt.executeQuery();
			while(rs.next()) {
				slist.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return slist;
	}
}
