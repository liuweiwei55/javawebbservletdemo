<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物系统 - 首页</title>
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
        .search-bar { background: white; padding: 20px; margin: 20px auto; max-width: 1200px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .search-form { display: flex; gap: 10px; }
        .search-input { flex: 1; padding: 12px; border: 2px solid #ddd; border-radius: 5px; font-size: 16px; }
        .search-btn { padding: 12px 30px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; transition: background 0.3s; }
        .search-btn:hover { background: #764ba2; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }
        .category-bar { display: flex; gap: 10px; overflow-x: auto; padding: 10px 0; margin-bottom: 10px; }
        .category-item { padding: 8px 20px; background: white; border-radius: 20px; cursor: pointer; white-space: nowrap; transition: all 0.3s; border: 2px solid #ddd; font-size: 14px; color: #333; user-select: none; }
        .category-item:hover, .category-item.active { background: #667eea; color: white; border-color: #667eea; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .product-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); transition: transform 0.3s, box-shadow 0.3s; cursor: pointer; position: relative; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.15); }
        .product-image-wrapper { width: 100%; height: 250px; overflow: hidden; background: #f0f0f0; display: flex; align-items: center; justify-content: center; position: relative; }
        .product-image { width: 100%; height: 250px; object-fit: cover; display: block; }
        .product-info { padding: 15px; position: relative; }
        .product-name { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 10px; height: 40px; overflow: hidden; display: flex; align-items: center; justify-content: space-between; }
        .product-price { color: #f5576c; font-size: 24px; font-weight: bold; margin-bottom: 10px; }
        .product-original-price { color: #999; font-size: 14px; text-decoration: line-through; margin-left: 10px; }
        .product-sales { color: #666; font-size: 14px; }
        .add-cart-btn { width: 100%; padding: 10px; background: #667eea; color: white; border: none; cursor: pointer; font-size: 16px; transition: background 0.3s; }
        .add-cart-btn:hover { background: #764ba2; }
        .product-badge {
            position: absolute;
            padding: 5px 12px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            border-radius: 3px;
            z-index: 100;
        }
        .badge-hot {
            top: 10px;
            left: 10px;
            background: linear-gradient(135deg, #f5576c, #ff6b6b);
            box-shadow: 0 2px 8px rgba(245, 87, 108, 0.4);
        }
        .badge-new {
            bottom: 10px;
            right: 10px;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            box-shadow: 0 2px 8px rgba(79, 172, 254, 0.4);
        }
        .badge-off-shelf {
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.65);
            font-size: 13px;
            padding: 4px 10px;
        }
        .product-card-off-shelf {
            opacity: 0.6;
            cursor: default;
        }
        .product-card-off-shelf:hover {
            transform: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .footer { background: #333; color: white; text-align: center; padding: 30px 20px; margin-top: 50px; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">🛒 购物系统</a>
            <div class="nav-links">
                <a href="${ctx}/index.jsp">首页</a>
                <a href="#" onclick="goToCart()">购物车</a>
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

    <div class="search-bar">
        <div class="search-form">
            <input type="text" class="search-input" id="searchInput" placeholder="搜索商品...">
            <button type="button" class="search-btn" onclick="doSearch()">搜索</button>
        </div>
    </div>

    <div class="container">
        <div class="category-bar" id="categoryBar">
            <div class="category-item active" onclick="filterByCategory(null, this)">全部</div>
        </div>
        <h2 class="section-title" id="sectionTitle">热门商品</h2>
        <div class="product-grid" id="productList"></div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 购物系统. All rights reserved.</p>
    </footer>

    <script>
        var ctx = '${ctx}';

        function handleIndexImgError(img) {
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

        function resolveProductImage(product) {
            var id = product ? (product.id || 0) : 0;
            var img = product ? (product.image || '') : '';
            if (img && img.startsWith('http')) {
                return img;
            }
            var tsMatch = img.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
            if (tsMatch) {
                return ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
            }
            // 优先使用商品 ID 来构建 URL（图片文件按 ID 命名）
            if (id && id > 0) {
                return ctx + '/images/products/' + id + '.jpg';
            }
            if (img && img.length > 0) {
                return ctx + '/images/products/' + img;
            }
            return ctx + '/images/products/default-product.jpg';
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

        // 跳转到订单列表（带登录检查）
        function goToOrders() {
            if (!isLoggedIn()) {
                redirectToLogin(ctx + '/pages/order-list.jsp');
                return;
            }
            window.location.href = ctx + '/pages/order-list.jsp';
        }

        // 添加到购物车（带登录检查）
        async function addToCart(productId) {
            if (!isLoggedIn()) {
                redirectToLogin(window.location.href);
                return;
            }
            try {
                var formData = new FormData();
                formData.append('productId', productId);
                formData.append('quantity', 1);

                var response = await fetch(ctx + '/api/cart/add', {
                    method: 'POST',
                    body: formData
                });
                var result = await response.json();

                if (result.code === 200) {
                    alert('已加入购物车！');
                } else if (result.code === 401) {
                    redirectToLogin(window.location.href);
                } else {
                    alert(result.message || '添加失败');
                }
            } catch (error) {
                console.error('添加购物车失败:', error);
                alert('添加失败，请重试');
            }
        }

        function loadProducts(categoryId, keyword) {
            var url = ctx + '/api/product/list?pageSize=100&pageNum=1';
            if (categoryId) url += '&categoryId=' + categoryId;
            if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

            console.log('=== 加载商品列表 ===');
            console.log('URL:', url);
            
            fetch(url)
                .then(function(response) { 
                    console.log('响应状态:', response.status);
                    return response.json(); 
                })
                .then(function(result) {
                    console.log('响应数据:', result);
                    var productList = document.getElementById('productList');
                    if (result.code === 200 && result.data && result.data.length > 0) {
                        console.log('商品数量:', result.data.length);
                        productList.innerHTML = '';
                        for (var i = 0; i < result.data.length; i++) {
                            var card = createProductCard(result.data[i]);
                            productList.appendChild(card);
                        }
                    } else {
                        console.log('无商品或错误:', result.message);
                        productList.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #999;">暂无商品<br>请先到后台添加商品数据</div>';
                    }
                })
                .catch(function(error) {
                    console.error('加载商品失败:', error);
                });
        }

        function createProductCard(product) {
            var div = document.createElement('div');
            var isOffShelf = product.status === 0;
            div.className = 'product-card' + (isOffShelf ? ' product-card-off-shelf' : '');

            var imageUrl = resolveProductImage(product);
            var defaultUrl = ctx + '/images/products/default-product.jpg';

            var price = product.price ? parseFloat(product.price).toFixed(2) : '0.00';
            var originalPrice = product.originalPrice ? parseFloat(product.originalPrice).toFixed(2) : null;
            var originalPriceHtml = originalPrice ?
                '<span class="product-original-price">¥' + originalPrice + '</span>' : '';
            var salesCount = product.salesCount || 0;
            var isHot = product.isHot === 1;
            var offShelfBadge = isOffShelf ? '<span class="product-badge badge-off-shelf">已下架</span>' : '';
            var isNew = product.isNew === 1;

            div.innerHTML =
                (isHot ? '<span class="product-badge badge-hot">Hot</span>' : '') +
                offShelfBadge +
                '<div class="product-image-wrapper" style="position:relative;">' +
                    (isNew ? '<span class="product-badge badge-new">New</span>' : '') +
                    '<img src="' + imageUrl + '" alt="" class="product-image" onerror="handleIndexImgError(this)">' +
                    '<span style="display:none;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:60px;color:#ccc;">📦</span>' +
                '</div>' +
                '<div class="product-info">' +
                    '<div class="product-name">' + (product.name || '未知商品') + '</div>' +
                    '<div class="product-price">¥' + price + originalPriceHtml + '</div>' +
                    '<div class="product-sales">销量：' + salesCount + '</div>' +
                '</div>' +
                (isOffShelf ? '<button class="add-cart-btn" style="background:#ccc;cursor:not-allowed;">已下架</button>' :
                '<button class="add-cart-btn" data-product-id="' + product.id + '">加入购物车</button>');

            // 点击商品卡片跳转到详情页（需要登录）
            div.addEventListener('click', function(e) {
                // 如果点击的是加入购物车按钮，不触发跳转
                if (e.target.classList.contains('add-cart-btn')) {
                    return;
                }
                if (isOffShelf) {
                    alert('该商品已下架');
                    return;
                }
                if (!isLoggedIn()) {
                    redirectToLogin(ctx + '/pages/product-detail.jsp?id=' + product.id);
                    return;
                }
                window.location.href = ctx + '/pages/product-detail.jsp?id=' + product.id;
            });

            // 加入购物车按钮点击事件
            var cartBtn = div.querySelector('.add-cart-btn');
            cartBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                if (isOffShelf) {
                    alert('该商品已下架');
                    return;
                }
                if (!isLoggedIn()) {
                    redirectToLogin(window.location.href);
                    return;
                }
                addToCart(product.id);
            });

            return div;
        }

        function doSearch() {
            var keyword = document.getElementById('searchInput').value.trim();
            var title = document.getElementById('sectionTitle');
            if (keyword) {
                title.textContent = '搜索结果："' + keyword + '"';
                // 搜索时重置分类高亮
                document.querySelectorAll('.category-item').forEach(function(item) {
                    item.classList.remove('active');
                });
            } else {
                title.textContent = '热门商品';
                document.querySelectorAll('.category-item').forEach(function(item) {
                    item.classList.remove('active');
                });
                var firstCat = document.querySelector('.category-item');
                if (firstCat) firstCat.classList.add('active');
            }
            loadProducts(null, keyword);
        }

        function loadCategories() {
            fetch(ctx + '/api/category/list')
                .then(function(response) { return response.json(); })
                .then(function(result) {
                    if (result.code === 200 && result.data) {
                        renderCategories(result.data);
                    }
                })
                .catch(function(error) {
                    console.error('加载分类失败:', error);
                });
        }

        function renderCategories(categories) {
            var categoryBar = document.getElementById('categoryBar');
            if (!categoryBar) return;
            var html = '<div class="category-item active" onclick="filterByCategory(null, this)">全部</div>';
            for (var i = 0; i < categories.length; i++) {
                html += '<div class="category-item" onclick="filterByCategory(' + categories[i].id + ', this)">' + categories[i].name + '</div>';
            }
            categoryBar.innerHTML = html;
        }

        function filterByCategory(categoryId, element) {
            document.querySelectorAll('.category-item').forEach(function(item) {
                item.classList.remove('active');
            });
            if (element) element.classList.add('active');
            // 清除搜索框
            document.getElementById('searchInput').value = '';
            document.getElementById('sectionTitle').textContent = categoryId ? '分类商品' : '热门商品';
            loadProducts(categoryId, null);
        }

        // 搜索框回车触发搜索
        document.getElementById('searchInput').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') doSearch();
        });

        function logout() {
            if (confirm('确定要退出登录吗？')) {
                fetch(ctx + '/api/user/logout')
                    .then(function(response) { return response.json(); })
                    .then(function(result) {
                        window.location.href = ctx + '/pages/login.jsp';
                    })
                    .catch(function(error) {
                        window.location.href = ctx + '/pages/login.jsp';
                    });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            loadCategories();
            loadProducts();
        });
    </script>
</body>
</html>