package com.student.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.student.dao.CommentDAO;
import com.student.dao.OrderItemDAO;
import com.student.dao.ProductDAO;
import com.student.dao.impl.CommentDAOImpl;
import com.student.dao.impl.OrderItemDAOImpl;
import com.student.dao.impl.ProductDAOImpl;
import com.student.entity.Comment;
import com.student.entity.OrderItem;
import com.student.entity.Order;
import com.student.entity.Product;
import com.student.service.OrderService;
import com.student.service.impl.OrderServiceImpl;
import com.student.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

@WebServlet("/api/order/*")
@MultipartConfig
public class OrderServlet extends BaseServlet {

    private final OrderService orderService = new OrderServiceImpl();
    private final OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CommentDAO commentDAO = new CommentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        System.out.println("=== OrderServlet.doGet 被调用: path=" + path + " ===");

        if (path == null) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        switch (path) {
            case "/list":
                listOrders(request, response);
                break;
            case "/detail":
                orderDetail(request, response);
                break;
            case "/items":
                listOrderItems(request, response);
                break;

            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        System.out.println("=== OrderServlet.doPost 被调用: path=" + path + " ===");
        System.out.println("=== Request URI: " + request.getRequestURI() + " ===");
        System.out.println("=== Context Path: " + request.getContextPath() + " ===");
        System.out.println("=== Servlet Path: " + request.getServletPath() + " ===");

        if (path == null) {
            sendErrorResponse(response, 400, "无效的请求路径");
            return;
        }

        switch (path) {
            case "/create":
                createOrder(request, response);
                break;
            case "/cancel":
                cancelOrder(request, response);
                break;
            case "/pay":
                payOrder(request, response);
                break;
            case "/ship":
                shipOrder(request, response);
                break;
            case "/finish":
                finishOrder(request, response);
                break;
            case "/confirm":
                finishOrder(request, response);
                break;
            case "/delete":
                deleteOrder(request, response);
                break;
            case "/return":
                returnOrder(request, response);
                break;
            case "/refund":
                refundOrder(request, response);
                break;
            case "/completeRefund":
                completeRefund(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
    
            System.out.println("=== listOrders 开始 ===");
            System.out.println("userId: " + userId);
    
            if (userId == null) {
                System.out.println("用户未登录");
                sendErrorResponse(response, 401, "请先登录");
                return;
            }
    
            Integer status = getIntegerParameter(request, "status");
            System.out.println("status: " + status);
    
            orderService.checkAndCompleteRefunds();
    
            List<Order> orders;
            if (status != null) {
                orders = orderService.getOrdersByStatus(userId, status);
            } else {
                orders = orderService.getOrdersByUserId(userId);
            }
            
            System.out.println("订单数量：" + (orders != null ? orders.size() : 0));
    
            // 为每个订单添加 hasComment 字段
            List<Map<String, Object>> ordersWithComment = new ArrayList<>();
            for (Order order : orders) {
                try {
                    Map<String, Object> orderMap = new HashMap<>();
                    // 复制订单的所有字段
                    orderMap.put("id", order.getId());
                    orderMap.put("orderNo", order.getOrderNo());
                    orderMap.put("userId", order.getUserId());
                    orderMap.put("totalAmount", order.getTotalAmount());
                    orderMap.put("discountAmount", order.getDiscountAmount());
                    orderMap.put("actualAmount", order.getActualAmount());
                    orderMap.put("paymentMethod", order.getPaymentMethod());
                    orderMap.put("paymentTime", order.getPaymentTime());
                    orderMap.put("status", order.getStatus());
                    orderMap.put("receiverName", order.getReceiverName());
                    orderMap.put("receiverPhone", order.getReceiverPhone());
                    orderMap.put("receiverProvince", order.getReceiverProvince());
                    orderMap.put("receiverCity", order.getReceiverCity());
                    orderMap.put("receiverDistrict", order.getReceiverDistrict());
                    orderMap.put("receiverAddress", order.getReceiverAddress());
                    orderMap.put("remark", order.getRemark());
                    orderMap.put("adminRemark", order.getAdminRemark());
                    orderMap.put("deliveryCompany", order.getDeliveryCompany());
                    orderMap.put("deliveryNo", order.getDeliveryNo());
                    orderMap.put("deliveryTime", order.getDeliveryTime());
                    orderMap.put("finishTime", order.getFinishTime());
                    orderMap.put("refundCompleteTime", order.getRefundCompleteTime());
                    orderMap.put("cancelReason", order.getCancelReason());
                    orderMap.put("refundReason", order.getRefundReason());
                    orderMap.put("createTime", order.getCreateTime());
                    orderMap.put("updateTime", order.getUpdateTime());
                        
                    // 设置订单项
                    List<OrderItem> items = orderItemDAO.getByOrderId(order.getId());
                    orderMap.put("items", items);
                    System.out.println("订单 " + order.getId() + " 的订单项数量：" + (items != null ? items.size() : 0));
                        
                    // 检查是否有评论（通过订单ID和用户ID判断）
                    boolean hasComment = false;
                    if (order.getStatus() == 3) {
                        List<Comment> orderComments = commentDAO.getByOrderId(order.getId());
                        if (orderComments != null) {
                            for (Comment c : orderComments) {
                                if (c.getUserId() != null && c.getUserId().equals(userId) && c.getStatus() == 1) {
                                    hasComment = true;
                                    break;
                                }
                            }
                        }
                    }
                    orderMap.put("hasComment", hasComment);
                        
                    ordersWithComment.add(orderMap);
                } catch (Exception e) {
                    System.err.println("处理订单 " + order.getId() + " 时出错：" + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("最终订单数量：" + ordersWithComment.size());
            System.out.println("=== listOrders 结束 ===");
    
            sendSuccessResponse(response, "获取成功", ordersWithComment);
        } catch (Exception e) {
            System.err.println("获取订单列表失败：" + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, 500, "获取订单列表失败：" + e.getMessage());
        }
    }

    private void orderDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");
            String orderNo = request.getParameter("orderNo");

            if (orderId == null && (orderNo == null || orderNo.trim().isEmpty())) {
                sendErrorResponse(response, 400, "订单ID或订单号不能为空");
                return;
            }

            Order order;
            orderService.checkAndCompleteRefunds();
            if (orderId != null) {
                order = orderService.getOrderById(orderId);
            } else {
                order = orderService.getOrderByOrderNo(orderNo);
            }

            if (order != null) {
                List<OrderItem> items = orderItemDAO.getByOrderId(order.getId());
                System.out.println("=== orderDetail 调试: orderId=" + orderId + ", items数量=" + items.size() + " ===");
                for (int i = 0; i < items.size(); i++) {
                    OrderItem oi = items.get(i);
                    System.out.println("  item[" + i + "]: price=" + oi.getPrice() + ", originalPrice=" + oi.getOriginalPrice() + ", qty=" + oi.getQuantity() + ", productId=" + oi.getProductId());
                }
                boolean hasOriginalPrice = false;
                for (OrderItem item : items) {
                    if (item.getProductId() != null) {
                        Product product = productDAO.findById(item.getProductId());
                        if (product != null && product.getOriginalPrice() != null) {
                            item.setOriginalPrice(product.getOriginalPrice());
                            hasOriginalPrice = true;
                            System.out.println("    从product加载originalPrice: productId=" + item.getProductId() + ", originalPrice=" + product.getOriginalPrice());
                        }
                    }
                }
                order.setItems(items);
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (OrderItem item : items) {
                    BigDecimal origPrice = item.getOriginalPrice() != null ? item.getOriginalPrice() : item.getPrice();
                    if (origPrice != null) {
                        totalAmount = totalAmount.add(origPrice.multiply(BigDecimal.valueOf(item.getQuantity())));
                    }
                }
                System.out.println("  计算后 totalAmount=" + totalAmount + ", order原始totalAmount=" + order.getTotalAmount());
                if (totalAmount.compareTo(BigDecimal.ZERO) > 0) {
                    order.setTotalAmount(totalAmount);
                    System.out.println("  已设置 order.totalAmount=" + totalAmount);
                }
                System.out.println("=== orderDetail 调试结束 ===");
                // 调试：打印退款原因
                System.out.println("=== 订单详情 - 退款信息 ===");
                System.out.println("  orderId: " + order.getId());
                System.out.println("  status: " + order.getStatus());
                System.out.println("  refundReason: " + order.getRefundReason());
                System.out.println("  refundCompleteTime: " + order.getRefundCompleteTime());
                System.out.println("=========================");
                
                // 将订单转为 JsonObject，再附加 items 和 comments
                JsonObject orderJson = gson.toJsonTree(order).getAsJsonObject();
                orderJson.add("items", gson.toJsonTree(items));
                orderJson.add("comments", gson.toJsonTree(commentDAO.getByOrderId(order.getId())));

                // 附加用户头像、昵称等信息，供详情页显示
                if (order.getUserId() != null) {
                    try (Connection conn = DBUtil.getConnection();
                         PreparedStatement ps = conn.prepareStatement("SELECT username, avatar FROM t_user WHERE id=?")) {
                        ps.setInt(1, order.getUserId());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                orderJson.addProperty("username", rs.getString("username"));
                                orderJson.addProperty("avatar", rs.getString("avatar"));
                            }
                        }
                    } catch (Exception ignore) {
                    }
                }

                sendSuccessResponse(response, "获取成功", orderJson);
            } else {
                sendErrorResponse(response, 404, "订单不存在");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取订单详情失败: " + e.getMessage());
        }
    }

    private void listOrderItems(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "orderId");
            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }
            List<OrderItem> items = orderItemDAO.getByOrderId(orderId);
            sendSuccessResponse(response, "获取成功", items);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取订单项失败: " + e.getMessage());
        }
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            JsonObject json = gson.fromJson(sb.toString(), JsonObject.class);

            String receiverName = json.has("receiverName") ? json.get("receiverName").getAsString() : null;
            String receiverPhone = json.has("receiverPhone") ? json.get("receiverPhone").getAsString() : null;
            String receiverProvince = json.has("receiverProvince") ? json.get("receiverProvince").getAsString() : null;
            String receiverCity = json.has("receiverCity") ? json.get("receiverCity").getAsString() : null;
            String receiverDistrict = json.has("receiverDistrict") ? json.get("receiverDistrict").getAsString() : null;
            String receiverAddress = json.has("receiverAddress") ? json.get("receiverAddress").getAsString() : null;
            String remark = json.has("remark") ? json.get("remark").getAsString() : null;
            Integer paymentMethod = json.has("paymentMethod") ? json.get("paymentMethod").getAsInt() : null;

            List<OrderItem> items = new ArrayList<>();
            if (json.has("items") && json.get("items").isJsonArray()) {
                JsonArray itemsArray = json.getAsJsonArray("items");
                for (JsonElement element : itemsArray) {
                    JsonObject itemJson = element.getAsJsonObject();
                    OrderItem item = new OrderItem();
                    item.setProductId(itemJson.get("productId").getAsInt());
                    item.setQuantity(itemJson.get("quantity").getAsInt());
                    items.add(item);
                }
            }

            if (receiverName == null || receiverPhone == null || receiverAddress == null) {
                sendErrorResponse(response, 400, "收货信息不完整");
                return;
            }

            if (items.isEmpty()) {
                sendErrorResponse(response, 400, "商品信息不完整");
                return;
            }

            Order order = new Order();
            order.setUserId(userId);
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setReceiverProvince(receiverProvince != null ? receiverProvince : "");
            order.setReceiverCity(receiverCity != null ? receiverCity : "");
            order.setReceiverDistrict(receiverDistrict != null ? receiverDistrict : "");
            order.setReceiverAddress(receiverAddress);
            order.setRemark(remark != null ? remark : "");
            order.setPaymentMethod(paymentMethod);
            order.setStatus(0);

            List<Order> result = orderService.createOrder(order, items);

            if (result != null && !result.isEmpty()) {
                sendSuccessResponse(response, "创建订单成功，共" + result.size() + "个订单", result);
            } else {
                sendErrorResponse(response, 500, "创建订单失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "创建订单失败: " + e.getMessage());
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");
            String reason = request.getParameter("reason");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            boolean result = orderService.cancelOrder(orderId, reason != null ? reason : "");

            if (result) {
                sendSuccessResponse(response, "取消订单成功", null);
            } else {
                sendErrorResponse(response, 500, "取消订单失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "取消订单失败: " + e.getMessage());
        }
    }

    private void payOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");
            Integer paymentMethod = getIntegerParameter(request, "paymentMethod");
    
            System.out.println("=== OrderServlet.payOrder ===");
            System.out.println("orderId: " + orderId);
            System.out.println("paymentMethod: " + paymentMethod);
    
            if (orderId == null || paymentMethod == null) {
                sendErrorResponse(response, 400, "参数不能为空");
                return;
            }
    
            if (paymentMethod < 1 || paymentMethod > 3) {
                sendErrorResponse(response, 400, "支付方式不合法");
                return;
            }
    
            // 支付前查看订单状态
            Order orderBefore = orderService.getOrderById(orderId);
            System.out.println("支付前订单：status=" + orderBefore.getStatus() + ", paymentTime=" + orderBefore.getPaymentTime());
    
            boolean result = orderService.payOrder(orderId, paymentMethod);
    
            // 支付后查看订单状态
            Order orderAfter = orderService.getOrderById(orderId);
            System.out.println("支付后订单：status=" + orderAfter.getStatus() + ", paymentTime=" + orderAfter.getPaymentTime());
    
            if (result) {
                sendSuccessResponse(response, "支付成功", null);
            } else {
                sendErrorResponse(response, 500, "支付失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "支付失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private void shipOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");
            String deliveryCompany = request.getParameter("deliveryCompany");
            String deliveryNo = request.getParameter("deliveryNo");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            if (deliveryCompany == null || deliveryNo == null) {
                sendErrorResponse(response, 400, "物流信息不完整");
                return;
            }

            boolean result = orderService.shipOrder(orderId, deliveryCompany, deliveryNo);

            if (result) {
                sendSuccessResponse(response, "发货成功", null);
            } else {
                sendErrorResponse(response, 500, "退款失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "退款失败: " + e.getMessage());
        }
    }

    private void completeRefund(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            Order order = orderService.getOrderById(orderId);
            if (order == null || order.getStatus() != 6) {
                sendErrorResponse(response, 400, "订单状态不允许完成退款");
                return;
            }

            if (order.getRefundCompleteTime() != null
                    && order.getRefundCompleteTime().after(new Date())) {
                sendErrorResponse(response, 400, "退款尚未到完成时间");
                return;
            }

            boolean result = orderService.completeRefundOrder(orderId);
            if (result) {
                sendSuccessResponse(response, "退款订单已完成", null);
            } else {
                sendErrorResponse(response, 500, "完成退款失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "完成退款失败: " + e.getMessage());
        }
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer orderId = getIntegerParameter(request, "id");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            // 验证订单属于当前用户
            Order order = orderService.getOrderById(orderId);
            if (order == null || !order.getUserId().equals(userId)) {
                sendErrorResponse(response, 404, "订单不存在");
                return;
            }

            // 允许删除：待支付(0)、已完成(3)、已取消(4)、退款中(5)、已退款(6)
            if (order.getStatus() != 0 && order.getStatus() != 3 && order.getStatus() != 4
                    && order.getStatus() != 5 && order.getStatus() != 6) {
                sendErrorResponse(response, 400, "该订单状态不允许删除");
                return;
            }

            boolean result = orderService.deleteOrder(orderId);

            if (result) {
                sendSuccessResponse(response, "删除订单成功", null);
            } else {
                sendErrorResponse(response, 500, "删除订单失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "删除订单失败: " + e.getMessage());
        }
    }

    private void finishOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            System.out.println("=== finishOrder: orderId=" + orderId + " ===");
            
            // 获取订单当前状态
            Order orderBefore = orderService.getOrderById(orderId);
            System.out.println("确认收货前订单状态: " + orderBefore.getStatus());

            boolean result = orderService.finishOrder(orderId);

            // 获取订单更新后状态
            Order orderAfter = orderService.getOrderById(orderId);
            System.out.println("确认收货后订单状态: " + orderAfter.getStatus());

            if (result) {
                sendSuccessResponse(response, "确认收货成功", null);
            } else {
                sendErrorResponse(response, 500, "确认收货失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "确认收货失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void returnOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");
            String reason = request.getParameter("reason");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            boolean result = orderService.returnOrder(orderId, reason != null ? reason : "");

            if (result) {
                Order order = orderService.getOrderById(orderId);
                Map<String, Object> data = new HashMap<>();
                data.put("refundCompleteTime", order != null ? order.getRefundCompleteTime() : null);
                sendSuccessResponse(response, "退货退款申请已提交", data);
            } else {
                sendErrorResponse(response, 500, "申请退货退款失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "申请退货退款失败: " + e.getMessage());
        }
    }

    private void refundOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer orderId = getIntegerParameter(request, "id");

            if (orderId == null) {
                sendErrorResponse(response, 400, "订单ID不能为空");
                return;
            }

            boolean result = orderService.refundOrder(orderId);

            if (result) {
                sendSuccessResponse(response, "退款已完成", null);
            } else {
                sendErrorResponse(response, 500, "退款失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "退款失败: " + e.getMessage());
        }
    }
}