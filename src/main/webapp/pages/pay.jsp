<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单支付 - 购物系统</title>
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
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .pay-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .pay-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 30px;
        }

        .order-info {
            background: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }

        .order-info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
            color: #666;
        }

        .order-info-row .label {
            color: #999;
        }

        .order-info-row .value {
            color: #333;
            font-weight: 500;
        }

        .amount {
            font-size: 36px;
            color: #f5576c;
            font-weight: 700;
            margin: 20px 0;
        }

        .payment-section {
            margin: 30px 0;
            text-align: left;
        }

        .payment-section-title {
            font-size: 16px;
            color: #333;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .payment-option {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-option:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .payment-option.selected {
            border-color: #667eea;
            background: #f0f3ff;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .payment-option-icon {
            font-size: 32px;
        }

        .payment-option-info {
            flex: 1;
        }

        .payment-option-name {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }

        .payment-option-desc {
            font-size: 13px;
            color: #999;
            margin-top: 3px;
        }

        .payment-option-check {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            border: 2px solid #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: transparent;
            transition: all 0.3s;
        }

        .payment-option.selected .payment-option-check {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-cancel {
            background: #f5f5f5;
            color: #666;
            border: 1px solid #ddd;
        }

        .btn-cancel:hover {
            background: #e0e0e0;
        }

        .btn-confirm {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .loading.show {
            display: flex;
        }

        .loading-text {
            color: white;
            font-size: 18px;
        }

        .error-message {
            color: #ff4d4f;
            font-size: 14px;
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="pay-container">
        <h2 class="pay-title">订单支付</h2>

        <div class="order-info">
            <div class="order-info-row">
                <span class="label">订单编号</span>
                <span class="value" id="orderNo">--</span>
            </div>
            <div class="order-info-row">
                <span class="label">支付金额</span>
                <span class="value" id="actualAmount">--</span>
            </div>
        </div>

        <div class="amount" id="amountDisplay">--</div>

        <div class="payment-section">
            <div class="payment-section-title">选择支付方式</div>
            <div class="payment-options" id="paymentOptions">
                <div class="payment-option" data-method="1" onclick="selectPayment(1)">
                    <div class="payment-option-icon">💰</div>
                    <div class="payment-option-info">
                        <div class="payment-option-name">支付宝</div>
                        <div class="payment-option-desc">支付宝安全支付</div>
                    </div>
                    <div class="payment-option-check">✓</div>
                </div>
                <div class="payment-option" data-method="2" onclick="selectPayment(2)">
                    <div class="payment-option-icon">💬</div>
                    <div class="payment-option-info">
                        <div class="payment-option-name">微信支付</div>
                        <div class="payment-option-desc">微信安全支付</div>
                    </div>
                    <div class="payment-option-check">✓</div>
                </div>
                <div class="payment-option" data-method="3" onclick="selectPayment(3)">
                    <div class="payment-option-icon">💳</div>
                    <div class="payment-option-info">
                        <div class="payment-option-name">银行卡</div>
                        <div class="payment-option-desc">银行卡快捷支付</div>
                    </div>
                    <div class="payment-option-check">✓</div>
                </div>
            </div>
        </div>

        <div class="error-message" id="errorMsg"></div>

        <div class="btn-group">
            <button class="btn btn-cancel" onclick="cancelPay()">取消支付</button>
            <button class="btn btn-confirm" onclick="confirmPay()">确认支付</button>
        </div>
    </div>

    <div class="loading" id="loading">
        <div class="loading-text">支付处理中...</div>
    </div>

    <script>
        const ctx = '${ctx}';
        let orderId = null;
        let paymentMethod = null;

        const paymentMethods = {
            1: { name: '支付宝', icon: '💰', desc: '支付宝安全支付' },
            2: { name: '微信支付', icon: '💬', desc: '微信安全支付' },
            3: { name: '银行卡', icon: '💳', desc: '银行卡快捷支付' }
        };

        function init() {
            const urlParams = new URLSearchParams(window.location.search);
            orderId = urlParams.get('orderId');
            paymentMethod = parseInt(urlParams.get('paymentMethod')) || 1;

            if (!orderId) {
                alert('订单信息不完整');
                window.location.href = ctx + '/pages/order-list.jsp';
                return;
            }

            selectPayment(paymentMethod);
            loadOrderDetail();
        }

        async function loadOrderDetail() {
            try {
                const response = await fetch(ctx + '/api/order/detail?id=' + orderId);
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    const order = result.data;
                    document.getElementById('orderNo').textContent = order.orderNo;
                    document.getElementById('actualAmount').textContent = '¥' + parseFloat(order.actualAmount).toFixed(2);
                    document.getElementById('amountDisplay').textContent = '¥' + parseFloat(order.actualAmount).toFixed(2);

                    selectPayment(paymentMethod);
                } else {
                    showError('获取订单信息失败');
                }
            } catch (error) {
                console.error('加载订单失败:', error);
                showError('加载订单信息失败');
            }
        }

        async function confirmPay() {
            document.getElementById('loading').classList.add('show');

            try {
                const params = new URLSearchParams();
                params.append('id', orderId);
                params.append('paymentMethod', paymentMethod);

                const response = await fetch(ctx + '/api/order/pay', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                });

                const result = await response.json();

                if (result.code === 200) {
                    const orderNo = document.getElementById('orderNo').textContent;
                    const amount = document.getElementById('amountDisplay').textContent.replace('¥', '');
                    window.location.href = ctx + '/pages/pay-success.jsp?orderNo=' + encodeURIComponent(orderNo) + '&amount=' + encodeURIComponent(amount);
                } else {
                    document.getElementById('loading').classList.remove('show');
                    showError(result.message || '支付失败');
                }
            } catch (error) {
                document.getElementById('loading').classList.remove('show');
                console.error('支付失败:', error);
                showError('支付请求失败，请重试');
            }
        }

        function selectPayment(method) {
            paymentMethod = parseInt(method);
            document.querySelectorAll('.payment-option').forEach(function(opt) {
                opt.classList.remove('selected');
                if (parseInt(opt.getAttribute('data-method')) === paymentMethod) {
                    opt.classList.add('selected');
                }
            });
        }

        function cancelPay() {
            if (confirm('确定要取消支付吗？')) {
                window.location.href = ctx + '/pages/order-list.jsp';
            }
        }

        function showError(message) {
            const errorEl = document.getElementById('errorMsg');
            errorEl.textContent = message;
            errorEl.style.display = 'block';
        }

        window.onload = init;
    </script>
</body>
</html>
