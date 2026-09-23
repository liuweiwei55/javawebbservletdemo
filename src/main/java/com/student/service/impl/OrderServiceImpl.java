package com.student.service.impl;

import com.student.dao.OrderDAO;
import com.student.dao.OrderItemDAO;
import com.student.dao.ProductDAO;
import com.student.dao.impl.OrderDAOImpl;
import com.student.dao.impl.OrderItemDAOImpl;
import com.student.dao.impl.ProductDAOImpl;
import com.student.service.ProductService;
import com.student.service.impl.ProductServiceImpl;
import com.student.service.ProductService;
import com.student.service.impl.ProductServiceImpl;
import com.student.entity.Order;
import com.student.entity.OrderItem;
import com.student.entity.Product;
import com.student.service.OrderService;
import com.student.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderServiceImpl implements OrderService {

    private static final Logger logger = LoggerFactory.getLogger(OrderServiceImpl.class);
    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductService productService = new ProductServiceImpl();

    @Override
    public List<Order> createOrder(Order order, List<OrderItem> items) {
        if (order == null || items == null || items.isEmpty()) {
            throw new IllegalArgumentException("订单信息不完整");
        }

        Connection conn = null;
        List<Order> createdOrders = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 先验证所有商品和库存
            BigDecimal totalAmount = BigDecimal.ZERO;
            BigDecimal totalOriginalAmount = BigDecimal.ZERO;
            for (OrderItem item : items) {
                Product product = productDAO.findById(item.getProductId());
                if (product == null) {
                    throw new RuntimeException("商品不存在");
                }
                if (product.getStock() < item.getQuantity()) {
                    throw new RuntimeException("商品 " + product.getName() + " 库存不足");
                }
                if (product.getStatus() != null && product.getStatus() == 0) {
                    throw new RuntimeException("商品 " + product.getName() + " 已下架");
                }

                BigDecimal itemPrice = product.getPrice();
                BigDecimal itemOriginalPrice = product.getOriginalPrice() != null ? product.getOriginalPrice() : product.getPrice();
                BigDecimal itemTotal = itemPrice.multiply(BigDecimal.valueOf(item.getQuantity()));
                BigDecimal itemOriginalTotal = itemOriginalPrice.multiply(BigDecimal.valueOf(item.getQuantity()));

                item.setProductName(product.getName());
                item.setProductImage(product.getImage());
                item.setPrice(itemPrice);
                item.setOriginalPrice(itemOriginalPrice);
                item.setSubtotal(itemTotal);

                totalAmount = totalAmount.add(itemTotal);
                totalOriginalAmount = totalOriginalAmount.add(itemOriginalTotal);
            }

            // 创建一个订单，包含所有商品
            Order singleOrder = new Order();
            singleOrder.setUserId(order.getUserId());
            singleOrder.setOrderNo(generateOrderNo());
            singleOrder.setStatus(0);
            singleOrder.setReceiverName(order.getReceiverName());
            singleOrder.setReceiverPhone(order.getReceiverPhone());
            singleOrder.setReceiverProvince(order.getReceiverProvince());
            singleOrder.setReceiverCity(order.getReceiverCity());
            singleOrder.setReceiverDistrict(order.getReceiverDistrict());
            singleOrder.setReceiverAddress(order.getReceiverAddress());
            singleOrder.setRemark(order.getRemark());
            singleOrder.setPaymentMethod(order.getPaymentMethod());
            singleOrder.setTotalAmount(totalOriginalAmount);
            singleOrder.setDiscountAmount(totalOriginalAmount.subtract(totalAmount));
            singleOrder.setActualAmount(totalAmount);

            int result = orderDAO.insert(singleOrder);
            if (result > 0) {
                for (OrderItem item : items) {
                    item.setOrderId(singleOrder.getId());
                    orderItemDAO.insert(item);
                    productService.reduceStock(item.getProductId(), item.getQuantity());
                }
                createdOrders.add(singleOrder);
            }

            // 原生提交
            conn.commit();
            logger.info("创建订单成功: 共{}个独立订单", createdOrders.size());
            return createdOrders;
        } catch (Exception e) {
            try {
                // 原生回滚
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                logger.error("事务回滚异常", ex);
            }
            logger.error("创建订单失败，已回滚", e);
            throw new RuntimeException("创建订单失败: " + e.getMessage());
        } finally {
            // 原生关闭连接，恢复自动提交
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public Order getOrderById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        return orderDAO.findById(id);
    }

    @Override
    public Order getOrderByOrderNo(String orderNo) {
        if (orderNo == null || orderNo.trim().isEmpty()) {
            throw new IllegalArgumentException("订单号不能为空");
        }
        return orderDAO.getByOrderNo(orderNo);
    }

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return orderDAO.getByUserId(userId);
    }

    @Override
    public List<Order> getOrdersByStatus(Integer userId, Integer status) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return orderDAO.getByStatus(userId, status);
    }

    @Override
    public List<Order> getAllOrders(int pageNum, int pageSize) {
        if (pageNum <= 0) pageNum = 1;
        if (pageSize <= 0) pageSize = 10;
        return orderDAO.findAll(pageNum, pageSize);
    }

    @Override
    public long getTotalCount() {
        return orderDAO.count();
    }

    @Override
    public boolean payOrder(Integer orderId, Integer paymentMethod) {
        if (orderId == null || paymentMethod == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        int result = orderDAO.payOrder(orderId, paymentMethod);
        logger.info("支付订单: orderId={}, paymentMethod={}, 结果: {}", orderId, paymentMethod, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean cancelOrder(Integer orderId, String reason) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getStatus() != 0) {
            throw new RuntimeException("订单状态不允许取消");
        }

        int result = orderDAO.cancelOrder(orderId, reason);
        if (result > 0) {
            try {
                List<OrderItem> items = orderItemDAO.getByOrderId(orderId);
                for (OrderItem item : items) {
                    productDAO.restoreStock(item.getProductId(), item.getQuantity());
                }
            } catch (Exception e) {
                logger.warn("取消订单恢复库存异常: {}", e.getMessage());
            }
        }

        logger.info("取消订单: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean shipOrder(Integer orderId, String deliveryCompany, String deliveryNo) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        Order order = orderDAO.findById(orderId);
        if (order == null || order.getStatus() != 1) {
            throw new RuntimeException("订单状态不允许发货");
        }

        int result = orderDAO.shipOrder(orderId, deliveryCompany, deliveryNo);
        logger.info("发货订单: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override public boolean finishOrder(Integer orderId) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getStatus() != 1 && order.getStatus() != 2) {
            throw new RuntimeException("订单状态不允许确认收货，仅未发货或已发货订单可确认收货");
        }
        int result = orderDAO.finishOrder(orderId);
        logger.info("完成订单: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteOrder(Integer orderId) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        int result = orderDAO.delete(orderId);
        logger.info("删除订单: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean returnOrder(Integer orderId, String reason) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getStatus() != 1) {
            throw new RuntimeException("仅未发货订单可申请退货退款");
        }

        int randomHours = (int) (Math.random() * 24) + 1; // 1 - 24 小时之间的随机整数
        Date refundCompleteTime = new Date(System.currentTimeMillis() + randomHours * 3600_000L);

        // 申请退款时，状态设为5（退款中），而不是6（已退款）
        order.setStatus(5);
        order.setRefundCompleteTime(refundCompleteTime);

        // 一次性更新状态、退款完成时间和退款原因
        int result = orderDAO.updateToRefunding(orderId, 5, refundCompleteTime, reason != null && !reason.trim().isEmpty() ? reason : "用户申请退款");

        if (result > 0) {
            try {
                List<OrderItem> items = orderItemDAO.getByOrderId(orderId);
                for (OrderItem item : items) {
                    productDAO.restoreStock(item.getProductId(), item.getQuantity());
                }
            } catch (Exception e) {
                logger.warn("退货退款恢复库存异常: {}", e.getMessage());
            }
        }
        logger.info("退货退款: orderId={}, reason={}, 随机延迟{}小时, 结果: {}", orderId, reason, randomHours, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean refundOrder(Integer orderId) {
        if (orderId == null) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        Order order = orderDAO.findById(orderId);
        if (order == null || order.getStatus() != 5) {
            throw new RuntimeException("订单状态不允许退款");
        }
        int result = orderDAO.updateStatus(orderId, 6);
        logger.info("退款完成: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean completeRefundOrder(Integer orderId) {
        Order order = orderDAO.findById(orderId);
        if (order == null || order.getStatus() != 6) {
            throw new RuntimeException("订单状态不允许完成退款");
        }
        // 退款完成后保持状态为已退款(6)，不改为已完成(3)
        int result = orderDAO.updateStatus(orderId, 6);
        logger.info("退款订单自动完成: orderId={}, 结果: {}", orderId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public void checkAndCompleteRefunds() {
        Date now = new Date();
        List<Order> allOrders = orderDAO.findAll(1, Integer.MAX_VALUE);
        for (Order order : allOrders) {
            // 当退款中的订单（status=5）的退款完成时间已到，将其状态改为6（已退款）
            if (order.getStatus() == 5 && order.getRefundCompleteTime() != null
                    && order.getRefundCompleteTime().before(now)) {
                orderDAO.updateStatus(order.getId(), 6);
                logger.info("退款中订单自动变为已退款: orderId={}", order.getId());
            }
        }
    }

    // 生成唯一订单号
    private String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        return "ORD" + sdf.format(new Date()) + (int)(Math.random() * 1000);
    }
}