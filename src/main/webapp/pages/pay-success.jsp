<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>支付成功 - 购物系统</title>
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

        .success-container {
            background: white;
            border-radius: 16px;
            padding: 50px 40px;
            width: 90%;
            max-width: 480px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 28px;
            color: #52c41a;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .success-desc {
            font-size: 16px;
            color: #666;
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
        }

        .order-info-row .label {
            color: #999;
        }

        .order-info-row .value {
            color: #333;
            font-weight: 500;
        }

        .btn-group {
            display: flex;
            gap: 15px;
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
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-home {
            background: #f5f5f5;
            color: #666;
            border: 1px solid #ddd;
        }

        .btn-home:hover {
            background: #e0e0e0;
        }

        .btn-order {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">🎉</div>
        <h2 class="success-title">支付成功！</h2>
        <p class="success-desc">感谢您的购买，订单已支付成功</p>

        <div class="order-info">
            <div class="order-info-row">
                <span class="label">订单编号</span>
                <span class="value" id="orderNo">--</span>
            </div>
            <div class="order-info-row">
                <span class="label">支付金额</span>
                <span class="value" id="payAmount">--</span>
            </div>
        </div>

        <div class="btn-group">
            <a href="${ctx}/index.jsp" class="btn btn-home">返回首页</a>
            <a href="${ctx}/pages/order-list.jsp" class="btn btn-order">查看订单</a>
        </div>
    </div>

    <script>
        const ctx = '${ctx}';
        const urlParams = new URLSearchParams(window.location.search);
        const orderNo = urlParams.get('orderNo');
        const amount = urlParams.get('amount');

        if (orderNo) {
            document.getElementById('orderNo').textContent = orderNo;
        }
        if (amount) {
            document.getElementById('payAmount').textContent = '¥' + parseFloat(amount).toFixed(2);
        }
    </script>
</body>
</html>
