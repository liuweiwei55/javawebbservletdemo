package com.student.entity;

import java.math.BigDecimal;

public class Product {
    private Integer id;
    private Integer categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Integer stock;
    private Integer salesCount;
    private String image;
    private String images;
    private Integer status;
    private Integer isHot;
    private Integer isNew;
    private Integer viewCount;
    private String categoryName;  // 分类名称（非数据库字段）

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Integer getSalesCount() {
        return salesCount;
    }

    public void setSalesCount(Integer salesCount) {
        this.salesCount = salesCount;
    }

    /**
     * 获取主图：如果为空，则返回默认图文件名
     */
    public String getImage() {
        if (this.image == null || this.image.trim().isEmpty()) {
            return "default-product.jpg";
        }
        return this.image;
    }

    /**
     * 设置主图：自动去除路径前缀，只保留文件名；若为空则使用默认图
     */
    public void setImage(String image) {
        if (image != null) {
            image = image.trim();
            if (image.contains("/")) {
                image = image.substring(image.lastIndexOf("/") + 1);
            }
            if (image.equals("default-product.png")) {
                image = "default-product.jpg";
            }
        }
        this.image = (image != null && !image.isEmpty()) ? image : "default-product.jpg";
    }

    /**
     * 获取副图集：JSON 格式的图片列表
     */
    public String getImages() {
        if (this.images == null || this.images.trim().isEmpty()) {
            return "[]";
        }
        return this.images;
    }

    public void setImages(String images) {
        if (images != null) {
            images = images.trim();
            images = images.replace("images/products/", "");
        }
        this.images = (images != null && !images.isEmpty()) ? images : "[]";
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getIsHot() {
        return isHot;
    }

    public void setIsHot(Integer isHot) {
        this.isHot = isHot;
    }

    public Integer getIsNew() {
        return isNew;
    }

    public void setIsNew(Integer isNew) {
        this.isNew = isNew;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}