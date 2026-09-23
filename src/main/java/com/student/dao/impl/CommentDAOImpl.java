package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.CommentDAO;
import com.student.entity.Comment;

import java.util.List;

public class CommentDAOImpl extends BaseDAO<Comment> implements CommentDAO {
    
    @Override
    protected Class<Comment> getEntityClass() {
        return Comment.class;
    }
    
    @Override
    public int insert(Comment comment) {
        return super.insert(comment);
    }
    
    @Override
    public int update(Comment comment) {
        return super.update(comment);
    }
    
    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }
    
    @Override
    public Comment findById(Integer id) {
        return super.findById(id);
    }
    
    @Override
    public List<Comment> getByProductId(Integer productId) {
        String sql = "SELECT c.*, u.username AS user_username, u.avatar FROM t_comment c LEFT JOIN t_user u ON c.user_id = u.id WHERE c.product_id = ? AND c.status = 1 ORDER BY c.create_time DESC";
        return executeQueryForList(sql, productId);
    }
    
    @Override
    public List<Comment> getByUserId(Integer userId) {
        String sql = "SELECT c.*, u.username AS user_username, u.avatar FROM t_comment c LEFT JOIN t_user u ON c.user_id = u.id WHERE c.user_id = ? ORDER BY c.create_time DESC";
        return executeQueryForList(sql, userId);
    }
    
    @Override
    public List<Comment> getByOrderId(Integer orderId) {
        String sql = "SELECT c.*, u.username AS user_username, u.avatar, p.name AS product_name FROM t_comment c LEFT JOIN t_user u ON c.user_id = u.id LEFT JOIN t_product p ON c.product_id = p.id WHERE c.order_id = ? ORDER BY c.create_time DESC";
        return executeQueryForList(sql, orderId);
    }
    
    @Override
    public int updateUsernameByUserId(Integer userId, String newUsername) {
        String sql = "UPDATE t_comment SET username = ?, update_time = NOW() WHERE user_id = ?";
        return executeUpdate(sql, newUsername, userId);
    }
    
    @Override
    public int replyComment(Integer commentId, String replyContent) {
        String sql = "UPDATE t_comment SET reply_content = ?, reply_time = NOW(), update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, replyContent, commentId);
    }
    
    @Override
    public int incrementLikeCount(Integer commentId) {
        String sql = "UPDATE t_comment SET like_count = like_count + 1, update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, commentId);
    }
    
    @Override
    public int decrementLikeCount(Integer commentId) {
        String sql = "UPDATE t_comment SET like_count = CASE WHEN like_count > 0 THEN like_count - 1 ELSE 0 END, update_time = NOW() WHERE id = ?";
        return executeUpdate(sql, commentId);
    }
}