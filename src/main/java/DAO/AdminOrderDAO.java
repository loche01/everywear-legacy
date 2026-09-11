package DAO;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class AdminOrderDAO {
    private DBConnectionMgr pool;
    
    public AdminOrderDAO() {
        pool = DBConnectionMgr.getInstance();
    }
    
    // 모든 주문 정보를 조회하는 메소드
    public List<Map<String, Object>> getAllOrders(int start, int count) {
        List<Map<String, Object>> orderList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            
            // 주문 정보와 함께 상품명, 결제 상태, 배송 상태, 환불 상태를 함께 조회
            String sql = 
            "SELECT o.o_id, o.o_num, o.created_at, o.o_isMember, o.user_id, o.user_type, o.o_name, " +
            "p.p_name, o.o_quantity, o.o_total_amount, pay.pay_status, d.d_status, " +
            "r.rf_status, pd.pd_id " +
            "FROM orders o " +
            "JOIN product_detail pd ON o.pd_id = pd.pd_id " +
            "JOIN product p ON pd.p_id = p.p_id " +
            "LEFT JOIN payment pay ON o.pay_id = pay.pay_id " +
            "LEFT JOIN delivery d ON o.o_id = d.o_id " +
            "LEFT JOIN refund r ON o.rf_id = r.rf_id " +
            "ORDER BY o.created_at DESC " +
            "LIMIT ?, ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, start);
            pstmt.setInt(2, count);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> orderInfo = new HashMap<>();
                
                // 주문 기본 정보
                orderInfo.put("o_id", rs.getInt("o_id"));
                orderInfo.put("o_num", rs.getString("o_num"));
                
                // 날짜 포맷팅
                Timestamp createdAt = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                orderInfo.put("created_at", sdf.format(new Date(createdAt.getTime())));
                
                // 회원 정보
                orderInfo.put("o_isMember", rs.getString("o_isMember")); // Y 또는 N
                orderInfo.put("user_id", rs.getString("user_id"));
                orderInfo.put("user_type", rs.getString("user_type"));
                orderInfo.put("o_name", rs.getString("o_name"));
                
                // 상품 정보
                orderInfo.put("p_name", rs.getString("p_name"));
                orderInfo.put("o_quantity", rs.getInt("o_quantity"));
                orderInfo.put("o_total_amount", rs.getInt("o_total_amount"));
                orderInfo.put("pd_id", rs.getInt("pd_id"));
                
                // 상태 정보
                orderInfo.put("pay_status", rs.getString("pay_status"));
                orderInfo.put("d_status", rs.getString("d_status"));
                orderInfo.put("rf_status", rs.getString("rf_status"));
                
                orderList.add(orderInfo);
            }
            
        } catch (Exception e) {
            System.err.println("Admin order list retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return orderList;
    }
    
    // 총 주문 수를 조회하는 메소드
    public int getTotalOrderCount() {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            con = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM orders";
            
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("Admin order count retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return total;
    }
    
    // 주문 번호로 주문 정보를 조회하는 메소드
    public List<Map<String, Object>> getOrdersByOrderNumber(String orderNumber) {
        List<Map<String, Object>> orderList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            
            // 특정 주문 번호에 해당하는 주문들 조회
            String sql = 
            "SELECT o.o_id, o.o_num, o.created_at, o.o_isMember, o.user_id, o.user_type, o.o_name, " +
            "p.p_name, o.o_quantity, o.o_total_amount, pay.pay_status, d.d_status, " +
            "r.rf_status, pd.pd_id " +
            "FROM orders o " +
            "JOIN product_detail pd ON o.pd_id = pd.pd_id " +
            "JOIN product p ON pd.p_id = p.p_id " +
            "LEFT JOIN payment pay ON o.pay_id = pay.pay_id " +
            "LEFT JOIN delivery d ON o.o_id = d.o_id " +
            "LEFT JOIN refund r ON o.rf_id = r.rf_id " +
            "WHERE o.o_num = ? " +
            "ORDER BY o.created_at DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, orderNumber);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> orderInfo = new HashMap<>();
                
                // 주문 기본 정보
                orderInfo.put("o_id", rs.getInt("o_id"));
                orderInfo.put("o_num", rs.getString("o_num"));
                
                // 날짜 포맷팅
                Timestamp createdAt = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                orderInfo.put("created_at", sdf.format(new Date(createdAt.getTime())));
                
                // 회원 정보
                orderInfo.put("o_isMember", rs.getString("o_isMember")); // Y 또는 N
                orderInfo.put("user_id", rs.getString("user_id"));
                orderInfo.put("user_type", rs.getString("user_type"));
                orderInfo.put("o_name", rs.getString("o_name"));
                
                // 상품 정보
                orderInfo.put("p_name", rs.getString("p_name"));
                orderInfo.put("o_quantity", rs.getInt("o_quantity"));
                orderInfo.put("o_total_amount", rs.getInt("o_total_amount"));
                orderInfo.put("pd_id", rs.getInt("pd_id"));
                
                // 상태 정보
                orderInfo.put("pay_status", rs.getString("pay_status"));
                orderInfo.put("d_status", rs.getString("d_status"));
                orderInfo.put("rf_status", rs.getString("rf_status"));
                
                orderList.add(orderInfo);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return orderList;
    }
    
    // 검색 타입에 따른 주문 정보 조회 메소드 (주문번호, 주문자명, 상품명)
    public List<Map<String, Object>> searchOrders(String searchType, String keyword) {
        List<Map<String, Object>> orderList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            
            // 기본 SQL 쿼리
            String sql = 
            "SELECT o.o_id, o.o_num, o.created_at, o.o_isMember, o.user_id, o.user_type, o.o_name, " +
            "p.p_name, o.o_quantity, o.o_total_amount, pay.pay_status, d.d_status, " +
            "r.rf_status, pd.pd_id " +
            "FROM orders o " +
            "JOIN product_detail pd ON o.pd_id = pd.pd_id " +
            "JOIN product p ON pd.p_id = p.p_id " +
            "LEFT JOIN payment pay ON o.pay_id = pay.pay_id " +
            "LEFT JOIN delivery d ON o.o_id = d.o_id " +
            "LEFT JOIN refund r ON o.rf_id = r.rf_id ";
            
            // 검색 타입에 따라 WHERE 조건 추가
            if ("orderNumber".equals(searchType)) {
                sql += "WHERE o.o_num LIKE ? ";
            } else if ("orderName".equals(searchType)) {
                sql += "WHERE o.o_name LIKE ? ";
            } else if ("productName".equals(searchType)) {
                sql += "WHERE p.p_name LIKE ? ";
            }
            
            sql += "ORDER BY o.created_at DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%"); // LIKE 검색을 위해 와일드카드 추가
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> orderInfo = new HashMap<>();
                
                // 주문 기본 정보
                orderInfo.put("o_id", rs.getInt("o_id"));
                orderInfo.put("o_num", rs.getString("o_num"));
                
                // 날짜 포맷팅
                Timestamp createdAt = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                orderInfo.put("created_at", sdf.format(new Date(createdAt.getTime())));
                
                // 회원 정보
                orderInfo.put("o_isMember", rs.getString("o_isMember")); // Y 또는 N
                orderInfo.put("user_id", rs.getString("user_id"));
                orderInfo.put("user_type", rs.getString("user_type"));
                orderInfo.put("o_name", rs.getString("o_name"));
                
                // 상품 정보
                orderInfo.put("p_name", rs.getString("p_name"));
                orderInfo.put("o_quantity", rs.getInt("o_quantity"));
                orderInfo.put("o_total_amount", rs.getInt("o_total_amount"));
                orderInfo.put("pd_id", rs.getInt("pd_id"));
                
                // 상태 정보
                orderInfo.put("pay_status", rs.getString("pay_status"));
                orderInfo.put("d_status", rs.getString("d_status"));
                orderInfo.put("rf_status", rs.getString("rf_status"));
                
                orderList.add(orderInfo);
            }
            
        } catch (Exception e) {
            System.err.println("Admin order search failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return orderList;
    }
    
    // 주문 ID로 주문 상세 정보를 조회하는 메소드
    public Map<String, Object> getOrderDetailById(int orderId) {
        Map<String, Object> orderDetail = new HashMap<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = pool.getConnection();
            
            // 주문 상세 정보 조회
            String sql = 
            "SELECT o.*, p.p_name, p.p_price, p.p_id, pd.pd_size, " +
            "pay.pay_id, pay.pay_status, pay.pay_card_name, pay.pay_imp_uid, pay.pay_apply_num, pay.paid_at, " +
            "d.d_id, d.d_name, d.recv_name, d.recv_phone, d.recv_zipcode, d.recv_addr_road, d.recv_addr_detail, " +
            "d.d_status, d.d_courier, d.d_tracking_num, d.shipped_at, d.completed_at, " +
            "r.rf_id, r.rf_status, r.rf_amount, r.rf_reason_text, r.refunded_at " + // 실제 컬럼명으로 수정
            "FROM orders o " +
            "JOIN product_detail pd ON o.pd_id = pd.pd_id " +
            "JOIN product p ON pd.p_id = p.p_id " +
            "LEFT JOIN payment pay ON o.pay_id = pay.pay_id " +
            "LEFT JOIN delivery d ON o.o_id = d.o_id " +
            "LEFT JOIN refund r ON o.rf_id = r.rf_id " +
            "WHERE o.o_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // 주문 기본 정보
                orderDetail.put("o_id", rs.getInt("o_id"));
                orderDetail.put("o_num", rs.getString("o_num"));
                orderDetail.put("created_at", formatTimestamp(rs.getTimestamp("created_at")));
                orderDetail.put("o_isMember", rs.getString("o_isMember"));
                orderDetail.put("user_id", rs.getString("user_id"));
                orderDetail.put("user_type", rs.getString("user_type"));
                orderDetail.put("o_name", rs.getString("o_name"));
                orderDetail.put("o_phone", rs.getString("o_phone"));
                orderDetail.put("o_quantity", rs.getInt("o_quantity"));
                orderDetail.put("o_total_amount", rs.getInt("o_total_amount"));
                
                // 상품 정보
                orderDetail.put("p_id", rs.getInt("p_id"));
                orderDetail.put("p_name", rs.getString("p_name"));
                orderDetail.put("p_price", rs.getInt("p_price"));
                orderDetail.put("pd_id", rs.getInt("pd_id"));
                orderDetail.put("pd_size", rs.getString("pd_size"));
                
                // 결제 정보
                orderDetail.put("pay_id", rs.getInt("pay_id"));
                orderDetail.put("pay_status", rs.getString("pay_status"));
                
                orderDetail.put("imp_uid", rs.getString("pay_imp_uid"));
                orderDetail.put("apply_num", rs.getString("pay_apply_num"));
                orderDetail.put("card_name", rs.getString("pay_card_name"));
                Timestamp paidAt = rs.getTimestamp("paid_at");
                orderDetail.put("pay_date", paidAt == null ? null : formatTimestamp(paidAt));
                
                // 배송 정보
                orderDetail.put("d_id", rs.getInt("d_id"));
                orderDetail.put("d_name", rs.getString("d_name"));
                orderDetail.put("recv_name", rs.getString("recv_name"));
                orderDetail.put("recv_phone", rs.getString("recv_phone"));
                orderDetail.put("recv_zipcode", rs.getString("recv_zipcode"));
                orderDetail.put("recv_addr_road", rs.getString("recv_addr_road"));
                orderDetail.put("recv_addr_detail", rs.getString("recv_addr_detail"));
                orderDetail.put("d_status", rs.getString("d_status"));
                orderDetail.put("d_courier", rs.getString("d_courier"));
                orderDetail.put("d_tracking_num", rs.getString("d_tracking_num"));
                
                Timestamp shippedAt = rs.getTimestamp("shipped_at");
                if (shippedAt != null) {
                    orderDetail.put("shipped_at", formatTimestamp(shippedAt));
                }
                
                Timestamp completedAt = rs.getTimestamp("completed_at");
                if (completedAt != null) {
                    orderDetail.put("completed_at", formatTimestamp(completedAt));
                }
                
                // 환불 정보
                orderDetail.put("rf_id", rs.getInt("rf_id"));
                orderDetail.put("rf_status", rs.getString("rf_status"));
                orderDetail.put("rf_reason", rs.getString("rf_reason_text")); // 실제 컬럼명으로 수정
                orderDetail.put("rf_amount", rs.getInt("rf_amount")); // 실제 컬럼명으로 수정
                
                Timestamp refundedAt = rs.getTimestamp("refunded_at");
                if (refundedAt != null) {
                    orderDetail.put("rf_date", formatTimestamp(refundedAt)); // 실제 컬럼명으로 수정
                } else {
                    orderDetail.put("rf_date", null);
                }
            }
            
        } catch (Exception e) {
            System.err.println("Admin order detail retrieval failed.");
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return orderDetail;
    }
    
    // 배송 상태 변경 메소드
    public boolean updateDeliveryStatus(int deliveryId, String status) {
        return new AdminDeliveryDAO().updateDeliveryStatus(deliveryId, status);
    }
    
    // 결제 상태 변경 메소드
    public boolean updatePaymentStatus(int paymentId, String status) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            con = pool.getConnection();
            String sql = "UPDATE payment SET pay_status = ? WHERE pay_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, paymentId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        
        return success;
    }
    
    // 요청한 주문과 결제를 같은 트랜잭션에서 잠근 뒤 갱신한다.
    public boolean updatePaymentStatus(int orderId, int paymentId, String status) {
        if (orderId <= 0 || paymentId <= 0) return false;
        if (!"결제 완료".equals(status) && !"환불 처리중".equals(status)
                && !"환불 완료".equals(status)) return false;
        try {
            AdminDeliveryDAO.inDeliveryTransaction(pool, con -> {
                try (PreparedStatement pstmt = con.prepareStatement(
                        "SELECT p.pay_id FROM payment p JOIN orders o ON o.pay_id = p.pay_id "
                        + "WHERE p.pay_id = ? AND o.o_id = ? FOR UPDATE")) {
                    pstmt.setInt(1, paymentId);
                    pstmt.setInt(2, orderId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (!rs.next() || rs.next()) {
                            throw new SQLException("Order/payment relationship not found.");
                        }
                    }
                }
                try (PreparedStatement pstmt = con.prepareStatement(
                        "UPDATE payment SET pay_status = ? WHERE pay_id = ?")) {
                    pstmt.setString(1, status);
                    pstmt.setInt(2, paymentId);
                    int count = pstmt.executeUpdate();
                    // 잠근 결제가 존재하므로 changed-rows 모드의 동일 값 저장 0행은 허용한다.
                    if (count < 0 || count > 1) {
                        throw new SQLException("Unexpected payment update count.");
                    }
                }
            });
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    // 기존 내부 호출부의 signature는 유지한다.
    public boolean updateTrackingAndDeliveryStatus(int deliveryId, String trackingNumber) {
        return updateTrackingAndDeliveryStatus(null, deliveryId, trackingNumber);
    }

    public boolean updateTrackingAndDeliveryStatus(int orderId, int deliveryId, String trackingNumber) {
        if (orderId <= 0 || deliveryId <= 0) return false;
        return updateTrackingAndDeliveryStatus(Integer.valueOf(orderId), deliveryId, trackingNumber);
    }

    // 송장 저장과 자동 배송 시작을 하나의 Connection/트랜잭션으로 처리한다.
    private boolean updateTrackingAndDeliveryStatus(Integer orderId, int deliveryId, String trackingNumber) {
        final String tracking = trackingNumber == null ? "" : trackingNumber;
        try {
            AdminDeliveryDAO.inDeliveryTransaction(pool, con -> {
                AdminDeliveryDAO.lockDelivery(con, deliveryId, orderId);
                try (PreparedStatement pstmt = con.prepareStatement(
                        "UPDATE delivery SET d_tracking_num = ? WHERE d_id = ?")) {
                    pstmt.setString(1, tracking);
                    pstmt.setInt(2, deliveryId);
                    AdminDeliveryDAO.checkDeliveryUpdateCount(pstmt.executeUpdate());
                }
                if (!tracking.isEmpty()) {
                    AdminDeliveryDAO.updateDeliveryStatus(con, deliveryId, "배송중");
                }
            });
            return true;
        } catch (SQLException e) {
            System.err.println("Delivery tracking transaction failed.");
            return false;
        }
    }

    // 송장번호 업데이트 메소드
    public boolean updateTrackingNumber(int deliveryId, String trackingNumber) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            con = pool.getConnection();
            String sql = "UPDATE delivery SET d_tracking_num = ? WHERE d_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, trackingNumber);
            pstmt.setInt(2, deliveryId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        
        return success;
    }
    
    // 타임스탬프 포맷팅 유틸리티 메소드
    private String formatTimestamp(Timestamp timestamp) {
        if (timestamp == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date(timestamp.getTime()));
    }
} 