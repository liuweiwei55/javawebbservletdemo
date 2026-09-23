package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.OrderItemDAO;
import com.student.entity.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.student.util.DBUtil;

public class OrderItemDAOImpl extends BaseDAO<OrderItem> implements OrderItemDAO {

    @Override
    protected Class<OrderItem> getEntityClass() {
        return OrderItem.class;
    }

    @Override
    public int insert(OrderItem orderItem) {
        String sql = "INSERT INTO t_order_item (order_id, product_id, product_name, product_image, price, original_price, quantity, subtotal, create_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try {
            return doInsert(orderItem, sql);
        } catch (RuntimeException e) {
            try {
                executeUpdate("ALTER TABLE t_order_item ADD COLUMN original_price DECIMAL(10,2) NULL AFTER price");
            } catch (Exception ex) {
                logger.warn("无法添加original_price列: {}", ex.getMessage());
            }
            return doInsert(orderItem, sql);
        }
    }

    private int doInsert(OrderItem orderItem, String sql) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getProductId());
            pstmt.setString(3, orderItem.getProductName());
            pstmt.setString(4, orderItem.getProductImage());
            pstmt.setBigDecimal(5, orderItem.getPrice());
            pstmt.setBigDecimal(6, orderItem.getOriginalPrice());
            pstmt.setInt(7, orderItem.getQuantity());
            pstmt.setBigDecimal(8, orderItem.getSubtotal());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            logger.error("插入订单项失败", e);
            throw new RuntimeException("插入订单项失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    @Override
    public int update(OrderItem orderItem) {
        return super.update(orderItem);
    }

    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }

    @Override
    public OrderItem findById(Integer id) {
        return super.findById(id);
    }

    @Override
    public List<OrderItem> getByOrderId(Integer orderId) {
        String sql = "SELECT * FROM t_order_item WHERE order_id = ?";
        return executeQueryForList(sql, orderId);
    }

    @Override
    public int batchInsert(List<OrderItem> orderItems) {
        String sql = "INSERT INTO t_order_item (order_id, product_id, product_name, product_image, price, quantity, subtotal, create_time) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            for (OrderItem item : orderItems) {
                executeUpdate(sql,
                    item.getOrderId(),
                    item.getProductId(),
                    item.getProductName(),
                    item.getProductImage(),
                    item.getPrice(),
                    item.getQuantity(),
                    item.getSubtotal() // 修改：将 subtotal 改为 totalPrice
                );
            }

            conn.commit();
            return orderItems.size();
        } catch (SQLException e) {
            logger.error("批量插入订单项失败", e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                logger.error("事务回滚失败", ex);
            }
            throw new RuntimeException("批量插入订单项失败", e);
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                logger.error("关闭连接失败", e);
            }
        }
    }
}