
package DAO;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import DTO.OrdersDTO;

public class OrderDAO {
    private DBConnectionMgr pool;
    
    public OrderDAO() {
        pool = DBConnectionMgr.getInstance();
    }
	private final SimpleDateFormat SDF_DATE = new SimpleDateFormat("yyyy-MM-dd");
    
    // 주문 정보 저장 메소드
    public int insertOrder1(String userId, String userType, int pdId, String orderNumber, 
                           String isMember, String orderName, String orderPhone, 
                           int quantity, int totalAmount, int payId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int orderId = -1;
        
        try {
            con = pool.getConnection();
            String sql = "INSERT INTO orders (user_id, user_type, pd_id, o_num, o_isMember, " + 
                         "o_name, o_phone, o_quantity, created_at, o_total_amount, pay_id) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?)";
            
            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, userId);
            pstmt.setString(2, userType);
            pstmt.setInt(3, pdId);
            pstmt.setString(4, orderNumber);
            pstmt.setString(5, isMember);
            pstmt.setString(6, orderName);
            pstmt.setString(7, orderPhone);
            pstmt.setInt(8, quantity);
            pstmt.setInt(9, totalAmount);
            pstmt.setInt(10, payId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return orderId;
    }
    
    // 주문 번호 생성 메소드
    public String generateOrderNumber() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        
        // 랜덤한 영문 및 숫자 조합 생성 (8자리)
        String randomStr = generateRandomString(8);
        
        return "ORD" + dateStr + randomStr;
    }
    
    // 랜덤 문자열 생성 메소드
    private String generateRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        
        return sb.toString();
    }
    
    // 특정 결제 ID로 주문 정보 조회
    public boolean existsOrderWithPayId(int payId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM orders WHERE pay_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, payId);
            
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

	//주문 넣기
	public int insertOrder(String id, String type, int pd_id, String o_num, String isMember, String name, String phone, int quantity, int price, int pay_id) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    int generatedOid = -1; // 생성된 o_id 저장할 변수

	    try {
	        con = pool.getConnection();
	        sql = "INSERT INTO orders VALUES (null, ?, ?, ?, ?, ?, ?, ?, ?, now(), ?, ?, null)";
	        pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // KEY 반환 옵션 추가

	        pstmt.setString(1, id);
	        pstmt.setString(2, type);
	        pstmt.setInt(3, pd_id);
	        pstmt.setString(4, o_num);
	        pstmt.setString(5, isMember);
	        pstmt.setString(6, name);
	        pstmt.setString(7, phone);
	        pstmt.setInt(8, quantity);
	        pstmt.setInt(9, price);
	        pstmt.setInt(10, pay_id);

	        int affectedRows = pstmt.executeUpdate();

	        if (affectedRows == 1) {
	            rs = pstmt.getGeneratedKeys(); // 생성된 키 가져오기
	            if (rs.next()) {
	                generatedOid = rs.getInt(1); // 첫 번째 키(o_id)
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }

	    return generatedOid; // -1이면 실패
	}
	
	//주문내역
	public Vector<OrdersDTO> getOrderHistory(String id, String type){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<OrdersDTO> olist = new Vector<OrdersDTO>();
		try {
			con = pool.getConnection();
			sql = "select * from orders where user_id = ? and user_type = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, type);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				olist.add(new OrdersDTO(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4), 
						rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getInt(9), SDF_DATE.format(rs.getDate(10)), rs.getInt(11), rs.getInt(12), rs.getInt(13)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return olist;
	}
}

