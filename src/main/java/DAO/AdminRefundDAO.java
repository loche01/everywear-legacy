package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Refund queries, one-time request creation, and administrative status transitions. */
public class AdminRefundDAO {
    private final DBConnectionMgr pool = DBConnectionMgr.getInstance();
    // Existing Lee refund-screen reason labels, not a new code taxonomy.
    public static final List<String> REQUEST_REASON_CODES = List.of("상품 불량", "단순 변심", "사이즈 불만족");
    public static final int MAX_REASON_TEXT_LENGTH = 1000;
    private static final String REFUND_COLUMNS =
            "r.rf_id, r.rf_amount, r.rf_quantity, r.rf_reason_code, r.rf_reason_text, "
            + "r.refunded_at, r.admin_id, r.rf_status";
    private static final String RELATED_COLUMNS =
            ", a.admin_name, o.o_id, o.o_num, o.o_name, o.o_phone, o.o_quantity, "
            + "o.o_total_amount, o.created_at, pd.pd_id, pd.pd_size, p.p_name";
    private static final String RELATED_JOINS =
            " LEFT JOIN admin a ON a.admin_id = r.admin_id"
            + " LEFT JOIN orders o ON o.rf_id = r.rf_id"
            + " LEFT JOIN product_detail pd ON pd.pd_id = o.pd_id"
            + " LEFT JOIN product p ON p.p_id = pd.p_id";

    public int getRefundCount(String orderNumber, String status) throws SQLException {
        List<String> parameters = new ArrayList<>();
        String sql = "SELECT COUNT(*) AS refund_count FROM refund r" + conditions(orderNumber, status, parameters);
        Connection con = openConnection();
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            bind(stmt, parameters);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) throw new SQLException("Refund count unavailable.");
                return rs.getInt("refund_count");
            }
        } finally {
            pool.freeConnection(con);
        }
    }

    public List<Map<String, Object>> getRefundList(String orderNumber, String status,
            int start, int pageSize) throws SQLException {
        if (start < 0 || pageSize < 1 || pageSize > 100) {
            throw new IllegalArgumentException("Invalid refund page.");
        }
        List<String> parameters = new ArrayList<>();
        String where = conditions(orderNumber, status, parameters);
        // Page refund IDs before joining orders: multiple orders must not split a refund across pages.
        String sql = "SELECT " + REFUND_COLUMNS + RELATED_COLUMNS
                + " FROM (SELECT " + REFUND_COLUMNS + " FROM refund r" + where
                + " ORDER BY r.rf_id DESC LIMIT ?, ?) r" + RELATED_JOINS
                + " ORDER BY r.rf_id DESC, o.o_id ASC";
        Connection con = openConnection();
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            int next = bind(stmt, parameters);
            stmt.setInt(next++, start);
            stmt.setInt(next, pageSize);
            try (ResultSet rs = stmt.executeQuery()) {
                return readRefunds(rs);
            }
        } finally {
            pool.freeConnection(con);
        }
    }

    /** Null means no refund. An existing orphan refund has an empty orders list. */
    public Map<String, Object> getRefundDetail(int refundId) throws SQLException {
        if (refundId <= 0) throw new IllegalArgumentException("Invalid refund ID.");
        String sql = "SELECT " + REFUND_COLUMNS + RELATED_COLUMNS + " FROM refund r"
                + RELATED_JOINS + " WHERE r.rf_id = ? ORDER BY o.o_id ASC";
        Connection con = openConnection();
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, refundId);
            try (ResultSet rs = stmt.executeQuery()) {
                List<Map<String, Object>> rows = readRefunds(rs);
                return rows.isEmpty() ? null : rows.get(0);
            }
        } finally {
            pool.freeConnection(con);
        }
    }

    public int createRefundForOrder(int orderId, int quantity, int amount,
            String reasonCode, String reasonText) throws SQLException {
        if (orderId <= 0 || quantity <= 0 || amount <= 0 || reasonCode == null || !REQUEST_REASON_CODES.contains(reasonCode)
                || (reasonText != null && reasonText.length() > MAX_REASON_TEXT_LENGTH)) {
            throw new SQLException("Invalid refund request.");
        }
        String text = reasonText == null || reasonText.isBlank() ? null : reasonText.trim();
        Connection con = null;
        boolean transactionStarted = false;
        boolean settled = false;
        try {
            con = openConnection();
            if (!con.getAutoCommit()) throw new SQLException("Connection is not in its default transaction state.");
            con.setAutoCommit(false);
            transactionStarted = true;
            // Concurrent requests for the same order serialize here, before any refund is inserted.
            try (PreparedStatement stmt = con.prepareStatement(
                    "SELECT rf_id, o_quantity, o_total_amount FROM orders WHERE o_id = ? FOR UPDATE")) {
                stmt.setInt(1, orderId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (!rs.next() || rs.getObject("rf_id") != null
                            || quantity != rs.getInt("o_quantity") || amount != rs.getInt("o_total_amount")) {
                        throw new SQLException("Order cannot accept this refund request.");
                    }
                }
            }
            int refundId;
            try (PreparedStatement stmt = con.prepareStatement(
                    "INSERT INTO refund (rf_amount, rf_quantity, rf_reason_code, rf_reason_text, "
                    + "refunded_at, admin_id, rf_status) VALUES (?, ?, ?, ?, NULL, NULL, '신청됨')",
                    Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, amount);
                stmt.setInt(2, quantity);
                stmt.setString(3, reasonCode);
                stmt.setString(4, text);
                if (stmt.executeUpdate() != 1) throw new SQLException("Refund request was not inserted.");
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Refund request key unavailable.");
                    refundId = keys.getInt(1);
                    if (refundId <= 0 || keys.next()) throw new SQLException("Invalid refund request key.");
                }
            }
            try (PreparedStatement stmt = con.prepareStatement(
                    "UPDATE orders SET rf_id = ? WHERE o_id = ? AND rf_id IS NULL")) {
                stmt.setInt(1, refundId);
                stmt.setInt(2, orderId);
                if (stmt.executeUpdate() != 1) throw new SQLException("Refund request was not linked.");
            }
            try (PreparedStatement stmt = con.prepareStatement(
                    "SELECT r.rf_id FROM orders o JOIN refund r ON r.rf_id = o.rf_id "
                    + "WHERE o.o_id = ? AND r.rf_id = ?")) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, refundId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (!rs.next() || rs.getInt("rf_id") != refundId || rs.next()) {
                        throw new SQLException("Refund request relationship could not be verified.");
                    }
                }
            }
            con.commit();
            settled = true;
            return refundId;
        } catch (Exception e) {
            SQLException failure = e instanceof SQLException ? (SQLException)e
                    : new SQLException("Refund request transaction failed.", e);
            if (transactionStarted) {
                try {
                    con.rollback();
                    settled = true;
                } catch (SQLException rollbackError) {
                    failure.addSuppressed(rollbackError);
                }
            }
            // Never retry a failed/uncertain commit automatically.
            throw failure;
        } finally {
            if (con != null) {
                // An unresolved transaction must never be committed by restoring autoCommit.
                if (settled) {
                    try {
                        con.setAutoCommit(true);
                    } catch (SQLException resetError) {
                        settled = false;
                    }
                }
                if (settled) pool.freeConnection(con);
                else pool.removeConnection(con);
            }
        }
    }

    public void updateRefundStatusForOrder(int orderId, int refundId,
            String requestedStatus, String adminId) throws SQLException {
        String actor = adminId == null ? null : adminId.trim();
        if (orderId <= 0 || refundId <= 0 || requestedStatus == null
                || !List.of("신청됨", "처리중", "완료", "거절").contains(requestedStatus)
                || actor == null || actor.isEmpty() || actor.length() > 20) {
            throw new SQLException("Invalid refund status request.");
        }

        Connection con = null;
        boolean transactionStarted = false;
        boolean settled = false;
        try {
            con = openConnection();
            if (!con.getAutoCommit()) throw new SQLException("Connection is not in its default transaction state.");
            con.setAutoCommit(false);
            transactionStarted = true;

            String currentStatus = null;
            java.sql.Timestamp currentRefundedAt = null;
            String currentAdminId = null;
            int relationshipCount = 0;
            boolean requestedOrderFound = false;
            try (PreparedStatement stmt = con.prepareStatement(
                    "SELECT o.o_id, r.rf_status, r.refunded_at, r.admin_id "
                    + "FROM refund r JOIN orders o ON o.rf_id = r.rf_id "
                    + "WHERE r.rf_id = ? ORDER BY o.o_id FOR UPDATE")) {
                stmt.setInt(1, refundId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        relationshipCount++;
                        requestedOrderFound |= rs.getInt("o_id") == orderId;
                        currentStatus = rs.getString("rf_status");
                        currentRefundedAt = rs.getTimestamp("refunded_at");
                        currentAdminId = rs.getString("admin_id");
                    }
                }
            }
            if (relationshipCount != 1 || !requestedOrderFound || currentStatus == null) {
                throw new SQLException("Refund relationship could not be verified.");
            }
            if (!isAllowedStatusTransition(currentStatus, requestedStatus)) {
                throw new SQLException("Refund status transition is not allowed.");
            }

            if (currentStatus.equals(requestedStatus)) {
                if (!hasValidProcessingFields(currentStatus, currentRefundedAt, currentAdminId)) {
                    throw new SQLException("Refund processing fields are inconsistent.");
                }
            } else {
                String sql;
                if ("완료".equals(requestedStatus)) {
                    sql = "UPDATE refund SET rf_status = ?, refunded_at = CURRENT_TIMESTAMP, admin_id = ? "
                            + "WHERE rf_id = ? AND rf_status = ? AND refunded_at IS NULL AND admin_id IS NULL";
                } else {
                    sql = "UPDATE refund SET rf_status = ?, refunded_at = NULL, admin_id = NULL "
                            + "WHERE rf_id = ? AND rf_status = ? AND refunded_at IS NULL AND admin_id IS NULL";
                }
                try (PreparedStatement stmt = con.prepareStatement(sql)) {
                    stmt.setString(1, requestedStatus);
                    int index = 2;
                    if ("완료".equals(requestedStatus)) stmt.setString(index++, actor);
                    stmt.setInt(index++, refundId);
                    stmt.setString(index, currentStatus);
                    if (stmt.executeUpdate() != 1) {
                        throw new SQLException("Refund status was not updated.");
                    }
                }
            }

            try (PreparedStatement stmt = con.prepareStatement(
                    "SELECT rf_status, refunded_at, admin_id FROM refund WHERE rf_id = ?")) {
                stmt.setInt(1, refundId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (!rs.next() || !requestedStatus.equals(rs.getString("rf_status"))
                            || !hasValidProcessingFields(requestedStatus,
                                    rs.getTimestamp("refunded_at"), rs.getString("admin_id"))
                            || rs.next()) {
                        throw new SQLException("Refund status could not be verified.");
                    }
                }
            }

            con.commit();
            settled = true;
        } catch (Exception e) {
            SQLException failure = e instanceof SQLException ? (SQLException)e
                    : new SQLException("Refund status transaction failed.", e);
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
                if (settled) {
                    try {
                        con.setAutoCommit(true);
                    } catch (SQLException resetError) {
                        settled = false;
                    }
                }
                if (settled) pool.freeConnection(con);
                else pool.removeConnection(con);
            }
        }
    }

    private boolean isAllowedStatusTransition(String currentStatus, String requestedStatus) {
        if (currentStatus.equals(requestedStatus)) return true;
        if ("신청됨".equals(currentStatus)) {
            return "처리중".equals(requestedStatus) || "거절".equals(requestedStatus);
        }
        if ("처리중".equals(currentStatus)) {
            return "완료".equals(requestedStatus) || "거절".equals(requestedStatus);
        }
        return false;
    }

    private boolean hasValidProcessingFields(String status, java.sql.Timestamp refundedAt, String adminId) {
        if ("완료".equals(status)) {
            return refundedAt != null && adminId != null && !adminId.trim().isEmpty();
        }
        return refundedAt == null && adminId == null;
    }

    private String conditions(String orderNumber, String status, List<String> parameters) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");
        if (orderNumber != null && !orderNumber.trim().isEmpty()) {
            where.append(" AND EXISTS (SELECT 1 FROM orders matched WHERE matched.rf_id = r.rf_id"
                    + " AND matched.o_num LIKE ? ESCAPE '!')");
            String literal = orderNumber.trim().replace("!", "!!").replace("%", "!%").replace("_", "!_");
            parameters.add("%" + literal + "%");
        }
        if (status != null && !status.isEmpty()) {
            if (!List.of("신청됨", "처리중", "완료", "거절").contains(status)) {
                throw new IllegalArgumentException("Invalid refund status.");
            }
            where.append(" AND r.rf_status = ?");
            parameters.add(status);
        }
        return where.toString();
    }

    private int bind(PreparedStatement stmt, List<String> parameters) throws SQLException {
        int index = 1;
        for (String value : parameters) stmt.setString(index++, value);
        return index;
    }

    private Connection openConnection() throws SQLException {
        try {
            return pool.getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("Refund connection unavailable.", e);
        }
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> readRefunds(ResultSet rs) throws SQLException {
        Map<Integer, Map<String, Object>> refunds = new LinkedHashMap<>();
        while (rs.next()) {
            int id = rs.getInt("rf_id");
            Map<String, Object> refund = refunds.get(id);
            if (refund == null) {
                refund = new LinkedHashMap<>();
                refund.put("rf_id", id);
                refund.put("rf_amount", rs.getInt("rf_amount"));
                refund.put("rf_quantity", rs.getInt("rf_quantity"));
                refund.put("rf_reason_code", rs.getString("rf_reason_code"));
                refund.put("rf_reason_text", rs.getString("rf_reason_text"));
                refund.put("refunded_at", rs.getTimestamp("refunded_at"));
                refund.put("admin_id", rs.getString("admin_id"));
                refund.put("admin_name", rs.getString("admin_name"));
                refund.put("rf_status", rs.getString("rf_status"));
                refund.put("orders", new ArrayList<Map<String, Object>>());
                refunds.put(id, refund);
            }
            if (rs.getObject("o_id") != null) {
                Map<String, Object> order = new LinkedHashMap<>();
                for (String field : new String[]{"o_id", "o_num", "o_name", "o_phone", "o_quantity",
                        "o_total_amount", "pd_id", "pd_size", "p_name"}) {
                    order.put(field, rs.getObject(field));
                }
                order.put("created_at", rs.getTimestamp("created_at"));
                ((List<Map<String, Object>>) refund.get("orders")).add(order);
            }
        }
        return new ArrayList<>(refunds.values());
    }
}
