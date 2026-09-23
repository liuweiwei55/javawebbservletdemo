package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.CartDAO;
import com.student.entity.Cart;
import com.student.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class CartDAOImpl extends BaseDAO<Cart> implements CartDAO {
    
    @Override
    protected Class<Cart> getEntityClass() {
        return Cart.class;
    }
    
    @Override
    public int insert(Cart cart) {
        String sql = "INSERT INTO t_cart (user_id, product_id, quantity, checked) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, cart.getUserId());
            pstmt.setInt(2, cart.getProductId());
            pstmt.setInt(3, cart.getQuantity());
            pstmt.setInt(4, cart.getChecked() != null ? cart.getChecked() : 1);
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) {
                    cart.setId(keys.getInt(1));
                }
            }
            return rows;
        } catch (Exception e) {
            logger.error("插入购物车失败", e);
            throw new RuntimeException("插入购物车失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }
    
    @Override
    public int update(Cart cart) {
        String sql = "UPDATE t_cart SET quantity=?, checked=? WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cart.getQuantity());
            pstmt.setInt(2, cart.getChecked() != null ? cart.getChecked() : 1);
            pstmt.setInt(3, cart.getId());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            logger.error("更新购物车失败", e);
            throw new RuntimeException("更新购物车失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }
    
    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }
    
    @Override
    public Cart findById(Integer id) {
        return super.findById(id);
    }
    
    @Override
    public Cart getByUserIdAndProductId(Integer userId, Integer productId) {
        String sql = "SELECT * FROM t_cart WHERE user_id = ? AND product_id = ?";
        return executeQueryForObject(sql, userId, productId);
    }
    
    @Override
    public List<Cart> getByUserId(Integer userId) {
        String sql = "SELECT * FROM t_cart WHERE user_id = ? ORDER BY create_time DESC";
        return executeQueryForList(sql, userId);
    }
    
    @Override
    public int updateQuantity(Integer cartId, Integer quantity) {
        String sql = "UPDATE t_cart SET quantity = ?, update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, quantity, cartId);
    }
    
    @Override
    public int deleteByUserIdAndProductId(Integer userId, Integer productId) {
        String sql = "DELETE FROM t_cart WHERE user_id = ? AND product_id = ?";
        return executeUpdate(sql, userId, productId);
    }
    
    @Override
    public int clearByUserId(Integer userId) {
        String sql = "DELETE FROM t_cart WHERE user_id = ?";
        return executeUpdate(sql, userId);
    }
}
