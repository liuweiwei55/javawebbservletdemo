<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单评价 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: #f5f5f5; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px 0; }
        .nav-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .logo { color: white; font-size: 24px; font-weight: bold; text-decoration: none; }
        .container { max-width: 900px; margin: 30px auto; padding: 0 20px; }
        .comment-card { background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { margin-bottom: 25px; color: #333; }
        .order-products { margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px solid #eee; }
        .order-products-title { font-size: 15px; font-weight: 600; color: #333; margin-bottom: 12px; }
        .product-list { display: flex; flex-wrap: wrap; gap: 15px; }
        .product-item { display: flex; align-items: center; gap: 10px; padding: 10px; background: #f9f9f9; border-radius: 6px; flex: 1; min-width: 220px; }
        .product-item img { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; background: #f0f0f0; }
        .product-item .p-name { font-size: 14px; color: #333; }
        .product-item .p-price { font-size: 13px; color: #f5576c; margin-top: 4px; font-weight: 600; }
        .rating-section { margin-bottom: 30px; }
        .rating-label { font-size: 16px; color: #333; font-weight: 600; margin-bottom: 15px; display: block; }
        .stars { display: flex; gap: 10px; font-size: 40px; cursor: pointer; }
        .star { color: #d4d4d4; transition: all 0.2s; }
        .star.active, .star:hover { color: #ffc107; transform: scale(1.15); }
        .rating-hint { margin-top: 10px; font-size: 13px; color: #999; }
        .content-section { margin-bottom: 25px; }
        .content-label { font-size: 16px; color: #333; font-weight: 600; margin-bottom: 12px; display: block; }
        .comment-textarea { width: 100%; height: 150px; padding: 12px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; resize: vertical; outline: none; font-family: inherit; transition: all 0.2s; }
        .comment-textarea:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .anonymous-option { margin-bottom: 25px; display: flex; align-items: center; gap: 8px; font-size: 14px; color: #555; }
        .anonymous-option input { cursor: pointer; }
        .button-group { display: flex; gap: 15px; justify-content: flex-end; }
        .btn { padding: 12px 30px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-submit { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.4); }
        .btn-submit:disabled { background: #ccc; cursor: not-allowed; transform: none; box-shadow: none; }
        .btn-cancel { background: #f0f0f0; color: #555; }
        .btn-cancel:hover { background: #e0e0e0; }
        .nav-links { color: white; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-container">
            <a href="${ctx}/index.jsp" class="logo">购物系统</a>
            <a href="${ctx}/pages/order-list.jsp" class="nav-links">我的订单</a>
        </div>
    </div>

    <div class="container">
        <div class="comment-card">
            <h1>订单评价</h1>
            
            <div class="order-products">
                <div class="order-products-title" id="productsTitle">正在加载订单商品...</div>
                <div class="product-list" id="productList"></div>
            </div>

            <div class="rating-section">
                <label class="rating-label">评分：</label>
                <div class="stars" id="starContainer">
                    <span class="star" data-rating="1">★</span>
                    <span class="star" data-rating="2">★</span>
                    <span class="star" data-rating="3">★</span>
                    <span class="star" data-rating="4">★</span>
                    <span class="star" data-rating="5">★</span>
                </div>
                <div class="rating-hint">点击星星选择评分（最低1星）</div>
            </div>

            <div class="content-section">
                <label class="content-label">评价内容：</label>
                <textarea class="comment-textarea" id="commentContent" placeholder="请分享您对这些商品的看法..."></textarea>
            </div>

            <div class="anonymous-option">
                <input type="checkbox" id="isAnonymous" name="isAnonymous">
                <label for="isAnonymous">匿名评论</label>
            </div>

            <div class="button-group">
                <button class="btn btn-cancel" onclick="cancelComment()">取消</button>
                <button class="btn btn-submit" id="submitBtn" onclick="submitComment()">确认评价</button>
            </div>
        </div>
    </div>

    <script>
        const ctx = '${ctx}';

        function handleCommentImgError(img) {
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

        let productId = null;
        let productIds = null;
        let orderId = null;
        let selectedRating = 0;

        function init() {
            const urlParams = new URLSearchParams(window.location.search);
            productId = urlParams.get('productId');
            productIds = urlParams.get('productIds');
            orderId = urlParams.get('orderId');

            if ((!productId && !productIds) || !orderId) {
                alert('参数错误');
                window.location.href = ctx + '/pages/order-list.jsp';
                return;
            }

            loadOrderItems();
            initStars();
        }

        async function loadOrderItems() {
            try {
                const response = await fetch(ctx + '/api/order/items?orderId=' + orderId);
                const result = await response.json();
                if (result.code === 200 && result.data) {
                    const items = result.data;
                    const list = document.getElementById('productList');
                    const title = document.getElementById('productsTitle');
                    title.textContent = '本次评价的商品（共 ' + items.length + ' 件）';
                    let html = '';
                    for (const item of items) {
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
                        html += '<div class="product-item">';
                        html += '<div style="width:80px;height:80px;border-radius:5px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">';
                        html += '<img src="' + primaryImgUrl + '" alt="" style="width:100%;height:100%;object-fit:cover;" onerror="handleCommentImgError(this)">';
                        html += '<span style="display:none;font-size:30px;color:#ccc;">📦</span>';
                        html += '</div>';
                        html += '<div>';
                        html += '<div class="p-name">' + (item.productName || '商品') + '</div>';
                        if (item.price) html += '<div class="p-price">¥' + parseFloat(item.price).toFixed(2) + '</div>';
                        html += '</div>';
                        html += '</div>';
                    }
                    list.innerHTML = html;
                }
            } catch (e) {
                console.error(e);
            }
        }

        function initStars() {
            const stars = document.querySelectorAll('.star');
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    selectedRating = parseInt(this.dataset.rating);
                    stars.forEach((s, index) => {
                        if (index < selectedRating) s.classList.add('active');
                        else s.classList.remove('active');
                    });
                });
            });
        }

        async function submitComment() {
            const content = document.getElementById('commentContent').value.trim();
            const isAnonymous = document.getElementById('isAnonymous').checked ? 1 : 0;

            if (!content) { alert('请输入评价内容'); return; }
            if (selectedRating === 0) { alert('请选择评分'); return; }

            const params = new URLSearchParams();
            if (productIds) params.append('productIds', productIds);
            else if (productId) params.append('productIds', productId);
            params.append('orderId', orderId);
            params.append('content', content);
            params.append('rating', selectedRating);
            params.append('isAnonymous', isAnonymous);

            const btn = document.getElementById('submitBtn');
            btn.disabled = true; btn.textContent = '提交中...';

            try {
                const response = await fetch(ctx + '/api/comment/add', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                });
                const result = await response.json();
                if (result.code === 200) {
                    alert('评价成功！');
                    window.location.href = ctx + '/pages/order-list.jsp';
                } else {
                    alert(result.message || '评价失败');
                    btn.disabled = false; btn.textContent = '确认评价';
                }
            } catch (error) {
                alert('评价失败，请重试');
                btn.disabled = false; btn.textContent = '确认评价';
            }
        }

        function cancelComment() {
            if (confirm('确定要取消评价吗？')) {
                window.location.href = ctx + '/pages/order-list.jsp';
            }
        }

        document.addEventListener('DOMContentLoaded', init);
    </script>
</body>
</html>