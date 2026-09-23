package com.student.entity;

import java.util.Date;

public class User {

    private Integer id;           // 用户ID（主键）
    private String username;      // 用户名（登录账号，唯一）
    private String password;      // 密码（MD5加密存储）
    private String realName;      // 真实姓名
    private String phone;         // 联系电话
    private String email;         // 电子邮箱
    private String avatar;        // 头像路径
    private Integer role;         // 角色（0-普通用户，1-管理员）
    private Integer status;       // 状态（0-禁用，1-正常）
    private Date createTime;      // 注册时间
    private Date updateTime;      // 最后更新时间
    private Date lastLoginTime;   // 上次登录时间


    public User() {
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public User(String username, String password, String realName, Integer role) {
        this.username = username;
        this.password = password;
        this.realName = realName;
        this.role = role;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
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

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", realName='" + realName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", status=" + status +
                '}';
    }
}