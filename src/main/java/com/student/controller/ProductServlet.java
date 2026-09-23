package com.student.controller;

import com.student.entity.Product;
import com.student.service.ProductService;
import com.student.service.impl.ProductServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/api/product/*")
public class ProductServlet extends BaseServlet {

    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        switch (path) {
            case "/list":
                listProducts(request, response);
                break;
            case "/detail":
                productDetail(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
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
                addProduct(request, response);
                break;
            case "/update":
                updateProduct(request, response);
                break;
            case "/delete":
                deleteProduct(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer pageNum = getIntegerParameter(request, "pageNum");
            Integer pageSize = getIntegerParameter(request, "pageSize");
            Integer categoryId = getIntegerParameter(request, "categoryId");
            String keyword = request.getParameter("keyword");
    
            System.out.println("=== ProductServlet.listProducts ===");
            System.out.println("pageNum: " + pageNum);
            System.out.println("pageSize: " + pageSize);
            System.out.println("categoryId: " + categoryId);
            System.out.println("keyword: " + keyword);
    
            if (pageNum == null) pageNum = 1;
            if (pageSize == null) pageSize = 10;
    
            List<Product> products;
    
            if (categoryId != null) {
                System.out.println("查询分类商品：categoryId=" + categoryId);
                products = productService.getProductsByCategory(categoryId);
            } else if (keyword != null && !keyword.trim().isEmpty()) {
                System.out.println("搜索商品：keyword=" + keyword);
                products = productService.searchProducts(keyword);
            } else {
                System.out.println("获取全部商品：pageNum=" + pageNum + ", pageSize=" + pageSize);
                products = productService.getAllProducts(pageNum, pageSize);
            }
    
            System.out.println("查询结果数量：" + products.size());
            for (int i = 0; i < products.size(); i++) {
                System.out.println("  商品[" + i + "]: " + products.get(i).getName());
            }
    
            sendSuccessResponse(response, "获取成功", products);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取商品列表失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private void productDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer productId = getIntegerParameter(request, "id");

            if (productId == null) {
                sendErrorResponse(response, 400, "商品ID不能为空");
                return;
            }

            Product product = productService.getProductById(productId);

            if (product != null) {
                sendSuccessResponse(response, "获取成功", product);
            } else {
                sendErrorResponse(response, 404, "商品不存在");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取商品详情失败: " + e.getMessage());
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String name = request.getParameter("name");
            Integer categoryId = getIntegerParameter(request, "categoryId");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String originalPriceStr = request.getParameter("originalPrice");
            Integer stock = getIntegerParameter(request, "stock");
            String image = request.getParameter("image");
            String images = request.getParameter("images");
            Integer status = getIntegerParameter(request, "status");

            if (name == null || name.trim().isEmpty() || categoryId == null || priceStr == null) {
                sendErrorResponse(response, 400, "商品信息不完整");
                return;
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr);
            } catch (NumberFormatException e) {
                sendErrorResponse(response, 400, "价格格式不正确");
                return;
            }

            BigDecimal originalPrice = null;
            if (originalPriceStr != null && !originalPriceStr.trim().isEmpty()) {
                try {
                    originalPrice = new BigDecimal(originalPriceStr);
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, 400, "原价格式不正确");
                    return;
                }
            }

            Product product = new Product();
            product.setName(name.trim());
            product.setCategoryId(categoryId);
            product.setDescription(description != null ? description : "");
            product.setPrice(price);
            product.setOriginalPrice(originalPrice);
            product.setStock(stock != null ? stock : 0);
            product.setImage(image != null ? image : "");
            product.setImages(images != null ? images : "");
            product.setStatus(status != null ? status : 1);
            product.setSalesCount(0);

            boolean result = productService.addProduct(product);

            if (result) {
                sendSuccessResponse(response, "添加成功", null);
            } else {
                sendErrorResponse(response, 500, "添加失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "添加商品失败: " + e.getMessage());
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer id = getIntegerParameter(request, "id");

            if (id == null) {
                sendErrorResponse(response, 400, "商品ID不能为空");
                return;
            }

            Product existProduct = productService.getProductById(id);
            if (existProduct == null) {
                sendErrorResponse(response, 404, "商品不存在");
                return;
            }

            String name = request.getParameter("name");
            Integer categoryId = getIntegerParameter(request, "categoryId");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String originalPriceStr = request.getParameter("originalPrice");
            Integer stock = getIntegerParameter(request, "stock");
            String image = request.getParameter("image");
            String images = request.getParameter("images");
            Integer status = getIntegerParameter(request, "status");

            if (name != null) existProduct.setName(name.trim());
            if (categoryId != null) existProduct.setCategoryId(categoryId);
            if (description != null) existProduct.setDescription(description);

            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    existProduct.setPrice(new BigDecimal(priceStr));
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, 400, "价格格式不正确");
                    return;
                }
            }

            if (originalPriceStr != null && !originalPriceStr.trim().isEmpty()) {
                try {
                    existProduct.setOriginalPrice(new BigDecimal(originalPriceStr));
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, 400, "原价格式不正确");
                    return;
                }
            } else {
                existProduct.setOriginalPrice(null);
            }

            if (stock != null) existProduct.setStock(stock);
            if (image != null) existProduct.setImage(image);
            if (images != null) existProduct.setImages(images);
            if (status != null) existProduct.setStatus(status);

            boolean result = productService.updateProduct(existProduct);

            if (result) {
                sendSuccessResponse(response, "更新成功", null);
            } else {
                sendErrorResponse(response, 500, "更新失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "更新商品失败: " + e.getMessage());
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer productId = getIntegerParameter(request, "productId");

            if (productId == null) {
                sendErrorResponse(response, 400, "商品ID不能为空");
                return;
            }

            boolean result = productService.deleteProduct(productId);

            if (result) {
                sendSuccessResponse(response, "删除成功", null);
            } else {
                sendErrorResponse(response, 500, "删除失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "删除商品失败: " + e.getMessage());
        }
    }
}