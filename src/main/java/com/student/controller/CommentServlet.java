package com.student.controller;

import com.student.entity.Comment;
import com.student.service.CommentService;
import com.student.service.impl.CommentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/comment/*")
public class CommentServlet extends BaseServlet {

    private static final Logger logger = LoggerFactory.getLogger(CommentServlet.class);
    private final CommentService commentService = new CommentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || !"/list".equals(path)) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        listComments(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            sendErrorResponse(response, 400, "无效的请求路径");
            return;
        }

        switch (path) {
            case "/add":
                addComment(request, response);
                break;
            case "/delete":
                deleteComment(request, response);
                break;
            case "/reply":
                replyComment(request, response);
                break;
            case "/like":
                likeComment(request, response);
                break;
            case "/unlike":
                unlikeComment(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listComments(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer productId = getIntegerParameter(request, "productId");
            String productIdsStr = request.getParameter("productIds");
            Integer userId = getIntegerParameter(request, "userId");

            List<Comment> comments;

            if (productId != null) {
                comments = commentService.getCommentsByProductId(productId);
            } else if (userId != null) {
                comments = commentService.getCommentsByUserId(userId);
            } else {
                sendErrorResponse(response, 400, "请提供商品ID或用户ID");
                return;
            }

            sendSuccessResponse(response, "获取成功", comments);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取评论列表失败: " + e.getMessage());
        }
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer productId = getIntegerParameter(request, "productId");
            String productIdsStr = request.getParameter("productIds");
            Integer orderId = getIntegerParameter(request, "orderId");
            String content = request.getParameter("content");
            Integer rating = getIntegerParameter(request, "rating");
            String images = request.getParameter("images");
            Integer isAnonymous = getIntegerParameter(request, "isAnonymous");

            if ((productId == null && (productIdsStr == null || productIdsStr.trim().isEmpty())) || content == null || content.trim().isEmpty()) {
                sendErrorResponse(response, 400, "参数不能为空");
                return;
            }

            // 订单评价（有 orderId）需要评分 1-5；商品详情页普通评论（无 orderId）不需要评分，默认为 0
            if (orderId != null) {
                if (rating == null || rating < 1 || rating > 5) {
                    sendErrorResponse(response, 400, "订单评价需要评分（1-5星）");
                    return;
                }
            } else {
                if (rating == null || rating < 0 || rating > 5) {
                    rating = 0;
                }
            }

            java.util.List<Integer> productIdList = new java.util.ArrayList<>();
            if (productIdsStr != null && !productIdsStr.trim().isEmpty()) {
                String[] ids = productIdsStr.split(",");
                for (String pidStr : ids) {
                    try {
                        productIdList.add(Integer.parseInt(pidStr.trim()));
                    } catch (Exception ex) {}
                }
            }
            if (productId != null) productIdList.add(productId);

            if (productIdList.isEmpty()) {
                sendErrorResponse(response, 400, "未获取到有效的商品ID");
                return;
            }

            int successCount = 0;
            for (Integer pid : productIdList) {
                Comment c = new Comment();
                c.setUserId(userId);
                c.setUsername(username != null ? username : "匿名用户");
                c.setProductId(pid);
                c.setOrderId(orderId);
                c.setContent(content);
                c.setRating(rating);
                c.setImages(images != null ? images : "");
                c.setIsAnonymous(isAnonymous != null ? isAnonymous : 0);
                c.setStatus(1);
                c.setLikeCount(0);
                Comment r = commentService.addComment(c);
                if (r != null) successCount++;
            }

            if (successCount > 0) {
                if (productIdList.size() > 1) {
                    sendSuccessResponse(response, "成功对 " + successCount + " 个商品进行评价", successCount);
                } else {
                    sendSuccessResponse(response, "评论成功", successCount);
                }
            } else {
                sendErrorResponse(response, 500, "评论失败");
            }
        } catch (Exception e) {
            logger.error("发表评论失败", e);
            String errMsg = e.getMessage();
            if (e.getCause() != null) {
                errMsg += " | cause: " + e.getCause().toString();
            }
            sendErrorResponse(response, 500, "发表评论失败: " + errMsg);
        }
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer commentId = getIntegerParameter(request, "commentId");

            if (commentId == null) {
                sendErrorResponse(response, 400, "评论ID不能为空");
                return;
            }

            boolean result = commentService.deleteComment(commentId);

            if (result) {
                sendSuccessResponse(response, "删除成功", null);
            } else {
                sendErrorResponse(response, 500, "删除失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "删除评论失败: " + e.getMessage());
        }
    }

    private void replyComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer commentId = getIntegerParameter(request, "commentId");
            String replyContent = request.getParameter("replyContent");

            if (commentId == null || replyContent == null) {
                sendErrorResponse(response, 400, "参数不能为空");
                return;
            }

            boolean result = commentService.replyComment(commentId, replyContent);

            if (result) {
                sendSuccessResponse(response, "回复成功", null);
            } else {
                sendErrorResponse(response, 500, "回复失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "回复评论失败: " + e.getMessage());
        }
    }
    
    private void likeComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer commentId = getIntegerParameter(request, "commentId");

            if (commentId == null) {
                sendErrorResponse(response, 400, "评论ID不能为空");
                return;
            }

            boolean result = commentService.likeComment(commentId);

            if (result) {
                sendSuccessResponse(response, "点赞成功", null);
            } else {
                sendErrorResponse(response, 500, "点赞失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "点赞评论失败: " + e.getMessage());
        }
    }
    
    private void unlikeComment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer commentId = getIntegerParameter(request, "commentId");

            if (commentId == null) {
                sendErrorResponse(response, 400, "评论ID不能为空");
                return;
            }

            boolean result = commentService.unlikeComment(commentId);

            if (result) {
                sendSuccessResponse(response, "取消点赞成功", null);
            } else {
                sendErrorResponse(response, 500, "取消点赞失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "取消点赞评论失败: " + e.getMessage());
        }
    }
}