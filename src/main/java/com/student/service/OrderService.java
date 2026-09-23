package com.student.service;

import com.student.entity.Order;
import java.util.List;

public interface OrderService {

    List<Order> createOrder(Order order, List<com.student.entity.OrderItem> items);

    Order getOrderById(Integer id);

    Order getOrderByOrderNo(String orderNo);

    List<Order> getOrdersByUserId(Integer userId);

    List<Order> getOrdersByStatus(Integer userId, Integer status);

    List<Order> getAllOrders(int pageNum, int pageSize);

    long getTotalCount();

    boolean payOrder(Integer orderId, Integer paymentMethod);

    boolean cancelOrder(Integer orderId, String reason);

    boolean shipOrder(Integer orderId, String deliveryCompany, String deliveryNo);

    boolean finishOrder(Integer orderId);

    boolean deleteOrder(Integer orderId);

    boolean returnOrder(Integer orderId, String reason);

    boolean refundOrder(Integer orderId);

    void checkAndCompleteRefunds();

    boolean completeRefundOrder(Integer orderId);
}