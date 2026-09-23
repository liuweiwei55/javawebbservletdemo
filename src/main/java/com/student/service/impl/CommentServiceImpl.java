package com.student.service.impl;

import com.student.dao.CommentDAO;
import com.student.dao.impl.CommentDAOImpl;
import com.student.entity.Comment;
import com.student.service.CommentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class CommentServiceImpl implements CommentService {

    private static final Logger logger = LoggerFactory.getLogger(CommentServiceImpl.class);
    private final CommentDAO commentDAO = new CommentDAOImpl();

    @Override
    public Comment addComment(Comment comment) {
        if (comment == null || comment.getProductId() == null || comment.getUserId() == null) {
            throw new IllegalArgumentException("评论信息不完整");
        }
        commentDAO.insert(comment);
        logger.info("添加评论: productId={}, userId={}", comment.getProductId(), comment.getUserId());
        return comment;
    }

    @Override
    public boolean updateComment(Comment comment) {
        if (comment == null || comment.getId() == null) {
            throw new IllegalArgumentException("评论信息不完整");
        }
        int result = commentDAO.update(comment);
        logger.info("更新评论: commentId={}, 结果: {}", comment.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteComment(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("评论ID不能为空");
        }
        int result = commentDAO.delete(id);
        logger.info("删除评论: commentId={}, 结果: {}", id, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public Comment getCommentById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("评论ID不能为空");
        }
        return commentDAO.findById(id);
    }

    @Override
    public List<Comment> getCommentsByProductId(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        return commentDAO.getByProductId(productId);
    }

    @Override
    public List<Comment> getCommentsByUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return commentDAO.getByUserId(userId);
    }

    @Override
    public boolean replyComment(Integer commentId, String replyContent) {
        if (commentId == null || replyContent == null || replyContent.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不能为空");
        }
        int result = commentDAO.replyComment(commentId, replyContent);
        logger.info("回复评论: commentId={}, 结果: {}", commentId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean likeComment(Integer commentId) {
        if (commentId == null) {
            throw new IllegalArgumentException("评论ID不能为空");
        }
        int result = commentDAO.incrementLikeCount(commentId);
        logger.info("点赞评论: commentId={}, 结果: {}", commentId, result > 0 ? "成功" : "失败");
        return result > 0;
    }
    
    @Override
    public boolean unlikeComment(Integer commentId) {
        if (commentId == null) {
            throw new IllegalArgumentException("评论ID不能为空");
        }
        int result = commentDAO.decrementLikeCount(commentId);
        logger.info("取消点赞评论: commentId={}, 结果: {}", commentId, result > 0 ? "成功" : "失败");
        return result > 0;
    }
}
