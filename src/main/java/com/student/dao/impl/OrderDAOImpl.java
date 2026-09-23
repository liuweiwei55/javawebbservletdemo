package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.OrderDAO;
import com.student.entity.Order;
import com.student.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Date;
import java.util.List;

public class OrderDAOImpl extends BaseDAO<Order> implements OrderDAO {

    private static final Logger logger = LoggerFactory.getLogger(OrderDAOImpl.class);

    @Override
    protected Class<Order> getEntityClass() {
        return Order.class;
    }

    @Override
    public int insert(Order order) {
        String sql = "INSERT INTO `t_order` (order_no, user_id, status, receiver_name, receiver_phone, receiver_province, receiver_city, receiver_district, receiver_address, remark, payment_method, total_amount, discount_amount, actual_amount, create_time) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setString(1, order.getOrderNo());
            pstmt.setInt(2, order.getUserId());
            pstmt.setInt(3, order.getStatus());
            pstmt.setString(4, order.getReceiverName());
            pstmt.setString(5, order.getReceiverPhone());
            pstmt.setString(6, order.getReceiverProvince());
            pstmt.setString(7, order.getReceiverCity());
            pstmt.setString(8, order.getReceiverDistrict());
            pstmt.setString(9, order.getReceiverAddress());
            pstmt.setString(10, order.getRemark());
            pstmt.setInt(11, order.getPaymentMethod());
            pstmt.setBigDecimal(12, order.getTotalAmount());
            pstmt.setBigDecimal(13, order.getDiscountAmount());
            pstmt.setBigDecimal(14, order.getActualAmount());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    order.setId(rs.getInt(1));
                }
            }
            return result;
        } catch (Exception e) {
            logger.error("插入订单失败", e);
            throw new RuntimeException("插入订单失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    @Override
    public int update(Order order) {
        return super.update(order);
    }

    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }

    @Override
    public Order findById(Integer id) {
        return super.findById(id);
    }

    @Override
    public Order getByOrderNo(String orderNo) {
        String sql = "SELECT * FROM `t_order` WHERE order_no = ?";
        return executeQueryForObject(sql, orderNo);
    }

    @Override
    public List<Order> getByUserId(Integer userId) {
        String sql = "SELECT * FROM `t_order` WHERE user_id = ? ORDER BY create_time DESC";
        logger.info("=== getByUserId: userId={}, sql={} ===", userId, sql);
        List<Order> orders = executeQueryForList(sql, userId);
        logger.info("=== getByUserId 结果: {} 个订单 ===", orders != null ? orders.size() : 0);
        if (orders != null) {
            for (Order order : orders) {
                logger.info("  订单 ID: {}, status: {}, create_time: {}", order.getId(), order.getStatus(), order.getCreateTime());
            }
        }
        return orders;
    }

    @Override
    public List<Order> getByStatus(Integer userId, Integer status) {
        String sql = "SELECT * FROM `t_order` WHERE user_id = ? AND status = ? ORDER BY create_time DESC";
        return executeQueryForList(sql, userId, status);
    }

    @Override
    public int updateStatus(Integer orderId, Integer status) {
        String sql = "UPDATE `t_order` SET status = ?, update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, status, orderId);
    }

    @Override
    public int payOrder(Integer orderId, Integer paymentMethod) {
        String sql = "UPDATE `t_order` SET status = 1, payment_method = ?, payment_time = NOW(), update_time = NOW() WHERE id = ? AND status = 0";
        return executeUpdate(sql, paymentMethod, orderId);
    }

    @Override
    public int cancelOrder(Integer orderId, String cancelReason) {
        try {
            String sql = "UPDATE `t_order` SET status = 4, cancel_reason = ?, update_time = NOW() WHERE id = ? AND status = 0";
            return executeUpdate(sql, cancelReason, orderId);
        } catch (RuntimeException e) {
            try {
                executeUpdate("ALTER TABLE `t_order` ADD COLUMN `cancel_reason` VARCHAR(500) NULL");
                String sql = "UPDATE `t_order` SET status = 4, cancel_reason = ?, update_time = NOW() WHERE id = ? AND status = 0";
                return executeUpdate(sql, cancelReason, orderId);
            } catch (Exception ex) {
                throw new RuntimeException("取消订单失败，请确保数据库包含 cancel_reason 字段", ex);
            }
        }
    }

    @Override
    public int shipOrder(Integer orderId, String deliveryCompany, String deliveryNo) {
        String sql = "UPDATE `t_order` SET status = 2, delivery_company = ?, delivery_no = ?, delivery_time = NOW(), update_time = NOW() WHERE id = ? AND status = 1";
        return executeUpdate(sql, deliveryCompany, deliveryNo, orderId);
    }

    @Override
    public int finishOrder(Integer orderId) {
        String sql = "UPDATE `t_order` SET status = 3, finish_time = NOW(), update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, orderId);
    }

    @Override
    public int updateRefundComplete(Integer orderId, int status, java.util.Date refundCompleteTime) {
        try {
            String sql = "UPDATE `t_order` SET status = ?, refund_complete_time = ?, update_time = NOW() WHERE id = ?";
            return executeUpdate(sql, status, refundCompleteTime, orderId);
        } catch (RuntimeException e) {
            try {
                executeUpdate("ALTER TABLE `t_order` ADD COLUMN `refund_complete_time` DATETIME NULL AFTER `finish_time`");
                String sql = "UPDATE `t_order` SET status = ?, refund_complete_time = ?, update_time = NOW() WHERE id = ?";
                return executeUpdate(sql, status, refundCompleteTime, orderId);
            } catch (Exception ex) {
                throw new RuntimeException("更新退款状态失败，请确保数据库包含 refund_complete_time 字段", ex);
            }
        }
    }

    @Override
    public int updateRefundReason(Integer orderId, String refundReason) {
        String sql = "UPDATE `t_order` SET refund_reason = ?, update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, refundReason, orderId);
    }

    /**
     * 更新订单为退款中状态，同时设置退款完成时间和退款原因
     */
    @Override
    public int updateToRefunding(Integer orderId, int status, Date refundCompleteTime, String refundReason) {
        try {
            logger.info("=== updateToRefunding: orderId={}, status={}, refundReason={}, refundCompleteTime={} ===", 
                orderId, status, refundReason, refundCompleteTime);
            String sql = "UPDATE `t_order` SET status = ?, refund_complete_time = ?, refund_reason = ?, update_time = NOW() WHERE id = ?";
            int result = executeUpdate(sql, status, refundCompleteTime, refundReason, orderId);
            logger.info("=== updateToRefunding 结果: {} 行受影响 ===", result);
            return result;
        } catch (RuntimeException e) {
            try {
                executeUpdate("ALTER TABLE `t_order` ADD COLUMN `refund_complete_time` DATETIME NULL AFTER `finish_time`");
                executeUpdate("ALTER TABLE `t_order` ADD COLUMN `refund_reason` VARCHAR(500) NULL AFTER `cancel_reason`");
                String sql = "UPDATE `t_order` SET status = ?, refund_complete_time = ?, refund_reason = ?, update_time = NOW() WHERE id = ?";
                return executeUpdate(sql, status, refundCompleteTime, refundReason, orderId);
            } catch (Exception ex) {
                throw new RuntimeException("更新退款状态失败，请确保数据库包含 refund_complete_time 和 refund_reason 字段", ex);
            }
        }
    }
}