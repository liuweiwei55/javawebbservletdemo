package com.student.dao;

import com.student.entity.Cart;
import java.util.List;

public interface CartDAO {
    
    int insert(Cart cart);
    
    int update(Cart cart);
    
    int delete(Integer id);
    
    Cart findById(Integer id);
    
    Cart getByUserIdAndProductId(Integer userId, Integer productId);
    
    List<Cart> getByUserId(Integer userId);
    
    int updateQuantity(Integer cartId, Integer quantity);
    
    int deleteByUserIdAndProductId(Integer userId, Integer productId);
    
    int clearByUserId(Integer userId);
}
