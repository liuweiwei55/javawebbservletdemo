package com.student.controller;

import com.student.dao.CartDAO;
import com.student.dao.ProductDAO;
import com.student.dao.impl.CartDAOImpl;
import com.student.dao.impl.ProductDAOImpl;
import com.student.entity.Cart;
import com.student.entity.Product;
import com.student.service.CartService;
import com.student.service.impl.CartServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/cart/*")
@MultipartConfig
public class CartServlet extends BaseServlet {

    private final CartService cartService = new CartServiceImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final CartDAO cartDAO = new CartDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || !"/list".equals(path)) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        listCart(request, response);
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
                addToCart(request, response);
                break;
            case "/update":
                updateCart(request, response);
                break;
            case "/delete":
                deleteFromCart(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            List<Cart> carts = cartService.getCartByUserId(userId);

            List<Map<String, Object>> cartList = new ArrayList<>();
            for (Cart cart : carts) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", cart.getId());
                item.put("userId", cart.getUserId());
                item.put("productId", cart.getProductId());
                item.put("quantity", cart.getQuantity());
                item.put("checked", cart.getChecked());
                item.put("createTime", cart.getCreateTime());
                item.put("updateTime", cart.getUpdateTime());

                Product product = productDAO.findById(cart.getProductId());
                if (product != null) {
                    item.put("productName", product.getName());
                    item.put("productPrice", product.getPrice() != null ? product.getPrice().toString() : "0");
                    item.put("productImage", product.getImage());
                    item.put("productStatus", product.getStatus());
                } else {
                    item.put("productName", "未知商品");
                    item.put("productPrice", "0");
                    item.put("productImage", null);
                }

                cartList.add(item);
            }

            sendSuccessResponse(response, "获取成功", cartList);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取购物车列表失败: " + e.getMessage());
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer productId = getIntegerParameter(request, "productId");
            Integer quantity = getIntegerParameter(request, "quantity");

            if (productId == null || quantity == null) {
                sendErrorResponse(response, 400, "参数不能为空");
                return;
            }

            if (quantity <= 0) {
                sendErrorResponse(response, 400, "数量必须大于0");
                return;
            }

            boolean result = cartService.addToCart(userId, productId, quantity);

            if (result) {
                // 查询当前购物车中该商品的记录，返回cartId和数量
                Cart cartItem = cartService.getCartItem(userId, productId);
                Map<String, Object> data = new HashMap<>();
                if (cartItem != null) {
                    data.put("cartId", cartItem.getId());
                    data.put("quantity", cartItem.getQuantity());
                    data.put("productId", productId);
                } else {
                    data.put("productId", productId);
                    data.put("quantity", quantity);
                }
                sendSuccessResponse(response, "添加成功", data);
            } else {
                sendErrorResponse(response, 500, "添加失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "添加到购物车失败: " + e.getMessage());
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer cartId = getIntegerParameter(request, "id");
            Integer quantity = getIntegerParameter(request, "quantity");
            Integer checked = getIntegerParameter(request, "checked");

            if (cartId == null) {
                sendErrorResponse(response, 400, "购物车ID不能为空");
                return;
            }

            if (quantity != null) {
                if (quantity < 0) {
                    sendErrorResponse(response, 400, "数量不能为负数");
                    return;
                }
                if (quantity == 0) {
                    boolean result = cartService.removeFromCart(cartId);
                    if (result) {
                        sendSuccessResponse(response, "商品已从购物车移除", null);
                    } else {
                        sendErrorResponse(response, 500, "移除失败");
                    }
                    return;
                }
                boolean result = cartService.updateQuantity(cartId, quantity);
                if (result) {
                    sendSuccessResponse(response, "更新成功", null);
                } else {
                    sendErrorResponse(response, 500, "更新失败");
                }
            } else if (checked != null) {
                Cart existCart = cartDAO.findById(cartId);
                if (existCart == null) {
                    sendErrorResponse(response, 404, "购物车项不存在");
                    return;
                }
                existCart.setChecked(checked);
                boolean result = cartService.updateCart(existCart);
                if (result) {
                    sendSuccessResponse(response, "更新成功", null);
                } else {
                    sendErrorResponse(response, 500, "更新失败");
                }
            } else {
                sendErrorResponse(response, 400, "请提供更新参数");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "更新购物车失败: " + e.getMessage());
        }
    }

    private void deleteFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer cartId = getIntegerParameter(request, "id");

            if (cartId == null) {
                sendErrorResponse(response, 400, "购物车ID不能为空");
                return;
            }

            boolean result = cartService.removeFromCart(cartId);

            if (result) {
                sendSuccessResponse(response, "删除成功", null);
            } else {
                sendErrorResponse(response, 500, "删除失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "删除购物车项失败: " + e.getMessage());
        }
    }
}