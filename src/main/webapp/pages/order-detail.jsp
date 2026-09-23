<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: #f5f5f5; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .nav-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .logo { color: white; font-size: 24px; font-weight: bold; text-decoration: none; }
        .nav-links { display: flex; gap: 20px; align-items: center; }
        .nav-links a { color: white; text-decoration: none; padding: 8px 16px; border-radius: 5px; transition: background 0.3s; }
        .nav-links a:hover { background: rgba(255,255,255,0.2); }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .back-btn { display: inline-block; margin-bottom: 20px; padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; transition: background 0.3s; }
        .back-btn:hover { background: #764ba2; }
        .order-detail { background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .detail-header { display: flex; justify-content: space-between; align-items: center; padding-bottom: 20px; border-bottom: 2px solid #eee; margin-bottom: 30px; }
        .order-no { font-size: 24px; font-weight: 600; color: #333; }
        .order-status { padding: 8px 20px; border-radius: 20px; font-size: 16px; font-weight: 600; }
        .status-pending { background: #fff7e6; color: #fa8c16; }
        .status-paid { background: #e6f7ff; color: #1890ff; }
        .status-delivered { background: #f6ffed; color: #52c41a; }
        .status-completed { background: #dcfce7; color: #16a34a; font-weight: 700; }
        .status-cancelled { background: #fff1f0; color: #ff4d4f; }
        .status-timeout { background: #fff1f0; color: #ff4d4f; font-weight: 600; }
        .countdown-info { display: flex; align-items: center; gap: 10px; padding: 12px 18px; background: #fffbe6; border-radius: 8px; margin-bottom: 20px; font-size: 15px; color: #ad8b00; }
        .countdown-info.shipped { background: #e6f7ff; color: #096dd9; }
        .countdown-time { font-weight: 700; font-size: 18px; color: #d48806; font-family: 'Courier New', monospace; }
        .countdown-time.shipped { color: #096dd9; }
        .section { margin-bottom: 30px; }
        .section-title { font-size: 20px; margin-bottom: 15px; color: #333; border-left: 4px solid #667eea; padding-left: 10px; }
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .info-item { display: flex; padding: 10px; background: #f9f9f9; border-radius: 5px; }
        .info-label { width: 120px; color: #666; font-weight: 600; }
        .info-value { flex: 1; color: #333; }
        .order-items { margin-top: 20px; }
        .order-item { display: flex; gap: 15px; padding: 15px; border: 1px solid #eee; border-radius: 5px; margin-bottom: 10px; }
        .item-image { width: 100px; height: 100px; object-fit: cover; border-radius: 5px; }
        .item-details { flex: 1; }
        .item-name { font-size: 18px; color: #333; margin-bottom: 10px; }
        .item-info { color: #999; font-size: 14px; margin-bottom: 5px; }
        .item-price { color: #f5576c; font-size: 20px; font-weight: 600; }
        .price-summary { background: #f9f9f9; padding: 20px; border-radius: 5px; }
        .price-row { display: flex; justify-content: space-between; padding: 10px 0; font-size: 16px; }
        .price-row.total { border-top: 2px solid #ddd; margin-top: 10px; font-size: 20px; font-weight: 600; }
        .total-amount { color: #f5576c; font-size: 28px; }
        .action-buttons { display: flex; gap: 15px; justify-content: flex-end; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; }
        .btn { padding: 12px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; transition: all 0.3s; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-success { background: #52c41a; color: white; }
        .btn-success:hover { background: #73d13d; }
        .btn-warning { background: #fa8c16; color: white; }
        .btn-warning:hover { background: #ffa940; }
        .btn-danger { background: #ff4d4f; color: white; }
        .btn-danger:hover { background: #ff7875; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">🛒 购物系统</a>
            <div class="nav-links">
                <a href="${ctx}/index.jsp">首页</a>
                <a href="${ctx}/pages/cart.jsp">购物车</a>
                <a href="${ctx}/pages/order-list.jsp">我的订单</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.username}">
                        <a href="${ctx}/pages/user-center.jsp" style="color: white; text-decoration: none;">欢迎，${sessionScope.username}</a>
                        <a href="#" onclick="logout()">退出</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/pages/login.jsp">登录</a>
                        <a href="${ctx}/pages/register.jsp">注册</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container">
        <a href="${ctx}/pages/order-list.jsp" class="back-btn">← 返回订单列表</a>
        <div class="order-detail" id="orderDetail"></div>
    </div>

    <script>
        var ctx = '${ctx}';
        var order = null;
        var countdownInterval = null;
        var PAY_TIMEOUT_MS = 20 * 60 * 1000; // 20分钟超时

        function handleDetailImgError(img) {
            if (!img) return;
            var defaultSrc = ctx + '/images/products/default-product.jpg';
            img.onerror = function() {
                this.style.display = 'none';
                if (this.nextElementSibling) this.nextElementSibling.style.display = 'flex';
            };
            img.src = defaultSrc;
            setTimeout(function() {
                if (img.naturalWidth === 0) {
                    img.style.display = 'none';
                    if (img.nextElementSibling) img.nextElementSibling.style.display = 'flex';
                }
            }, 60);
        }

        function init() {
            var urlParams = new URLSearchParams(window.location.search);
            var orderId = urlParams.get('id');
            if (orderId) loadOrderDetail(orderId);
        }

        function initTimer(orderId, status) {
            var timerKey = 'order_timer_' + orderId;
            var stored = localStorage.getItem(timerKey);
            if (status === 1 && !stored) {
                var x = Math.floor(Math.random() * 7) + 1;
                var targetTime = Date.now() + x * 24 * 60 * 60 * 1000;
                localStorage.setItem(timerKey, JSON.stringify({
                    phase: 'pending_ship', days: x, targetTime: targetTime, paymentTime: Date.now()
                }));
            } else if (status === 2 && !stored) {
                var y = Math.floor(Math.random() * 7) + 1;
                var targetTime = Date.now() + y * 24 * 60 * 60 * 1000;
                localStorage.setItem(timerKey, JSON.stringify({
                    phase: 'shipped', days: y, targetTime: targetTime, shipTime: Date.now()
                }));
            }
        }

        function getTimerData(orderId) {
            var stored = localStorage.getItem('order_timer_' + orderId);
            if (stored) { try { return JSON.parse(stored); } catch(e) {} }
            return null;
        }

        function formatCountdown(ms) {
            if (isNaN(ms) || ms === null || ms === undefined || ms <= 0) return '00:00:00';
            var totalSec = Math.floor(ms / 1000);
            var d = Math.floor(totalSec / 86400);
            var h = Math.floor((totalSec % 86400) / 3600);
            var m = Math.floor((totalSec % 3600) / 60);
            var s = totalSec % 60;
            var str = '';
            if (d > 0) str += d + '天';
            str += (h < 10 ? '0' : '') + h + ':';
            str += (m < 10 ? '0' : '') + m + ':';
            str += (s < 10 ? '0' : '') + s;
            return str;
        }

        function getDetailPayDeadline(order) {
            if (!order || !order.createTime) return 0;
            var createTs = new Date(order.createTime).getTime();
            if (isNaN(createTs) || createTs <= 0) {
                var parts = String(order.createTime).match(/(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})[ T]?(\d{1,2})?:?(\d{1,2})?:?(\d{1,2})?/);
                if (parts) {
                    createTs = new Date(
                        parseInt(parts[1]),
                        parseInt(parts[2]) - 1,
                        parseInt(parts[3]),
                        parseInt(parts[4] || 0),
                        parseInt(parts[5] || 0),
                        parseInt(parts[6] || 0)
                    ).getTime();
                }
            }
            if (isNaN(createTs) || createTs <= 0) return 0;
            return createTs + PAY_TIMEOUT_MS;
        }

        function startDetailCountdown() {
            if (countdownInterval) clearInterval(countdownInterval);
            countdownInterval = setInterval(function() {
                if (!order) return;
                // 待支付超时检测
                if (order.status === 0 && order.createTime) {
                    var payDeadline = getDetailPayDeadline(order);
                    if (payDeadline <= 0 || Date.now() > payDeadline) {
                        var statusEl = document.querySelector('.order-status');
                        if (statusEl) {
                            statusEl.textContent = '已超时';
                            statusEl.className = 'order-status status-timeout';
                        }
                    } else {
                        var payEl = document.querySelector('.countdown-time');
                        if (payEl) payEl.textContent = formatCountdown(payDeadline - Date.now());
                    }
                    return;
                }
                var timerData = getTimerData(order.id);
                if (!timerData) return;
                var remaining = timerData.targetTime - Date.now();
                var el = document.querySelector('.countdown-time');
                if (remaining <= 0) {
                    if (timerData.phase === 'pending_ship' && order.status === 1) {
                        autoShipOrder(order.id);
                    } else if (el) {
                        el.textContent = '00:00:00';
                    }
                } else if (el) {
                    el.textContent = formatCountdown(remaining);
                }
            }, 1000);
        }

        async function autoShipOrder(orderId) {
            try {
                var formData = new FormData();
                formData.append('id', orderId);
                var province = order.receiverProvince || '';
                if (province.length > 2) province = province.substring(0, 2);
                var deliveryCompany = province ? province + '快递' : '模拟快递';
                var deliveryNo = 'YD' + Date.now().toString(36).toUpperCase() + Math.floor(Math.random() * 100000).toString().padStart(5, '0');
                formData.append('deliveryCompany', deliveryCompany);
                formData.append('deliveryNo', deliveryNo);
                var response = await fetch(ctx + '/api/order/ship', { method: 'POST', body: formData });
                var result = await response.json();
                if (result.code === 200) {
                    order.status = 2;
                    var y = Math.floor(Math.random() * 7) + 1;
                    var targetTime = Date.now() + y * 24 * 60 * 60 * 1000;
                    localStorage.setItem('order_timer_' + orderId, JSON.stringify({
                        phase: 'shipped', days: y, targetTime: targetTime, shipTime: Date.now()
                    }));
                    renderOrderDetail();
                }
            } catch(e) { console.error('自动发货失败:', e); }
        }

        async function loadOrderDetail(orderId) {
            try {
                var response = await fetch(ctx + '/api/order/detail?id=' + orderId);
                var result = await response.json();
                if (result.code === 200 && result.data) {
                    order = result.data;
                    console.log('=== 订单详情原始数据 ===');
                    console.log('totalAmount:', order.totalAmount, 'actualAmount:', order.actualAmount);
                    console.log('discountAmount:', order.discountAmount);
                    if (order.items && order.items.length > 0) {
                        order.items.forEach(function(it, idx) {
                            console.log('item[' + idx + '] price:', it.price, 'originalPrice:', it.originalPrice, 'qty:', it.quantity);
                        });
                    }
                    console.log(JSON.stringify(order, null, 2));
                    initTimer(order.id, order.status);
                    renderOrderDetail();
                    startDetailCountdown();
                } else {
                    alert('订单不存在');
                    window.location.href = ctx + '/pages/order-list.jsp';
                }
            } catch (error) {
                console.error('加载订单详情失败:', error);
            }
        }

        function renderOrderDetail() {
            var statusMap = {
                0: { text: '待支付', cls: 'status-pending' },
                1: { text: '未发货', cls: 'status-paid' },
                2: { text: '已发货', cls: 'status-delivered' },
                3: { text: '已完成', cls: 'status-completed' },
                4: { text: '已取消', cls: 'status-cancelled' },
                5: { text: '退款中', cls: 'status-cancelled' },
                6: { text: '已退款', cls: 'status-cancelled' }
            };
            var status = statusMap[order.status] || { text: '未知', cls: '' };
            var statusText = status.text;
            var statusCls = status.cls;
            if (order.status === 0 && order.createTime && Date.now() - new Date(order.createTime).getTime() > 20 * 60 * 1000) {
                statusText = '已超时';
                statusCls = 'status-timeout';
            }

            var countdownHtml = '';
            var timerData = getTimerData(order.id);
            if (order.status === 1 && timerData && timerData.phase === 'pending_ship') {
                var remaining = timerData.targetTime - Date.now();
                var timeText = remaining > 0 ? formatCountdown(remaining) : '00:00:00';
                countdownHtml = '<div class="countdown-info">' +
                    '<span> 预计 <strong>' + timerData.days + '</strong> 天发货</span>' +
                    '<span class="countdown-time">' + timeText + '</span></div>';
            } else if (order.status === 2 && timerData && timerData.phase === 'shipped') {
                var remaining = timerData.targetTime - Date.now();
                var timeText = remaining > 0 ? formatCountdown(remaining) : '00:00:00';
                countdownHtml = '<div class="countdown-info shipped">' +
                    '<span>🚚 预计 <strong>' + timerData.days + '</strong> 天到达</span>' +
                    '<span class="countdown-time shipped">' + timeText + '</span></div>';
            }
            // 退款中：不显示倒计时信息条，仅显示状态文字，倒计时在后台由订单列表页自动触发

            var html = '<div class="detail-header">' +
                '<div class="order-no">订单号：' + order.orderNo + '</div>' +
                '<div class="order-status ' + statusCls + '">' + statusText + '</div></div>' +
                countdownHtml +
                '<div class="section"><h3 class="section-title">订单信息</h3><div class="info-grid">' +
                '<div class="info-item"><div class="info-label">下单时间：</div><div class="info-value">' + formatTime(order.createTime) + '</div></div>' +
                '<div class="info-item"><div class="info-label">支付时间：</div><div class="info-value">' + (order.paymentTime ? formatTime(order.paymentTime) : '未支付') + '</div></div>' +
                '<div class="info-item"><div class="info-label">支付方式：</div><div class="info-value">' + getPaymentMethodName(order.paymentMethod) + '</div></div>' +
                '<div class="info-item"><div class="info-label">用户备注：</div><div class="info-value">' + (order.remark || '无') + '</div></div>' +
                (order.adminRemark ? '<div class="info-item"><div class="info-label">管理员备注：</div><div class="info-value">' + order.adminRemark + '</div></div>' : '');
            // 显示取消原因
            if (order.status === 4 && order.cancelReason) {
                html += '<div class="info-item" style="grid-column: span 2;"><div class="info-label">取消原因：</div><div class="info-value">' + order.cancelReason + '</div></div>';
            }
            
            // 显示退款原因
            if ((order.status === 5 || order.status === 6) && order.refundReason) {
                html += '<div class="info-item" style="grid-column: span 2;"><div class="info-label">退款原因：</div><div class="info-value">' + order.refundReason + '</div></div>';
            }
            
            html += '</div></div>';

            html += '<div class="section"><h3 class="section-title">收货信息</h3><div class="info-grid">' +
                '<div class="info-item"><div class="info-label">收货人：</div><div class="info-value">' + order.receiverName + '</div></div>' +
                '<div class="info-item"><div class="info-label">联系电话：</div><div class="info-value">' + order.receiverPhone + '</div></div>' +
                '<div class="info-item" style="grid-column: span 2;"><div class="info-label">收货地址：</div><div class="info-value">' +
                order.receiverProvince + order.receiverCity + order.receiverDistrict + order.receiverAddress +
                '</div></div></div></div>';

            html += '<div class="section"><h3 class="section-title">商品信息</h3><div class="order-items">';
            if (order.items && order.items.length > 0) {
                for (var i = 0; i < order.items.length; i++) {
                    var item = order.items[i];
                    var origPrice = item.originalPrice && item.originalPrice !== item.price ? '<span style="text-decoration: line-through; color: #999; font-size: 14px; margin-right: 8px;">¥' + parseFloat(item.originalPrice).toFixed(2) + '</span>' : '';
                    var pImg = item.productImage || item.image || '';
                    var pId = item.productId || item.id || 0;
                    var primaryImgUrl;
                    if (pImg && pImg.startsWith('http')) {
                        primaryImgUrl = pImg;
                    } else {
                        var tsMatch = pImg.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                        if (tsMatch) {
                            primaryImgUrl = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                        } else if (pId && pId > 0) {
                            primaryImgUrl = ctx + '/images/products/' + pId + '.jpg';
                        } else if (pImg && pImg.length > 0) {
                            primaryImgUrl = ctx + '/images/products/' + pImg;
                        } else {
                            primaryImgUrl = ctx + '/images/products/default-product.jpg';
                        }
                    }
                    html += '<div class="order-item">' +
                        '<div style="width:100px;height:100px;border-radius:5px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
                            '<img src="' + primaryImgUrl + '" alt="" style="width:100%;height:100%;object-fit:cover;" onerror="handleDetailImgError(this)">' +
                            '<span style="display:none;font-size:40px;color:#ccc;">📦</span>' +
                        '</div>' +
                        '<div class="item-details"><div class="item-name">' + item.productName + '</div>' +
                        '<div class="item-info">数量：' + item.quantity + '</div>' +
                        '<div class="item-price">' + origPrice + '¥' + parseFloat(item.price).toFixed(2) + '</div></div></div>';
                }
            }
            var originalTotal = parseFloat(order.totalAmount) || 0;
            var itemTotal = parseFloat(order.actualAmount) || 0;
            var discount = originalTotal - itemTotal;
            html += '</div></div>';

            html += '<div class="section"><h3 class="section-title">费用明细</h3><div class="price-summary">' +
                '<div class="price-row"><div>商品总额：</div><div>¥' + originalTotal.toFixed(2) + '</div></div>' +
                '<div class="price-row"><div>优惠金额：</div><div>-¥' + discount.toFixed(2) + '</div></div>' +
                '<div class="price-row total"><div>实付金额：</div><div class="total-amount">¥' + itemTotal.toFixed(2) + '</div></div>' +
                '</div></div>';

            if (order.deliveryCompany && order.deliveryNo) {
                html += '<div class="section"><h3 class="section-title">物流信息</h3><div class="info-grid">' +
                    '<div class="info-item"><div class="info-label">物流公司：</div><div class="info-value">' + order.deliveryCompany + '</div></div>' +
                    '<div class="info-item"><div class="info-label">物流单号：</div><div class="info-value">' + order.deliveryNo + '</div></div>' +
                    '</div></div>';
            }

            html += '<div class="action-buttons">';
            if (order.status === 0) {
                var deadline2 = new Date(order.createTime).getTime() + PAY_TIMEOUT_MS;
                if (Date.now() > deadline2) {
                    html += '<button class="btn btn-danger" onclick="deleteOrder()">删除订单</button>';
                } else {
                    html += '<button class="btn btn-primary" onclick="goToPay()">去支付</button>';
                    html += '<button class="btn btn-danger" onclick="cancelOrder()">取消订单</button>';
                }
            } else if (order.status === 1 || order.status === 2) {
                html += '<button class="btn btn-warning" onclick="returnOrder()">申请退款</button>';
                html += '<button class="btn btn-success" onclick="confirmReceive()">确认收货</button>';
            } else if (order.status === 3 || order.status === 4 || order.status === 6) {
                html += '<button class="btn btn-danger" onclick="deleteOrder()">删除订单</button>';
            }
            html += '</div>';

            document.getElementById('orderDetail').innerHTML = html;
        }

        function getPaymentMethodName(method) {
            var methods = { 1: '支付宝', 2: '微信', 3: '银行卡' };
            return methods[method] || '未知';
        }

        function goToPay() {
            window.location.href = ctx + '/pages/pay.jsp?orderId=' + order.id + '&paymentMethod=' + (order.paymentMethod || 1);
        }

        async function confirmReceive() {
            if (!confirm('确定收到货了吗？')) return;
            try {
                var formData = new FormData();
                formData.append('id', order.id);
                var response = await fetch(ctx + '/api/order/confirm', { method: 'POST', body: formData });
                var result = await response.json();
                if (result.code === 200) {
                    alert('确认签收成功！');
                    localStorage.removeItem('order_timer_' + order.id);
                    window.location.href = ctx + '/pages/order-list.jsp?filter=3';
                } else {
                    alert(result.message || '操作失败');
                }
            } catch (error) {
                console.error('确认签收失败:', error);
                alert('操作失败，请重试');
            }
        }

        async function returnOrder() {
            window.location.href = ctx + '/pages/return-order.jsp?id=' + order.id;
        }

        async function cancelOrder() {
            if (!confirm('确定取消该订单吗？')) return;
            try {
                var formData = new FormData();
                formData.append('id', order.id);
                formData.append('reason', '用户取消订单');
                var response = await fetch(ctx + '/api/order/cancel', { method: 'POST', body: formData });
                var result = await response.json();
                if (result.code === 200) {
                    alert('订单已取消');
                    window.location.href = ctx + '/pages/order-list.jsp';
                } else {
                    alert(result.message || '取消失败');
                }
            } catch (error) {
                console.error('取消失败:', error);
                alert('取消失败，请重试');
            }
        }

        async function deleteOrder() {
            if (!confirm('确定要删除该订单吗？删除后不可恢复。')) return;
            try {
                var formData = new FormData();
                formData.append('id', order.id);
                var response = await fetch(ctx + '/api/order/delete', { method: 'POST', body: formData });
                var result = await response.json();
                if (result.code === 200) {
                    alert('订单已删除');
                    window.location.href = ctx + '/pages/order-list.jsp';
                } else {
                    alert(result.message || '删除失败');
                }
            } catch (error) {
                console.error('删除失败:', error);
                alert('删除失败，请重试');
            }
        }

        function formatTime(timestamp) {
            if (!timestamp) return '';
            var date = new Date(timestamp);
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            var h = date.getHours();
            var min = date.getMinutes();
            var s = date.getSeconds();
            return y + '年' + (m < 10 ? '0' : '') + m + '月' + (d < 10 ? '0' : '') + d + '日 ' + (h < 10 ? '0' : '') + h + ':' + (min < 10 ? '0' : '') + min + ':' + (s < 10 ? '0' : '') + s;
        }

        function logout() {
            if (confirm('确定要退出登录吗？')) {
                fetch(ctx + '/api/user/logout')
                    .then(function(r) { return r.json(); })
                    .then(function() { window.location.href = ctx + '/pages/login.jsp'; })
                    .catch(function() { window.location.href = ctx + '/pages/login.jsp'; });
            }
        }

        window.onload = init;
    </script>
</body>
</html>