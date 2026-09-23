package com.student.entity;

import java.util.Date;

public class Category {

    private Integer id;           // 分类ID（主键）
    private String name;          // 分类名称
    private Integer parentId;     // 父分类ID（0表示一级分类）
    private Integer sortOrder;    // 排序序号（数字越小越靠前）
    private String icon;          // 分类图标路径
    private Integer status;       // 状态（0-禁用，1-启用）
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间


    public Category() {
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", parentId=" + parentId +
                ", sortOrder=" + sortOrder +
                ", status=" + status +
                '}';
    }
}