package com.student.entity;

import java.util.Date;

public class Cart {

    private Integer id;           // 购物车ID（主键）
    private Integer userId;       // 用户ID（外键 → t_user.id）
    private Integer productId;    // 商品ID（外键 → t_product.id）
    private Integer quantity;     // 商品数量
    private Integer checked;      // 是否选中（0-未选中，1-选中）
    private Date createTime;      // 加入购物车时间
    private Date updateTime;      // 最后更新时间


    public Cart() {
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public Cart(Integer userId, Integer productId, Integer quantity) {
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getChecked() {
        return checked;
    }

    public void setChecked(Integer checked) {
        this.checked = checked;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", checked=" + checked +
                '}';
    }
}