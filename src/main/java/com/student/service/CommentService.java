package com.student.service;

import com.student.entity.Comment;
import java.util.List;

public interface CommentService {
    
    Comment addComment(Comment comment);
    
    boolean updateComment(Comment comment);
    
    boolean deleteComment(Integer id);
    
    Comment getCommentById(Integer id);
    
    List<Comment> getCommentsByProductId(Integer productId);
    
    List<Comment> getCommentsByUserId(Integer userId);
    
    boolean replyComment(Integer commentId, String replyContent);
    
    boolean likeComment(Integer commentId);
    
    boolean unlikeComment(Integer commentId);
}
