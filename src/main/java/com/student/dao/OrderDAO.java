package com.student.dao;

import com.student.entity.Order;
import java.util.List;

public interface OrderDAO {
    
    int insert(Order order);
    
    int update(Order order);
    
    int delete(Integer id);
    
    Order findById(Integer id);
    
    Order getByOrderNo(String orderNo);
    
    List<Order> getByUserId(Integer userId);
    
    List<Order> getByStatus(Integer userId, Integer status);
    
    int updateStatus(Integer orderId, Integer status);
    
    int payOrder(Integer orderId, Integer paymentMethod);
    
    int cancelOrder(Integer orderId, String cancelReason);
    
    int shipOrder(Integer orderId, String deliveryCompany, String deliveryNo);
    
    int finishOrder(Integer orderId);

    int updateRefundComplete(Integer orderId, int status, java.util.Date refundCompleteTime);

    int updateRefundReason(Integer orderId, String refundReason);

    /**
     * 更新订单为退款中状态，同时设置退款完成时间和退款原因
     */
    int updateToRefunding(Integer orderId, int status, java.util.Date refundCompleteTime, String refundReason);

    List<Order> findAll(int pageNum, int pageSize);
    
    long count();
}