package com.student.service.impl;

import com.student.dao.CartDAO;
import com.student.dao.ProductDAO;
import com.student.dao.impl.CartDAOImpl;
import com.student.dao.impl.ProductDAOImpl;
import com.student.entity.Cart;
import com.student.entity.Product;
import com.student.service.CartService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class CartServiceImpl implements CartService {

    private static final Logger logger = LoggerFactory.getLogger(CartServiceImpl.class);
    private final CartDAO cartDAO = new CartDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    public Cart addToCart(Cart cart) {
        if (cart == null || cart.getUserId() == null || cart.getProductId() == null) {
            throw new IllegalArgumentException("购物车信息不完整");
        }

        Cart existCart = cartDAO.getByUserIdAndProductId(cart.getUserId(), cart.getProductId());
        if (existCart != null) {
            int newQuantity = existCart.getQuantity() + cart.getQuantity();
            cartDAO.updateQuantity(existCart.getId(), newQuantity);
            logger.info("购物车商品数量更新: cartId={}, quantity={}", existCart.getId(), newQuantity);
            return existCart;
        } else {
            Product product = productDAO.findById(cart.getProductId());
            if (product == null) {
                throw new RuntimeException("商品不存在");
            }
            if (product.getStatus() != null && product.getStatus() == 0) {
                throw new RuntimeException("该商品已下架");
            }
            cartDAO.insert(cart);
            logger.info("添加到购物车: userId={}, productId={}", cart.getUserId(), cart.getProductId());
            return cart;
        }
    }

    @Override
    public boolean addToCart(Integer userId, Integer productId, Integer quantity) {
        if (userId == null || productId == null || quantity == null || quantity <= 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        
        Cart existCart = cartDAO.getByUserIdAndProductId(userId, productId);
        if (existCart != null) {
            int newQuantity = existCart.getQuantity() + quantity;
            int result = cartDAO.updateQuantity(existCart.getId(), newQuantity);
            logger.info("购物车商品数量更新: cartId={}, quantity={}", existCart.getId(), newQuantity);
            return result > 0;
        } else {
            Product product = productDAO.findById(productId);
            if (product == null) {
                throw new RuntimeException("商品不存在");
            }
            if (product.getStatus() != null && product.getStatus() == 0) {
                throw new RuntimeException("该商品已下架");
            }
            Cart cart = new Cart(userId, productId, quantity);
            int result = cartDAO.insert(cart);
            logger.info("添加到购物车: userId={}, productId={}, quantity={}", userId, productId, quantity);
            return result > 0;
        }
    }

    @Override
    public boolean updateQuantity(Integer cartId, Integer quantity) {
        if (cartId == null || quantity == null || quantity <= 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        int result = cartDAO.updateQuantity(cartId, quantity);
        logger.info("更新购物车数量: cartId={}, quantity={}, 结果: {}", cartId, quantity, result > 0 ? "成功" : "失败");
        return result > 0;
    }
    
    @Override
    public boolean updateCart(Cart cart) {
        if (cart == null || cart.getId() == null) {
            throw new IllegalArgumentException("购物车ID不能为空");
        }
        int result = cartDAO.update(cart);
        logger.info("更新购物车: cartId={}, 结果: {}", cart.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updateCartQuantity(Integer cartId, Integer quantity) {
        if (cartId == null || quantity == null || quantity <= 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        int result = cartDAO.updateQuantity(cartId, quantity);
        logger.info("更新购物车数量: cartId={}, quantity={}, 结果: {}", cartId, quantity, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean removeFromCart(Integer cartId) {
        if (cartId == null) {
            throw new IllegalArgumentException("购物车ID不能为空");
        }
        int result = cartDAO.delete(cartId);
        logger.info("从购物车移除: cartId={}, 结果: {}", cartId, result > 0 ? "成功" : "失败");
        return result > 0;
    }
    
    @Override
    public boolean deleteFromCart(Integer cartId) {
        if (cartId == null) {
            throw new IllegalArgumentException("购物车ID不能为空");
        }
        int result = cartDAO.delete(cartId);
        logger.info("从购物车删除: cartId={}, 结果: {}", cartId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean clearCart(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        int result = cartDAO.clearByUserId(userId);
        logger.info("清空购物车: userId={}, 结果: {}", userId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public List<Cart> getCartByUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return cartDAO.getByUserId(userId);
    }
    
    @Override
    public List<Cart> getCartList(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return cartDAO.getByUserId(userId);
    }

    @Override
    public Cart getCartItem(Integer userId, Integer productId) {
        if (userId == null || productId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        return cartDAO.getByUserIdAndProductId(userId, productId);
    }

    @Override
    public int getCartItemCount(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        List<Cart> carts = cartDAO.getByUserId(userId);
        return carts.size();
    }
}
