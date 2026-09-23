<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车 - 购物系统</title>
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

        .cart-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .cart-header {
            display: grid;
            grid-template-columns: 50px 100px 1fr 120px 120px 120px 80px;
            padding: 15px 20px;
            background: #f8f8f8;
            font-weight: 600;
            border-bottom: 2px solid #eee;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 50px 100px 1fr 120px 120px 120px 80px;
            padding: 20px;
            align-items: center;
            border-bottom: 1px solid #eee;
            transition: background 0.3s;
        }

        .cart-item:hover {
            background: #f9f9f9;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            cursor: pointer;
        }

        .product-name {
            font-size: 16px;
            color: #333;
            cursor: pointer;
        }

        .product-name:hover {
            color: #667eea;
        }

        .price {
            color: #f5576c;
            font-size: 18px;
            font-weight: 600;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 5px;
            font-size: 18px;
            transition: all 0.3s;
        }

        .quantity-btn:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .quantity-input {
            width: 60px;
            height: 30px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .subtotal {
            color: #f5576c;
            font-size: 20px;
            font-weight: 600;
        }

        .delete-btn {
            padding: 8px 16px;
            background: #ff4757;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .delete-btn:hover {
            background: #ff3838;
        }

        .cart-footer {
            background: white;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .select-all {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }

        .total-info {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .total-text {
            font-size: 18px;
            color: #666;
        }

        .total-price {
            font-size: 28px;
            color: #f5576c;
            font-weight: 600;
        }

        .checkout-btn {
            padding: 15px 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
        }

        .empty-cart {
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
            padding: 15px 50px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .shop-btn:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">🛒 购物系统</a>
            <div class="nav-links">
                <a href="${ctx}/index.jsp">首页</a>
                <a href="${ctx}/pages/cart.jsp">购物车</a>
                <a href="#" onclick="goToOrders()">我的订单</a>
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
        <h1 class="page-title">购物车</h1>

        <div id="cartContent">
            <!-- 购物车内容将通过JavaScript动态加载 -->
        </div>
    </div>

    <script>
        const ctx = '${ctx}';

        function handleCartImgError(img) {
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

        // 跳转到订单列表（带登录检查）
        function goToOrders() {
            if (!isLoggedIn()) {
                redirectToLogin(ctx + '/pages/order-list.jsp');
                return;
            }
            window.location.href = ctx + '/pages/order-list.jsp';
        }
        let cartList = [];

        async function loadCart() {
            try {
                const response = await fetch(ctx + '/api/cart/list');
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    cartList = result.data;
                    renderCart();
                } else if (result.code === 401) {
                    window.location.href = ctx + '/pages/login.jsp';
                } else {
                    showEmptyCart();
                }
            } catch (error) {
                console.error('加载购物车失败:', error);
                showEmptyCart();
            }
        }

        function renderCart() {
            const container = document.getElementById('cartContent');

            if (cartList.length === 0) {
                showEmptyCart();
                return;
            }

            let html =
                '<div class="cart-table">' +
                    '<div class="cart-header">' +
                        '<div>选择</div>' +
                        '<div>商品</div>' +
                        '<div>商品名称</div>' +
                        '<div>单价</div>' +
                        '<div>数量</div>' +
                        '<div>小计</div>' +
                        '<div>操作</div>' +
                    '</div>';

            cartList.forEach(item => {
                const checked = item.checked === 1 ? 'checked' : '';
                var prodImg = item.productImage || '';
                var prodId = item.productId || 0;
                var prodImgUrl;
                if (prodImg && prodImg.startsWith('http')) {
                    prodImgUrl = prodImg;
                } else {
                    var tsMatch = prodImg.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                    if (tsMatch) {
                        prodImgUrl = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                    } else if (prodId && prodId > 0) {
                        prodImgUrl = ctx + '/images/products/' + prodId + '.jpg';
                    } else if (prodImg && prodImg.length > 0) {
                        prodImgUrl = ctx + '/images/products/' + prodImg;
                    } else {
                        prodImgUrl = ctx + '/images/products/default-product.jpg';
                    }
                }
                html +=
                    '<div class="cart-item" data-id="' + item.id + '">' +
                        '<div>' +
                            '<input type="checkbox" class="checkbox" ' + checked + ' onchange="toggleCheck(' + item.id + ')">' +
                        '</div>' +
                        '<div style="width:80px;height:80px;border-radius:5px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
                            '<img src="' + prodImgUrl + '" alt="" style="width:100%;height:100%;object-fit:cover;cursor:pointer;" onclick="goToDetail(' + item.productId + ')" onerror="handleCartImgError(this)">' +
                            '<span style="display:none;font-size:30px;color:#ccc;">📦</span>' +
                        '</div>' +
                        '<div class="product-name" onclick="goToDetail(' + item.productId + ')">' + item.productName + (item.productStatus === 0 ? ' <span style="display:inline-block;background:#ff4d4f;color:#fff;font-size:11px;padding:1px 6px;border-radius:2px;vertical-align:middle;">已下架</span>' : '') + '</div>' +
                        '<div class="price">¥' + item.productPrice + '</div>' +
                        '<div class="quantity-control">' +
                            '<button class="quantity-btn" onclick="updateQuantity(' + item.id + ', ' + (item.quantity - 1) + ')">-</button>' +
                            '<input type="number" class="quantity-input" value="' + item.quantity + '" min="1" onchange="changeQuantity(' + item.id + ', this.value)">' +
                            '<button class="quantity-btn" onclick="updateQuantity(' + item.id + ', ' + (item.quantity + 1) + ')">+</button>' +
                        '</div>' +
                        '<div class="subtotal">¥' + (item.productPrice * item.quantity).toFixed(2) + '</div>' +
                        '<div>' +
                            '<button class="delete-btn" onclick="deleteItem(' + item.id + ')">删除</button>' +
                        '</div>' +
                    '</div>';
            });

            html += '</div>';

            const selectedItems = cartList.filter(item => item.checked === 1);
            const totalPrice = selectedItems.reduce((sum, item) => sum + item.productPrice * item.quantity, 0);

            html +=
                '<div class="cart-footer">' +
                    '<div class="select-all">' +
                        '<input type="checkbox" id="selectAll" onchange="toggleSelectAll()" ' + (selectedItems.length === cartList.length ? 'checked' : '') + '>' +
                        '<label for="selectAll">全选</label>' +
                    '</div>' +
                    '<div class="total-info">' +
                        '<div class="total-text">已选 ' + selectedItems.length + ' 件商品</div>' +
                        '<div class="total-text">总计：</div>' +
                        '<div class="total-price">¥' + totalPrice.toFixed(2) + '</div>' +
                        '<button class="shop-btn" onclick="window.location.href=\'' + ctx + '/index.jsp\'">去购物</button>' +
                        '<button class="checkout-btn" onclick="checkout()">去结算</button>' +
                    '</div>' +
                '</div>';

            container.innerHTML = html;
        }

        function showEmptyCart() {
            const container = document.getElementById('cartContent');
            container.innerHTML =
                '<div class="empty-cart">' +
                    '<div class="empty-icon">🛒</div>' +
                    '<div class="empty-text">购物车是空的</div>' +
                    '<button class="shop-btn" onclick="window.location.href=\'' + ctx + '/index.jsp\'">去逛逛</button>' +
                '</div>';
        }

        async function toggleCheck(itemId) {
            try {
                const formData = new FormData();
                formData.append('id', itemId);

                const item = cartList.find(i => i.id === itemId);
                formData.append('checked', item.checked === 1 ? 0 : 1);

                await fetch(ctx + '/api/cart/update', {
                    method: 'POST',
                    body: formData
                });

                loadCart();
            } catch (error) {
                console.error('更新失败:', error);
            }
        }

        async function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checked = selectAll.checked ? 1 : 0;

            try {
                for (const item of cartList) {
                    const formData = new FormData();
                    formData.append('id', item.id);
                    formData.append('checked', checked);

                    await fetch(ctx + '/api/cart/update', {
                        method: 'POST',
                        body: formData
                    });
                }
                loadCart();
            } catch (error) {
                console.error('更新失败:', error);
            }
        }

        async function updateQuantity(itemId, newQuantity) {
            if (newQuantity < 0) return;

            if (newQuantity === 0) {
                await deleteItem(itemId);
                return;
            }

            try {
                const formData = new FormData();
                formData.append('id', itemId);
                formData.append('quantity', newQuantity);

                await fetch(ctx + '/api/cart/update', {
                    method: 'POST',
                    body: formData
                });

                loadCart();
            } catch (error) {
                console.error('更新失败:', error);
            }
        }

        async function changeQuantity(itemId, newQuantity) {
            const quantity = parseInt(newQuantity);
            if (quantity < 1) {
                loadCart();
                return;
            }
            await updateQuantity(itemId, quantity);
        }

        async function deleteItem(itemId) {
            if (!confirm('确定要删除这个商品吗？')) return;

            try {
                const formData = new FormData();
                formData.append('id', itemId);

                await fetch(ctx + '/api/cart/delete', {
                    method: 'POST',
                    body: formData
                });

                loadCart();
            } catch (error) {
                console.error('删除失败:', error);
            }
        }

        function checkout() {
            if (!isLoggedIn()) {
                redirectToLogin(window.location.href);
                return;
            }
            const selectedItems = cartList.filter(item => item.checked === 1);
            if (selectedItems.length === 0) {
                alert('请选择要结算的商品');
                return;
            }

            const offShelfItems = selectedItems.filter(item => item.productStatus === 0);
            if (offShelfItems.length > 0) {
                alert('选中的商品中包含已下架商品，请移除后再结算');
                return;
            }

            const itemIds = selectedItems.map(item => item.id).join(',');
            window.location.href = ctx + '/pages/order-confirm.jsp?items=' + itemIds;
        }

        function goToDetail(productId) {
            if (!isLoggedIn()) {
                redirectToLogin(window.location.href);
                return;
            }
            var item = cartList.find(function(i) { return i.productId === productId; });
            if (item && item.productStatus === 0) {
                alert('该商品已下架');
                return;
            }
            window.location.href = ctx + '/pages/product-detail.jsp?id=' + productId
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

        window.onload = loadCart;
    </script>
</body>
</html>