package com.student.entity;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {

    private Integer id;                 // 订单ID（主键）
    private String orderNo;             // 订单编号（唯一，如 ORD202606181430521234）
    private Integer userId;             // 用户ID（外键 → t_user.id）
    private BigDecimal totalAmount;     // 订单总金额（商品原价总和）
    private BigDecimal discountAmount;  // 优惠金额
    private BigDecimal actualAmount;    // 实际支付金额（totalAmount - discountAmount）
    private Integer paymentMethod;      // 支付方式（1-支付宝，2-微信，3-银行卡）
    private Date paymentTime;           // 支付时间
    private Integer status;             // 订单状态（0-待支付，1-已支付，2-已发货，3-已完成，4-已取消，5-退款中，6-已退款）
    private String receiverName;        // 收货人姓名（快照）
    private String receiverPhone;       // 收货人电话（快照）
    private String receiverProvince;    // 收货省份（快照）
    private String receiverCity;        // 收货城市（快照）
    private String receiverDistrict;    // 收货区县（快照）
    private String receiverAddress;     // 收货详细地址（快照）
    private String remark;              // 订单备注
    private String adminRemark;         // 管理员备注
    private String deliveryCompany;     // 物流公司
    private String deliveryNo;          // 物流单号
    private Date deliveryTime;          // 发货时间
    private Date finishTime;            // 完成时间
    private Date refundCompleteTime;    // 退款完成时间（随机延迟后自动变为已完成）
    private String cancelReason;        // 取消原因
    private String refundReason;        // 退款原因
    private Date createTime;            // 创建时间
    private Date updateTime;            // 更新时间
    private transient List<OrderItem> items;  // 订单项列表（仅用于展示，不持久化）


    public Order() {
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getActualAmount() {
        return actualAmount;
    }

    public void setActualAmount(BigDecimal actualAmount) {
        this.actualAmount = actualAmount;
    }

    public Integer getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(Integer paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverProvince() {
        return receiverProvince;
    }

    public void setReceiverProvince(String receiverProvince) {
        this.receiverProvince = receiverProvince;
    }

    public String getReceiverCity() {
        return receiverCity;
    }

    public void setReceiverCity(String receiverCity) {
        this.receiverCity = receiverCity;
    }

    public String getReceiverDistrict() {
        return receiverDistrict;
    }

    public void setReceiverDistrict(String receiverDistrict) {
        this.receiverDistrict = receiverDistrict;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getAdminRemark() {
        return adminRemark;
    }

    public void setAdminRemark(String adminRemark) {
        this.adminRemark = adminRemark;
    }

    public String getDeliveryCompany() {
        return deliveryCompany;
    }

    public void setDeliveryCompany(String deliveryCompany) {
        this.deliveryCompany = deliveryCompany;
    }

    public String getDeliveryNo() {
        return deliveryNo;
    }

    public void setDeliveryNo(String deliveryNo) {
        this.deliveryNo = deliveryNo;
    }

    public Date getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(Date deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public Date getFinishTime() {
        return finishTime;
    }

    public void setFinishTime(Date finishTime) {
        this.finishTime = finishTime;
    }

    public Date getRefundCompleteTime() {
        return refundCompleteTime;
    }

    public void setRefundCompleteTime(Date refundCompleteTime) {
        this.refundCompleteTime = refundCompleteTime;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
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

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderNo='" + orderNo + '\'' +
                ", userId=" + userId +
                ", totalAmount=" + totalAmount +
                ", actualAmount=" + actualAmount +
                ", status=" + status +
                '}';
    }
}