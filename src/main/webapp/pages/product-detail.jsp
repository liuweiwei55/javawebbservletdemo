<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品详情 - 购物系统</title>
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

        .product-main {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 40px;
        }

        .product-images {
            position: sticky;
            top: 20px;
        }

        .main-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
            background: #f0f0f0;
            display: block;
        }

        .main-image-wrapper {
            width: 100%;
            height: 400px;
            overflow: hidden;
            border-radius: 10px;
            margin-bottom: 15px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .thumbnail-list {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .thumbnail {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color 0.3s;
            background: #f0f0f0;
        }

        .thumbnail:hover, .thumbnail.active {
            border-color: #667eea;
        }

        .product-info h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }

        .price-section {
            background: #fff5f5;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .current-price {
            font-size: 36px;
            color: #f5576c;
            font-weight: 600;
        }

        .original-price {
            font-size: 18px;
            color: #999;
            text-decoration: line-through;
            margin-left: 15px;
        }

        .discount-badge {
            display: inline-block;
            background: #f5576c;
            color: white;
            padding: 4px 12px;
            border-radius: 5px;
            font-size: 14px;
            margin-left: 15px;
        }

        .info-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .info-label {
            width: 100px;
            color: #666;
            font-weight: 600;
        }

        .info-value {
            flex: 1;
            color: #333;
        }

        .stock-status {
            color: #52c41a;
            font-weight: 600;
        }

        .out-of-stock {
            color: #ff4757;
            font-weight: 600;
        }

        .sales-info {
            color: #666;
        }

        .quantity-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin: 30px 0;
        }

        .quantity-label {
            font-size: 16px;
            color: #666;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 5px;
            font-size: 20px;
            transition: all 0.3s;
        }

        .quantity-btn:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .quantity-input {
            width: 80px;
            height: 40px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 18px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .add-cart-btn {
            flex: 1;
            padding: 15px;
            background: linear-gradient(135deg, #ffa500 0%, #ff8c00 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .add-cart-btn:hover {
            transform: translateY(-2px);
        }

        .buy-now-btn {
            flex: 1;
            padding: 15px;
            background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .buy-now-btn:hover {
            transform: translateY(-2px);
        }

        .description-section {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .description-content {
            line-height: 1.8;
            color: #666;
            font-size: 16px;
        }

        .comments-section {
            background: white;
            border-radius: 10px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .comment-form {
            margin-bottom: 30px;
        }

        .comment-textarea {
            width: 100%;
            min-height: 100px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            resize: vertical;
            margin-bottom: 15px;
        }

        .anonymous-option {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-right: 15px;
            font-size: 14px;
        }

        .anonymous-option input[type="checkbox"] {
            width: 14px;
            height: 14px;
            cursor: pointer;
        }

        .anonymous-option label {
            color: #666;
            cursor: pointer;
            font-size: 14px;
        }

        .submit-comment-btn {
            padding: 10px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s;
            vertical-align: middle;
        }

        .submit-comment-btn:hover {
            background: #764ba2;
        }

        .comment-item {
            padding: 20px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 600;
            flex-shrink: 0;
            overflow: hidden;
        }

        .comment-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .comment-main {
            flex: 1;
            min-width: 0;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .comment-user {
            font-size: 13px;
            color: #999;
        }

        .comment-time {
            color: #999;
            font-size: 14px;
        }

        .comment-content {
            color: #666;
            line-height: 1.6;
            flex: 1;
        }

        .comment-body {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
        }

        .comment-left {
            flex: 1;
            min-width: 0;
        }

        .comment-right {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
            flex-shrink: 0;
            min-width: 160px;
        }

        .comment-like {
            display: flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            color: #333;
            transition: color 0.3s;
            flex-shrink: 0;
            justify-content: flex-end;
        }

        .comment-like:hover,
        .comment-like.liked {
            color: #f5576c;
        }

        .comment-like .like-count {
            transition: color 0.3s;
        }

        .like-icon {
            font-size: 20px;
        }

        .comment-rating {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 4px;
            flex-shrink: 0;
        }

        .comment-rating .rating-stars {
            color: #ffc107;
            font-size: 14px;
        }

        .comment-rating .rating-text {
            color: #333;
            font-size: 13px;
            font-weight: 500;
            text-align: right;
        }

        .no-comments {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .admin-reply {
            margin-top: 10px;
            padding: 10px 14px;
            background: #f6ffed;
            border-left: 3px solid #52c41a;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            color: #333;
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
        <div class="product-main">
            <div class="product-images">
                <div class="main-image-wrapper">
                    <div id="mainImageFallback" style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;color:#999;font-size:80px;background:#f0f0f0;border-radius:10px">🛒</div>
                    <img id="mainImage" alt="商品图片" class="main-image" style="display:none" onerror="this.style.display='none';document.getElementById('mainImageFallback').style.display='flex'">
                </div>
                <div class="thumbnail-list" id="thumbnailList"></div>
            </div>

            <div class="product-info">
                <h1 id="productName"></h1>

                <div class="price-section">
                    <span class="current-price" id="currentPrice"></span>
                    <span class="original-price" id="originalPrice"></span>
                    <span class="discount-badge" id="discountBadge"></span>
                </div>

                <div class="info-row">
                    <div class="info-label">库存</div>
                    <div class="info-value">
                        <span class="stock-status" id="stockStatus"></span>
                        <span id="stockCount"></span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">销量</div>
                    <div class="info-value">
                        <span class="sales-info" id="salesCount"></span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">分类</div>
                    <div class="info-value" id="categoryName"></div>
                </div>

                <div class="quantity-section">
                    <div class="quantity-label">购买数量</div>
                    <div class="quantity-control">
                        <button class="quantity-btn" onclick="changeQuantity(-1)">-</button>
                        <input type="number" class="quantity-input" id="quantityInput" value="1" min="1">
                        <button class="quantity-btn" onclick="changeQuantity(1)">+</button>
                    </div>
                </div>

                <div class="action-buttons">
                    <button class="add-cart-btn" onclick="addToCart()">加入购物车</button>
                    <button class="buy-now-btn" onclick="buyNow()">立即购买</button>
                </div>
            </div>
        </div>

        <div class="description-section">
            <h2 class="section-title">商品描述</h2>
            <div class="description-content" id="description"></div>
        </div>

        <div class="comments-section">
            <h2 class="section-title">商品评论</h2>

            <c:if test="${not empty sessionScope.userId}">
            <div class="comment-form">
                <textarea class="comment-textarea" id="commentContent" placeholder="写下你对这个商品的看法..."></textarea>
                <div style="display: flex; align-items: center; margin-top: 10px;">
                    <div class="anonymous-option">
                        <input type="checkbox" id="isAnonymous" name="isAnonymous">
                        <label for="isAnonymous">匿名评论</label>
                    </div>
                    <button class="submit-comment-btn" onclick="submitComment()">发表评论</button>
                </div>
            </div>
            </c:if>

            <div id="commentsList"></div>
        </div>
    </div>

    <script>
        const ctx = '${ctx}';
        let productId = null;
        let product = null;

        function init() {
            const urlParams = new URLSearchParams(window.location.search);
            productId = urlParams.get('id');

            if (productId) {
                loadProductDetail();
                loadComments();
            }
        }

        async function loadProductDetail() {
            try {
                const response = await fetch(ctx + '/api/product/detail?id=' + productId);
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    product = result.data;
                    if (product.status === 0) {
                        alert('该商品已下架');
                        window.location.href = ctx + '/index.jsp';
                        return;
                    }
                    renderProductDetail();
                } else {
                    alert('商品不存在');
                    window.location.href = ctx + '/index.jsp';
                }
            } catch (error) {
                console.error('加载商品详情失败:', error);
            }
        }

        function renderProductDetail() {
            if (product.status === 0) {
                document.getElementById('productName').innerHTML = product.name + ' <span style="display:inline-block;background:#ff4d4f;color:#fff;font-size:13px;padding:2px 10px;border-radius:3px;vertical-align:middle;margin-left:8px;">已下架</span>';
            } else {
                document.getElementById('productName').textContent = product.name;
            }
            document.getElementById('currentPrice').textContent = '¥' + product.price;
            document.getElementById('description').textContent = product.description || '暂无描述';
            document.getElementById('salesCount').textContent = (product.salesCount || 0) + ' 件';
            document.getElementById('categoryName').textContent = product.categoryName || '未分类';

            if (product.originalPrice) {
                document.getElementById('originalPrice').textContent = '¥' + product.originalPrice;
                const discount = Math.round((product.price / product.originalPrice) * 10);
                document.getElementById('discountBadge').textContent = discount + '折';
            }

            if (product.stock > 0) {
                document.getElementById('stockStatus').textContent = '有货';
                document.getElementById('stockStatus').className = 'stock-status';
                document.getElementById('stockCount').textContent = '（库存：' + product.stock + '）';
            } else {
                document.getElementById('stockStatus').textContent = '缺货';
                document.getElementById('stockStatus').className = 'out-of-stock';
                document.getElementById('stockCount').textContent = '';
            }

            const mainImg = document.getElementById('mainImage');
            const fallback = document.getElementById('mainImageFallback');
            var imgField = product.image || '';
            var prodId = product.id || 0;
            var primaryImage;
            if (imgField && imgField.startsWith('http')) {
                primaryImage = imgField;
            } else {
                var tsMatch = imgField.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                if (tsMatch) {
                    primaryImage = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                } else if (prodId && prodId > 0) {
                    primaryImage = ctx + '/images/products/' + prodId + '.jpg';
                } else if (imgField && imgField.length > 0) {
                    primaryImage = ctx + '/images/products/' + imgField;
                } else {
                    primaryImage = ctx + '/images/products/default-product.jpg';
                }
            }
            var defaultImage = ctx + '/images/products/default-product.jpg';
            mainImg.src = primaryImage;
            mainImg.onerror = function() {
                this.onerror = null;
                this.src = defaultImage;
                if (this.naturalWidth === 0 && fallback) { fallback.style.display = 'flex'; this.style.display = 'none'; }
            };
            mainImg.style.display = 'block';
            if (fallback) fallback.style.display = 'none';

            if (product.images) {
                try {
                    const images = JSON.parse(product.images);
                    const thumbnailList = document.getElementById('thumbnailList');
                    thumbnailList.innerHTML = '';

                    function resolveThumb(img) {
                        if (img && img.startsWith('http')) return img;
                        var tsMatch = img.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                        if (tsMatch) return ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                        if (img && img.length > 0) return ctx + '/images/products/' + img;
                        return ctx + '/images/products/default-product.jpg';
                    }

                    images.forEach((img, index) => {
                        const thumb = document.createElement('img');
                        thumb.src = resolveThumb(img);
                        thumb.className = 'thumbnail' + (index === 0 ? ' active' : '');
                        thumb.onerror = function() { this.style.display = 'none'; };
                        thumb.onclick = () => {
                            const mImg = document.getElementById('mainImage');
                            const fb = document.getElementById('mainImageFallback');
                            mImg.src = resolveThumb(img);
                            mImg.onerror = function() { this.style.display = 'none'; if (fb) fb.style.display = 'flex'; };
                            mImg.style.display = 'block';
                            if (fb) fb.style.display = 'none';
                            document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
                            thumb.classList.add('active');
                        };
                        thumbnailList.appendChild(thumb);
                    });
                } catch (e) {
                    console.error('解析图片列表失败:', e);
                }
            }
        }

        function changeQuantity(delta) {
            const input = document.getElementById('quantityInput');
            let newValue = parseInt(input.value) + delta;
            if (newValue < 1) newValue = 1;
            if (product && newValue > product.stock) {
                alert('超过库存限制');
                return;
            }
            input.value = newValue;
        }

        async function addToCart() {
            if (product && product.status === 0) {
                alert('该商品已下架，无法购买');
                return;
            }
            // 主动检查登录状态
            if ('${sessionScope.username}' === '') {
                alert('请先登录！');
                window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                return;
            }
            const quantity = parseInt(document.getElementById('quantityInput').value);

            try {
                const formData = new FormData();
                formData.append('productId', productId);
                formData.append('quantity', quantity);

                const response = await fetch(ctx + '/api/cart/add', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('添加成功！');
                } else if (result.code === 401) {
                    alert('请先登录！');
                    window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                } else {
                    alert(result.message || '添加失败');
                }
            } catch (error) {
                console.error('添加购物车失败:', error);
                alert('添加失败，请重试');
            }
        }

        function buyNow() {
            if ('${sessionScope.username}' === '') {
                alert('请先登录！');
                window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                return;
            }
            const quantity = parseInt(document.getElementById('quantityInput').value);
            window.location.href = ctx + '/pages/order-confirm.jsp?productId=' + productId + '&quantity=' + quantity;
        }

        async function loadComments() {
            try {
                const response = await fetch(ctx + '/api/comment/list?productId=' + productId);
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    renderComments(result.data);
                }
            } catch (error) {
                console.error('加载评论失败:', error);
            }
        }

        function renderComments(comments) {
            const container = document.getElementById('commentsList');

            if (comments.length === 0) {
                container.innerHTML = '<div class="no-comments">暂无评论</div>';
                return;
            }

            let html = '';
            comments.forEach(comment => {
                const rawName = comment.username || '匿名用户';
                const displayName = comment.isAnonymous === 1 ? maskName(rawName) : rawName;
                
                // 处理头像：始终使用用户的真实头像（包括匿名用户），如果没有则使用默认头像
                let avatarHtml = '';
                if (comment.avatar) {
                    // 如果有头像数据（base64或URL），直接显示
                    const avatarSrc = comment.avatar.startsWith('http') || comment.avatar.startsWith('data:') 
                        ? comment.avatar 
                        : ctx + '/images/avatars/' + comment.avatar;
                    avatarHtml = '<div class="comment-avatar"><img src="' + avatarSrc + '" alt="头像" onerror="this.parentElement.innerHTML=\'👤\';this.parentElement.style.background=\'#f0f0f0\';this.parentElement.style.color=\'#666\';this.parentElement.style.fontSize=\'22px\'"></div>';
                } else {
                    // 如果没有头像，使用默认头像（与用户中心一致）
                    avatarHtml = '<div class="comment-avatar" style="background: #f0f0f0; color: #666; font-size: 22px;">👤</div>';
                }

                let ratingHtml = '';
                if (comment.orderId && comment.rating) {
                    const stars = '★'.repeat(comment.rating) + '☆'.repeat(5 - comment.rating);
                    let ratingExtraText = '';
                    if (comment.rating === 5) {
                        ratingExtraText = '该用户觉得非常好！';
                    } else if (comment.rating === 4) {
                        ratingExtraText = '该用户觉得不错！';
                    }
                    ratingHtml =
                        '<div class="comment-rating">' +
                            '<span class="rating-stars">' + stars + '</span>' +
                            (ratingExtraText ? '<span class="rating-text">' + ratingExtraText + '</span>' : '') +
                        '</div>';
                }

                html +=
                    '<div class="comment-item">' +
                        avatarHtml +
                        '<div class="comment-main">' +
                            '<div class="comment-header">' +
                                '<span class="comment-user">' + displayName + '</span>' +
                                '<span class="comment-time">' + formatTime(comment.createTime) + '</span>' +
                            '</div>' +
                            '<div class="comment-body">' +
                                '<div class="comment-left">' +
                                    '<div class="comment-content">' + comment.content + '</div>' + (comment.replyContent ? '<div class="admin-reply"><strong>🔹 管理员回复：</strong>' + comment.replyContent + '</div>' : '') +
                                '</div>' +
                                '<div class="comment-right">' +
                                    '<div class="comment-like" onclick="toggleLike(' + comment.id + ', this)">' +
                                        '<span class="like-icon">❤️</span>' +
                                        '<span class="like-count">' + (comment.likeCount || 0) + '</span>' +
                                    '</div>' +
                                    ratingHtml +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
            });

            container.innerHTML = html;
        }

        async function submitComment() {
            if ('${sessionScope.username}' === '') {
                alert('请先登录！');
                window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                return;
            }

            if (!productId) {
                alert('商品信息丢失，请刷新页面重试');
                return;
            }

            const contentEl = document.getElementById('commentContent');
            const isAnonymousEl = document.getElementById('isAnonymous');
            if (!contentEl || !isAnonymousEl) {
                alert('评论表单未加载，请刷新页面重试');
                return;
            }

            const content = contentEl.value.trim();
            const isAnonymous = isAnonymousEl.checked ? 1 : 0;

            if (!content) {
                alert('请输入评论内容');
                return;
            }

            try {
                const params = new URLSearchParams();
                params.append('productId', productId);
                params.append('content', content);
                params.append('rating', 0);
                params.append('isAnonymous', isAnonymous);

                const response = await fetch(ctx + '/api/comment/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params.toString()
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('评论成功！');
                    contentEl.value = '';
                    loadComments();
                } else {
                    alert(result.message || '评论失败');
                }
            } catch (error) {
                console.error('评论失败:', error);
                alert('评论失败，请重试');
            }
        }

        function maskName(name) {
            if (!name || name.length <= 1) return name;
            return name.charAt(0) + '***';
        }

        function formatTime(timestamp) {
            const date = new Date(timestamp);
            return date.toLocaleString('zh-CN');
        }

        // 点赞/取消点赞功能
        async function toggleLike(commentId, element) {
            if ('${sessionScope.username}' === '') {
                alert('请先登录！');
                window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                return;
            }

            try {
                const isLiked = element.classList.contains('liked');
                const url = ctx + (isLiked ? '/api/comment/unlike' : '/api/comment/like');

                const params = new URLSearchParams();
                params.append('commentId', commentId);

                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params.toString()
                });

                const result = await response.json();

                if (result.code === 200) {
                    // 切换样式
                    element.classList.toggle('liked');
                    
                    // 更新点赞数
                    const likeCountSpan = element.querySelector('.like-count');
                    let count = parseInt(likeCountSpan.textContent);
                    if (isLiked) {
                        count = Math.max(0, count - 1);
                    } else {
                        count += 1;
                    }
                    likeCountSpan.textContent = count;
                } else {
                    alert(result.message || '操作失败');
                }
            } catch (error) {
                console.error('点赞操作失败:', error);
                alert('操作失败，请重试');
            }
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

        window.onload = init;
    </script>
</body>
</html>