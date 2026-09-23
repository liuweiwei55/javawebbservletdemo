package com.student.entity;

import java.util.Date;

public class Comment {
    private Integer id;
    private Integer productId;
    private Integer userId;
    private String username;
    private String content;
    private String images;
    private Integer rating;
    private Date createTime;
    private Integer orderId;
    private Integer isAnonymous;
    private Integer status;
    private Integer likeCount;
    private transient String avatar;
    private transient String userUsername;
    private transient String productName;
    private String replyContent;
    private Date replyTime;
    private Date updateTime;

    public Comment() {
        this.createTime = new Date();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        if (userUsername != null && !userUsername.trim().isEmpty()) {
            return userUsername;
        }
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserUsername() {
        return userUsername;
    }

    public void setUserUsername(String userUsername) {
        this.userUsername = userUsername;
        if (userUsername != null && !userUsername.trim().isEmpty()) {
            this.username = userUsername;
        }
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    /**
     * 获取评论图片：如果为空或为旧默认图，则统一返回 default-product.jpg
     */
    public String getImages() {
        if (this.images == null || this.images.trim().isEmpty() || this.images.equals("default-product.png")) {
            return "default-product.jpg";
        }
        return this.images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setIsAnonymous(Integer isAnonymous) {
        this.isAnonymous = isAnonymous;
    }

    public Integer getIsAnonymous() {
        return isAnonymous;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getStatus() {
        return status;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public Date getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(Date replyTime) {
        this.replyTime = replyTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}