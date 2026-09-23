package com.student.dao;

import com.student.entity.OrderItem;
import java.util.List;

public interface OrderItemDAO {

    int insert(OrderItem orderItem);

    int update(OrderItem orderItem);

    int delete(Integer id);

    OrderItem findById(Integer id);

    List<OrderItem> getByOrderId(Integer orderId);

    int batchInsert(List<OrderItem> orderItems);
}
