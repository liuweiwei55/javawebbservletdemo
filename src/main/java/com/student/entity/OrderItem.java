package com.student.entity;

import java.math.BigDecimal;

public class OrderItem {
    private Integer id;
    private Integer orderId;
    private Integer productId;
    private String productName;
    private String productImage;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Integer quantity;
    private BigDecimal subtotal;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    /**
     * 获取订单项商品图片：如果为空，则返回默认图文件名
     */
    public String getProductImage() {
        if (this.productImage == null || this.productImage.trim().isEmpty()) {
            return "default-product.jpg";
        }
        return this.productImage;
    }

    /**
     * 设置商品图片：自动去除路径前缀，只保留文件名；若为空则使用默认图
     */
    public void setProductImage(String productImage) {
        if (productImage != null) {
            productImage = productImage.trim();
            if (productImage.contains("/")) {
                productImage = productImage.substring(productImage.lastIndexOf("/") + 1);
            }
            if (productImage.equals("default-product.png")) {
                productImage = "default-product.jpg";
            }
        }
        this.productImage = (productImage != null && !productImage.isEmpty()) ? productImage : "default-product.jpg";
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}