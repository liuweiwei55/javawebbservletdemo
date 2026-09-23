<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>退货退款 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: #f5f5f5; min-height: 100vh; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .nav-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .logo { color: white; font-size: 24px; font-weight: bold; text-decoration: none; }
        .nav-links { display: flex; gap: 20px; align-items: center; }
        .nav-links a { color: white; text-decoration: none; padding: 8px 16px; border-radius: 5px; transition: background 0.3s; }
        .nav-links a:hover { background: rgba(255,255,255,0.2); }
        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }

        .return-card { background: white; border-radius: 10px; padding: 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .return-title { font-size: 24px; color: #333; margin-bottom: 30px; text-align: center; }
        .return-icon { text-align: center; font-size: 60px; margin-bottom: 20px; }

        .order-info { background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 25px; }
        .order-info-item { display: flex; padding: 5px 0; font-size: 14px; color: #666; }
        .order-info-label { width: 80px; font-weight: 600; }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; color: #333; font-size: 15px; font-weight: 600; }
        .form-textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; resize: vertical; min-height: 120px; font-family: inherit; }
        .form-textarea:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 2px rgba(102,126,234,0.2); }

        .btn-group { display: flex; gap: 15px; margin-top: 30px; }
        .btn { flex: 1; padding: 12px 0; border: none; border-radius: 8px; cursor: pointer; font-size: 16px; font-weight: 600; transition: all 0.3s; }
        .btn-cancel { background: #f0f0f0; color: #666; }
        .btn-cancel:hover { background: #e0e0e0; }
        .btn-submit { background: #fa8c16; color: white; }
        .btn-submit:hover { background: #ffa940; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }

        .success-card { display: none; text-align: center; }
        .success-icon { font-size: 80px; margin-bottom: 20px; }
        .success-title { font-size: 22px; color: #333; margin-bottom: 10px; }
        .success-desc { color: #666; font-size: 15px; margin-bottom: 30px; line-height: 1.8; }
        .success-desc .highlight { color: #fa8c16; font-weight: 700; }
        .countdown { font-size: 28px; color: #fa8c16; font-weight: 700; margin: 15px 0; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">购物系统</a>
            <div class="nav-links">
                <a href="${ctx}/index.jsp">首页</a>
                <a href="${ctx}/pages/cart.jsp">购物车</a>
                <a href="${ctx}/pages/order-list.jsp">我的订单</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="return-card" id="returnForm">
            <div class="return-icon">📦</div>
            <div class="return-title">申请退货退款</div>
            <div class="order-info" id="orderInfo">
                <div class="order-info-item"><span class="order-info-label">订单编号：</span><span id="orderNo"></span></div>
                <div class="order-info-item"><span class="order-info-label">订单金额：</span><span id="orderAmount" style="color:#f5576c;font-weight:600;"></span></div>
            </div>
            <div class="form-group">
                <label class="form-label">退货原因（选填）</label>
                <textarea class="form-textarea" id="returnReason" placeholder="请描述退货原因..."></textarea>
            </div>
            <div class="btn-group">
                <button class="btn btn-cancel" onclick="cancelReturn()">取消</button>
                <button class="btn btn-submit" onclick="submitReturn()">确认</button>
            </div>
        </div>

        <div class="return-card success-card" id="successCard">
            <div class="success-icon">✅</div>
            <div class="success-title">退货退款申请已提交</div>
            <div class="success-desc">
                您的退款将在<span class="highlight">一天内</span>退回原支付账户<br>
                请耐心等待，如有疑问请联系客服
            </div>
            <div class="btn-group">
                <button class="btn btn-primary" onclick="goHome()">返回首页</button>
                <button class="btn btn-submit" onclick="goOrders()">确认</button>
            </div>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';
        var orderId = null;

        function init() {
            var urlParams = new URLSearchParams(window.location.search);
            orderId = urlParams.get('id');
            if (!orderId) {
                alert('订单ID不能为空');
                window.location.href = ctx + '/pages/order-list.jsp';
                return;
            }

            var username = '${sessionScope.username}';
            if (!username || username === '') {
                alert('请先登录');
                window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                return;
            }

            loadOrderInfo();
        }

        async function loadOrderInfo() {
            try {
                var response = await fetch(ctx + '/api/order/detail?id=' + orderId);
                var result = await response.json();
                if (result.code === 200 && result.data) {
                    var order = result.data;
                    document.getElementById('orderNo').textContent = order.orderNo;
                    document.getElementById('orderAmount').textContent = '¥' + (order.actualAmount || 0).toFixed(2);
                }
            } catch (error) {
                console.error('加载订单信息失败:', error);
            }
        }

        function cancelReturn() {
            window.location.href = ctx + '/pages/order-list.jsp';
        }

        async function submitReturn() {
            var reason = document.getElementById('returnReason').value.trim();

            try {
                var formData = new FormData();
                formData.append('id', orderId);
                if (reason) formData.append('reason', reason);

                var response = await fetch(ctx + '/api/order/return', {
                    method: 'POST',
                    body: formData
                });

                var result = await response.json();

                if (result.code === 200) {
                    document.getElementById('returnForm').style.display = 'none';
                    document.getElementById('successCard').style.display = 'block';

                } else {
                    alert(result.message || '申请失败');
                }
            } catch (error) {
                console.error('退货退款申请失败:', error);
                alert('申请失败，请重试');
            }
        }

        function goHome() {
            window.location.href = ctx + '/index.jsp';
        }

        function goOrders() {
            window.location.href = ctx + '/pages/order-list.jsp';
        }

        function startCountdown(targetTime) {
            function update() {
                var now = new Date().getTime();
                var remaining = targetTime - now;
                if (remaining <= 0) {
                    document.getElementById('countdownTimer').textContent = '订单已完成';
                    document.getElementById('completeTimeDisplay').textContent = '0分钟';
                    return;
                }
                var hours = Math.floor(remaining / 3600000);
                var minutes = Math.floor((remaining % 3600000) / 60000);
                var seconds = Math.floor((remaining % 60000) / 1000);
                document.getElementById('countdownTimer').textContent =
                    hours + '小时 ' + minutes + '分 ' + seconds + '秒';
                document.getElementById('completeTimeDisplay').textContent =
                    hours + '小时' + minutes + '分钟';
                setTimeout(update, 1000);
            }
            update();
        }

        init();
    </script>
</body>
</html>