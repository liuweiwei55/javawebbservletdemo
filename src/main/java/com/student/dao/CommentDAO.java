package com.student.dao;

import com.student.entity.Comment;
import java.util.List;

public interface CommentDAO {
    
    int insert(Comment comment);
    
    int update(Comment comment);
    
    int delete(Integer id);
    
    Comment findById(Integer id);
    
    List<Comment> getByProductId(Integer productId);
    
    List<Comment> getByUserId(Integer userId);
    
    List<Comment> getByOrderId(Integer orderId);
    
    int replyComment(Integer commentId, String replyContent);
    
    int incrementLikeCount(Integer commentId);
    
    int decrementLikeCount(Integer commentId);
    
    int updateUsernameByUserId(Integer userId, String newUsername);
}