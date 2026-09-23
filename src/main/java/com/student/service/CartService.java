package com.student.service;

import com.student.entity.Cart;
import java.util.List;

public interface CartService {

    Cart addToCart(Cart cart);
    
    boolean addToCart(Integer userId, Integer productId, Integer quantity);

    boolean updateQuantity(Integer cartId, Integer quantity);
    
    boolean updateCart(Cart cart);

    boolean updateCartQuantity(Integer cartId, Integer quantity);

    boolean removeFromCart(Integer cartId);
    
    boolean deleteFromCart(Integer cartId);

    boolean clearCart(Integer userId);

    List<Cart> getCartByUserId(Integer userId);
    
    List<Cart> getCartList(Integer userId);

    Cart getCartItem(Integer userId, Integer productId);

    int getCartItemCount(Integer userId);
}
