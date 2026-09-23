<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f5f5f5;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 5px;
            transition: background 0.3s;
        }

        .nav-links a:hover {
            background: rgba(255,255,255,0.2);
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 28px;
            margin-bottom: 20px;
            color: #333;
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .tab-btn {
            padding: 10px 20px;
            background: #f5f5f5;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
        }

        .tab-btn:hover {
            background: #e0e0e0;
        }

        .tab-btn.active {
            background: #667eea;
            color: white;
        }

        .order-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            margin-bottom: 15px;
        }

        .order-info {
            display: flex;
            gap: 30px;
        }

        .order-no {
            font-size: 16px;
            color: #333;
        }

        .order-time {
            color: #999;
            font-size: 14px;
        }

        .order-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-pending {
            background: #fff7e6;
            color: #fa8c16;
        }

        .status-paid {
            background: #e6f7ff;
            color: #1890ff;
        }

        .status-delivered {
            background: #f6ffed;
            color: #52c41a;
        }

        .status-completed {
            background: #dcfce7;
            color: #16a34a;
            font-weight: 700;
        }

        .status-cancelled {
            background: #fff1f0;
            color: #ff4d4f;
        }

        .status-timeout {
            background: #fff1f0;
            color: #ff4d4f;
            font-weight: 600;
        }

        .order-items {
            margin-bottom: 15px;
        }

        .order-item {
            display: flex;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }

        .item-specs {
            color: #999;
            font-size: 14px;
        }

        .item-price {
            color: #f5576c;
            font-size: 18px;
            font-weight: 600;
        }

        .item-quantity {
            color: #666;
            font-size: 14px;
        }

        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .total-amount {
            font-size: 18px;
            color: #666;
        }

        .actual-amount {
            font-size: 24px;
            color: #f5576c;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #764ba2;
        }

        .btn-success {
            background: #52c41a;
            color: white;
        }

        .btn-success:hover {
            background: #73d13d;
        }

        .btn-danger {
            background: #ff4d4f;
            color: white;
        }

        .btn-danger:hover {
            background: #ff7875;
        }

        .btn-warning {
            background: #fa8c16;
            color: white;
        }

        .btn-warning:hover {
            background: #ffa940;
        }

        .empty-orders {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .empty-icon {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-text {
            font-size: 20px;
            color: #999;
            margin-bottom: 30px;
        }

        .shop-btn {
            padding: 12px 40px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .shop-btn:hover {
            background: #764ba2;
        }

        .countdown-info {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            background: #fffbe6;
            border-radius: 8px;
            margin-bottom: 10px;
            font-size: 14px;
            color: #ad8b00;
        }

        .countdown-info.shipped {
            background: #e6f7ff;
            color: #096dd9;
        }

        .countdown-time {
            font-weight: 700;
            font-size: 16px;
            color: #d48806;
            font-family: 'Courier New', monospace;
        }

        .countdown-time.shipped {
            color: #096dd9;
        }

        .countdown-label {
            font-size: 13px;
            margin-left: 5px;
            color: #999;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">🛒 购物系统</a>
            <div class="nav-links">
                <a href="${ctx}/index.jsp">首页</a>
                <a href="#" onclick="goToCart()">购物车</a>
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
        <h1 class="page-title">我的订单</h1>

        <div class="filter-tabs">
            <button class="tab-btn active" onclick="filterOrders('all')">全部订单</button>
            <button class="tab-btn" onclick="filterOrders('0')">待支付</button>
            <button class="tab-btn" onclick="filterOrders('1')">未发货</button>
            <button class="tab-btn" onclick="filterOrders('2')">已发货</button>
            <button class="tab-btn" onclick="filterOrders('3')">已完成</button>
        </div>

        <div id="orderList"></div>
    </div>

    <script>
        const ctx = '${ctx}';
        let allOrders = [];
        let currentFilter = 'all';
        let payCountdownTimer = null;
        let refundCountdownTimer = null;
        const PAY_TIMEOUT_MS = 20 * 60 * 1000; // 20分钟

        // 处理商品图片加载失败
        function handleOrderItemImgError(img) {
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

        // 检查登录状态
        function isLoggedIn() {
            return '${sessionScope.username}' !== '';
        }

        // 跳转登录页并带上返回地址
        function redirectToLogin(returnUrl) {
            alert('请先登录！');
            window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(returnUrl);
        }

        // 跳转到购物车（带登录检查）
        function goToCart() {
            if (!isLoggedIn()) {
                redirectToLogin(ctx + '/pages/cart.jsp');
                return;
            }
            window.location.href = ctx + '/pages/cart.jsp';
        }

        async function loadOrders() {
            try {
                const response = await fetch(ctx + '/api/order/list');
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    allOrders = result.data;
                    console.log('=== loadOrders: 加载了 ' + allOrders.length + ' 个订单 ===');
                    allOrders.forEach(order => {
                        console.log('订单 ID: ' + order.id + ', 状态: ' + order.status);
                    });
                    updateFilterCounts();
                    renderOrders();
                } else if (result.code === 401) {
                    window.location.href = ctx + '/pages/login.jsp';
                } else {
                    showEmptyOrders();
                }
            } catch (error) {
                console.error('加载订单失败:', error);
                showEmptyOrders();
            }
        }

        function filterOrders(status) {
            currentFilter = status;

            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            if (event && event.target) {
                event.target.classList.add('active');
            } else {
                // 如果没有 event，手动设置 active 类
                const buttons = document.querySelectorAll('.tab-btn');
                buttons.forEach(btn => {
                    if (btn.textContent.includes(getStatusText(status))) {
                        btn.classList.add('active');
                    }
                });
            }

            renderOrders();
        }

        function getStatusText(status) {
            const statusMap = {
                'all': '全部订单',
                '0': '待支付',
                '1': '未发货',
                '2': '已发货',
                '3': '已完成'
            };
            return statusMap[status] || '';
        }

        function renderOrders() {
            const container = document.getElementById('orderList');

            // 同步tab按钮的active状态
            document.querySelectorAll('.tab-btn').forEach(function(btn) {
                btn.classList.remove('active');
            });
            const buttons = document.querySelectorAll('.tab-btn');
            const tabIndexMap = { 'all': 0, '0': 1, '1': 2, '2': 3, '3': 4 };
            const activeIndex = tabIndexMap[currentFilter];
            if (activeIndex !== undefined && buttons.length > activeIndex) {
                buttons[activeIndex].classList.add('active');
            }

            let filteredOrders = allOrders;
            if (currentFilter !== 'all') {
                if (currentFilter === '3') {
                    // 已完成tab包含已完成(3)、已取消(4)、已退款(6) + 已超时的待支付(0且已过期)
                    filteredOrders = allOrders.filter(order => {
                        if (order.status === 3 || order.status === 4 || order.status === 6) return true;
                        if (order.status === 0) {
                            const deadline = getPayDeadline(order);
                            return deadline <= 0 || Date.now() > deadline;
                        }
                        return false;
                    });
                } else if (currentFilter === '0') {
                    // 待支付tab仅包含未过期的待支付订单
                    filteredOrders = allOrders.filter(order => {
                        if (order.status !== 0) return false;
                        const deadline = getPayDeadline(order);
                        return deadline > 0 && Date.now() <= deadline;
                    });
                } else {
                    filteredOrders = allOrders.filter(order => order.status === parseInt(currentFilter));
                }
            }

            console.log('=== renderOrders: currentFilter=' + currentFilter + ', filteredOrders.length=' + filteredOrders.length + ' ===');
            filteredOrders.forEach(order => {
                console.log('筛选后订单 ID: ' + order.id + ', 状态: ' + order.status);
            });

            if (filteredOrders.length === 0) {
                showEmptyOrders();
                return;
            }

            let html = '';
            filteredOrders.forEach(order => {
                html += createOrderCard(order);
            });

            container.innerHTML = html;

            // 加载每个订单的商品信息
            filteredOrders.forEach(order => {
                loadOrderItems(order.id);
            });

            // 启动待支付倒计时
            startPayCountdown();
        }

        async function loadOrderItems(orderId) {
            try {
                const response = await fetch(ctx + '/api/order/items?orderId=' + orderId);
                const result = await response.json();
                const container = document.getElementById('items-' + orderId);
                if (!container) return;

                if (result.code === 200 && result.data && result.data.length > 0) {
                    let itemsHtml = '';
                    result.data.forEach(item => {
                        var pImg = item.productImage || item.image || '';
                        var pId = item.productId || item.id || 0;
                        var primaryImgUrl;
                        if (pImg && pImg.startsWith('http')) {
                            primaryImgUrl = pImg;
                        } else {
                            // 1. 首先尝试匹配 时间戳_ID.jpg 格式
                            var tsMatch = pImg.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                            if (tsMatch) {
                                primaryImgUrl = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                            } else if (pId && pId > 0) {
                                // 2. 如果有商品 ID，优先用 ID 构建 URL（图片文件按 ID 命名）
                                primaryImgUrl = ctx + '/images/products/' + pId + '.jpg';
                            } else if (pImg && pImg.length > 0) {
                                // 3. 没有有效的 ID，尝试原始文件名
                                primaryImgUrl = ctx + '/images/products/' + pImg;
                            } else {
                                // 4. 最后 fallback
                                primaryImgUrl = ctx + '/images/products/default-product.jpg';
                            }
                        }
                        itemsHtml +=
                            '<div class="order-item">' +
                                '<div style="width:80px;height:80px;border-radius:5px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
                                    '<img src="' + primaryImgUrl + '" alt="" style="width:100%;height:100%;object-fit:cover;" onerror="handleOrderItemImgError(this)">' +
                                    '<span style="display:none;font-size:30px;color:#ccc;">📦</span>' +
                                '</div>' +
                                '<div class="item-details">' +
                                    '<div class="item-name">' + (item.productName || '未知商品') + '</div>' +
                                    '<div class="item-specs">x' + item.quantity + '</div>' +
                                '</div>' +
                                '<div class="item-price">¥' + (item.subtotal ? parseFloat(item.subtotal).toFixed(2) : '0.00') + '</div>' +
                            '</div>';
                    });
                    container.innerHTML = itemsHtml;
                } else {
                    container.innerHTML = '<div style="padding: 10px; color: #999; text-align: center;">暂无商品信息</div>';
                }
            } catch (error) {
                console.error('加载订单项失败:', error);
                const container = document.getElementById('items-' + orderId);
                if (container) {
                    container.innerHTML = '<div style="padding: 10px; color: #999; text-align: center;">加载商品失败</div>';
                }
            }
        }

        // 获取或生成随机天数（持久化到 localStorage）
        function getRandomDays(orderId, type) {
            const key = 'order_' + type + '_' + orderId;
            let val = localStorage.getItem(key);
            if (!val) {
                val = Math.floor(Math.random() * 7) + 1; // 1-7
                localStorage.setItem(key, val);
            }
            return parseInt(val);
        }

        // 获取支付截止时间（创建时间+20分钟）
        function getPayDeadline(order) {
            if (!order || !order.createTime) {
                return 0;
            }
            const key = 'order_deadline_' + order.id;
            let stored = localStorage.getItem(key);
            let parsedStored = stored ? parseInt(stored) : NaN;
            if (stored && !isNaN(parsedStored) && parsedStored > 0) {
                return parsedStored;
            }
            let createTs = new Date(order.createTime).getTime();
            if (isNaN(createTs) || createTs <= 0) {
                const parts = String(order.createTime).match(/(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})[ T]?(\d{1,2})?:?(\d{1,2})?:?(\d{1,2})?/);
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
            if (isNaN(createTs) || createTs <= 0) {
                return 0;
            }
            let deadline = createTs + PAY_TIMEOUT_MS;
            localStorage.setItem(key, String(deadline));
            return deadline;
        }

        // 格式化倒计时显示 mm:ss
        function formatCountdown(ms) {
            if (isNaN(ms) || ms === null || ms === undefined) return '00:00';
            if (ms <= 0) return '00:00';
            const totalSec = Math.floor(ms / 1000);
            const m = Math.floor(totalSec / 60);
            const s = totalSec % 60;
            return (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
        }

        // 启动倒计时
        function startPayCountdown() {
            if (payCountdownTimer) clearInterval(payCountdownTimer);
            payCountdownTimer = setInterval(function() {
                let needReload = false;
                document.querySelectorAll('.countdown-timer').forEach(function(el) {
                    const orderId = parseInt(el.getAttribute('data-order-id'));
                    const order = allOrders.find(o => o.id === orderId);
                    if (!order || order.status !== 0) {
                        el.textContent = '';
                        return;
                    }
                    const deadline = getPayDeadline(order);
                    const remaining = deadline - Date.now();
                    if (deadline <= 0 || remaining <= 0) {
                        // 时间到了或已过期，更新整个订单状态标签为「已超时」
                        const orderCard = document.querySelector('.order-card[data-order-id="' + orderId + '"]');
                        if (orderCard) {
                            const statusEl = orderCard.querySelector('.order-status');
                            if (statusEl) {
                                statusEl.textContent = '已超时';
                                statusEl.className = 'order-status status-timeout';
                            }
                            // 更新按钮：只保留删除订单
                            const actionButtons = orderCard.querySelector('.action-buttons');
                            if (actionButtons) {
                                actionButtons.innerHTML =
                                    '<button class="btn btn-danger" onclick="deleteOrder(' + orderId + ')">删除订单</button>' +
                                    '<button class="btn btn-primary" onclick="viewDetail(' + orderId + ')">查看详情</button>';
                            }
                        }
                        el.textContent = '';
                        needReload = true;
                    } else {
                        el.textContent = formatCountdown(remaining);
                    }
                });
                if (needReload) {
                    updateFilterCounts();
                }
            }, 1000);

            if (refundCountdownTimer) clearInterval(refundCountdownTimer);
            refundCountdownTimer = setInterval(function() {
                document.querySelectorAll('.refund-countdown').forEach(function(el) {
                    const orderId = parseInt(el.getAttribute('data-order-id'));
                    const completeTime = new Date(el.getAttribute('data-complete-time')).getTime();
                    if (isNaN(completeTime) || completeTime - Date.now() <= 0) {
                        el.textContent = '已完成';
                        autoCompleteRefund(orderId);
                    } else {
                        el.textContent = formatCountdown(completeTime - Date.now()) + '后完成';
                    }
                });
            }, 1000);
        }

        // 自动取消超时订单
        async function autoCancelOrder(orderId) {
            try {
                const formData = new FormData();
                formData.append('id', orderId);
                formData.append('reason', '超时未支付，系统自动取消');
                const response = await fetch(ctx + '/api/order/cancel', {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    // 立即更新本地订单状态，防止循环调用
                    const order = allOrders.find(o => o.id === orderId);
                    if (order) {
                        order.status = 4;
                        order.cancelReason = '超时未支付，系统自动取消';
                    }
                    localStorage.removeItem('order_deadline_' + orderId);
                    // 延迟刷新列表
                    setTimeout(loadOrders, 500);
                }
            } catch (e) {
                console.error('自动取消订单失败:', e);
            }
        }

        async function autoCompleteRefund(orderId) {
            try {
                const formData = new FormData();
                formData.append('id', orderId);
                const response = await fetch(ctx + '/api/order/completeRefund', {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    const order = allOrders.find(o => o.id === orderId);
                    if (order) {
                        order.status = 6; // 退款完成后保持已退款状态
                    }
                    setTimeout(loadOrders, 500);
                }
            } catch (e) {
                console.error('自动完成退款订单失败:', e);
            }
        }

        function createOrderCard(order) {
            const statusMap = {
                0: { text: '待支付', class: 'status-pending' },
                1: { text: '未发货', class: 'status-paid' },
                2: { text: '已发货', class: 'status-delivered' },
                3: { text: '已完成', class: 'status-completed' },
                4: { text: '已取消', class: 'status-cancelled' },
                5: { text: '退款中', class: 'status-cancelled' },
                6: { text: '已退款', class: 'status-cancelled' }
            };

            const status = statusMap[order.status] || { text: '未知', class: '' };
            let statusText = status.text;
            let statusClass = status.class;
            
            // 调试：打印订单信息
            console.log('渲染订单 ID:', order.id, '状态:', order.status, 'hasComment:', order.hasComment);

            // 待支付：显示倒计时
            if (order.status === 0) {
                const deadline = getPayDeadline(order);
                if (deadline <= 0) {
                    statusText = '已超时';
                    statusClass = 'status-timeout';
                } else {
                    const remaining = deadline - Date.now();
                    if (remaining <= 0) {
                        statusText = '已超时';
                        statusClass = 'status-timeout';
                    } else {
                        statusText += ' <span class="countdown-timer" data-order-id="' + order.id + '">' + formatCountdown(remaining) + '</span>';
                    }
                }
            }
            // 未发货：显示预计x天发货
            if (order.status === 1) {
                const x = getRandomDays(order.id, 'ship');
                statusText += ' · 预计' + x + '天发货';
            }
            // 已发货：显示预计送达时间
            if (order.status === 2) {
                const y = getRandomDays(order.id, 'deliver');
                statusText += ' · 预计' + y + '天送达';
            }
            // 退款中：仅显示"退款中"文字，倒计时在后台静默运行
            if (order.status === 5 && order.refundCompleteTime) {
                const completeTime = new Date(order.refundCompleteTime).getTime();
                const remaining = completeTime - Date.now();
                if (remaining > 0) {
                    // 添加隐藏的倒计时元素用于后台检测，不显示具体时间
                    statusText += ' <span class="refund-countdown" data-order-id="' + order.id + '" data-complete-time="' + order.refundCompleteTime + '" style="display:none;"></span>';
                }
            }

            const timeStr = formatTime(order.createTime);

            let actionButtons = '';
            if (order.status === 0) {
                const deadline = getPayDeadline(order);
                if (deadline <= 0 || Date.now() > deadline) {
                    // 已超时：只显示删除订单
                    actionButtons = '<button class="btn btn-danger" onclick="deleteOrder(' + order.id + ')">删除订单</button>';
                } else {
                    actionButtons =
                        '<button class="btn btn-primary" onclick="goToPay(' + order.id + ',' + (order.paymentMethod || 1) + ')">去支付</button>' +
                        '<button class="btn btn-danger" onclick="cancelOrder(' + order.id + ')">取消订单</button>';
                }
            } else if (order.status === 1) {
                actionButtons =
                    '<button class="btn btn-warning" onclick="returnOrder(' + order.id + ')">申请退款</button>' +
                    '<button class="btn btn-success" onclick="confirmReceive(' + order.id + ')">确认收货</button>';
            } else if (order.status === 2) {
                actionButtons =
                    '<button class="btn btn-warning" onclick="returnOrder(' + order.id + ')">申请退款</button>' +
                    '<button class="btn btn-success" onclick="confirmReceive(' + order.id + ')">确认收货</button>';
            } else if (order.status === 3 || order.status === 4 || order.status === 6) {
                actionButtons =
                    '<button class="btn btn-danger" onclick="deleteOrder(' + order.id + ')">删除订单</button>';

                // 已完成订单且未评价的，显示立即评价按钮
                if (order.status === 3 && !order.hasComment) {
                    actionButtons =
                        '<button class="btn btn-success" onclick="rateProduct(' + order.id + ')">立即评价</button>' +
                        '<button class="btn btn-danger" onclick="deleteOrder(' + order.id + ')">删除订单</button>';
                }
            } else if (order.status === 5) {
                // 退款中：不显示删除按钮
                actionButtons = '';
            }

            actionButtons += '<button class="btn btn-primary" onclick="viewDetail(' + order.id + ')">查看详情</button>';

            return '<div class="order-card" data-order-id="' + order.id + '">' +
                    '<div class="order-header">' +
                        '<div class="order-info">' +
                            '<div class="order-no">订单号：' + order.orderNo + '</div>' +
                            '<div class="order-time">' + timeStr + '</div>' +
                        '</div>' +
                        '<div class="order-status ' + statusClass + '">' + statusText + '</div>' +
                    '</div>' +
                    '<div class="order-items" id="items-' + order.id + '">' +
                        '<div style="padding: 20px; text-align: center; color: #999;">加载中...</div>' +
                    '</div>' +
                    '<div class="order-footer">' +
                        '<div>' +
                            '<div class="total-amount" id="total-' + order.id + '">订单金额：¥' + order.totalAmount.toFixed(2) + '</div>' +
                        '</div>' +
                        '<div class="action-buttons">' +
                            actionButtons +
                        '</div>' +
                    '</div>' +
                '</div>';
        }

        function showEmptyOrders() {
            const container = document.getElementById('orderList');
            container.innerHTML =
                '<div class="empty-orders">' +
                    '<div class="empty-icon">📦</div>' +
                    '<div class="empty-text">暂无订单</div>' +
                    '<button class="shop-btn" onclick="window.location.href=\'' + ctx + '/index.jsp\'">去逛逛</button>' +
                '</div>';
        }

        function updateFilterCounts() {
            const counts = { all: allOrders.length, 0: 0, 1: 0, 2: 0, 3: 0 };
            allOrders.forEach(function(order) {
                // 已完成(3)、已取消(4)和已退款(6)归入已完成计数，加上超时的待支付
                // 退款中(5)的订单属于全部，不计入已完成
                if (order.status === 4 || order.status === 6) {
                    counts[3]++; // 已取消和已退款归入已完成计数
                } else if (order.status === 0) {
                    const deadline = new Date(order.createTime).getTime() + PAY_TIMEOUT_MS;
                    if (Date.now() > deadline) {
                        counts[3]++; // 超时待支付归入已完成计数
                    } else if (counts.hasOwnProperty(order.status)) {
                        counts[order.status]++;
                    }
                } else if (counts.hasOwnProperty(order.status)) {
                    counts[order.status]++;
                }
            });

            const labels = { all: '全部订单', 0: '待支付', 1: '未发货', 2: '已发货', 3: '已完成' };
            const btns = document.querySelectorAll('.tab-btn');
            const keys = ['all', '0', '1', '2', '3'];
            btns.forEach(function(btn, i) {
                btn.textContent = labels[keys[i]] + '(' + counts[keys[i]] + ')';
            });
        }

        function goToPay(orderId, paymentMethod) {
            window.location.href = ctx + '/pages/pay.jsp?orderId=' + orderId + '&paymentMethod=' + paymentMethod;
        }

        async function cancelOrder(orderId) {
            const reason = prompt('请输入取消原因（可留空）：', '');
            if (reason === null) return; // 用户点击取消按钮

            try {
                const formData = new FormData();
                formData.append('id', orderId);
                formData.append('reason', reason.trim() || '用户取消订单');

                const response = await fetch(ctx + '/api/order/cancel', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('订单已取消');
                    loadOrders();
                } else {
                    alert(result.message || '取消失败');
                }
            } catch (error) {
                console.error('取消失败:', error);
                alert('取消失败，请重试');
            }
        }

        async function returnOrder(orderId) {
            window.location.href = ctx + '/pages/return-order.jsp?id=' + orderId;
        }

        async function deleteOrder(orderId) {
            if (!confirm('确定要删除该订单吗？删除后不可恢复。')) return;

            try {
                const formData = new FormData();
                formData.append('id', orderId);

                const response = await fetch(ctx + '/api/order/delete', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('订单已删除');
                    loadOrders();
                } else {
                    alert(result.message || '删除失败');
                }
            } catch (error) {
                console.error('删除失败:', error);
                alert('删除失败，请重试');
            }
        }

        async function confirmReceive(orderId) {
            console.log('=== confirmReceive: orderId=' + orderId + ' ===');
            
            if (!confirm('确定收到货了吗？')) {
                console.log('用户取消了确认收货');
                return;
            }

            try {
                const formData = new FormData();
                formData.append('id', orderId);

                console.log('发送请求到:', ctx + '/api/order/confirm');
                
                const response = await fetch(ctx + '/api/order/confirm', {
                    method: 'POST',
                    body: formData
                });

                console.log('响应状态:', response.status);
                const result = await response.json();
                console.log('确认收货响应:', result);

                if (result.code === 200) {
                    alert('确认收货成功！');
                    console.log('开始重新加载订单列表，并切换到已完成标签...');
                    currentFilter = '3';
                    document.querySelectorAll('.tab-btn').forEach(btn => {
                        btn.classList.remove('active');
                    });
                    const buttons = document.querySelectorAll('.tab-btn');
                    if (buttons.length >= 5) {
                        buttons[4].classList.add('active');
                    }
                    loadOrders();
                } else {
                    alert(result.message || '操作失败');
                }
            } catch (error) {
                console.error('确认收货失败:', error);
                alert('操作失败，请重试');
            }
        }

        function viewDetail(orderId) {
            window.location.href = ctx + '/pages/order-detail.jsp?id=' + orderId;
        }

        async function rateProduct(orderId) {
            try {
                const response = await fetch(ctx + '/api/order/items?orderId=' + orderId);
                const result = await response.json();
                if (result.code === 200 && result.data && result.data.length > 0) {
                    const productIds = result.data.map(item => item.productId).filter(id => id);
                    if (!productIds || productIds.length === 0) {
                        alert('商品ID不存在');
                        return;
                    }
                    window.location.href = ctx + '/pages/comment-page.jsp?orderId=' + orderId + '&productIds=' + productIds.join(',');
                } else {
                    alert('订单商品信息不存在');
                }
            } catch (error) {
                console.error('获取订单商品信息失败:', error);
                alert('获取订单商品信息失败，请重试');
            }
        }

        function formatTime(timestamp) {
            const date = new Date(timestamp);
            return date.toLocaleString('zh-CN');
        }

        function logout() {
            if (confirm('确定要退出登录吗？')) {
                fetch(ctx + '/api/user/logout')
                    .then(response => response.json())
                    .then(result => {
                        window.location.href = ctx + '/pages/login.jsp';
                    })
                    .catch(error => {
                        window.location.href = ctx + '/pages/login.jsp';
                    });
            }
        }

        window.onload = function() {
            // 检查URL参数，如果有filter参数则切换到对应标签
            const urlParams = new URLSearchParams(window.location.search);
            const filterParam = urlParams.get('filter');
            if (filterParam) {
                currentFilter = filterParam;
            }
            loadOrders();
        };
    </script>
</body>
</html>