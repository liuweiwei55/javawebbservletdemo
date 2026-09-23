<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>确认订单 - 购物系统</title>
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

        .checkout-form {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 20px;
        }

        .left-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .section-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .address-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .address-item {
            padding: 15px;
            border: 2px solid #eee;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .address-item:hover {
            border-color: #667eea;
        }

        .address-item.selected {
            border-color: #667eea;
            background: #f0f5ff;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .receiver-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .receiver-phone {
            color: #666;
        }

        .address-detail {
            color: #666;
            line-height: 1.6;
        }

        .add-address-btn {
            padding: 12px;
            background: #f5f5f5;
            border: 2px dashed #ddd;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            color: #666;
            transition: all 0.3s;
        }

        .add-address-btn:hover {
            border-color: #667eea;
            color: #667eea;
        }

        .order-items {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .order-item {
            display: flex;
            gap: 15px;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 8px;
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

        .item-price {
            color: #f5576c;
            font-size: 18px;
            font-weight: 600;
        }

        .item-quantity {
            color: #666;
            font-size: 14px;
        }

        .right-section {
            position: sticky;
            top: 20px;
        }

        .summary-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 16px;
        }

        .summary-row.total {
            border-top: 2px solid #eee;
            margin-top: 10px;
            font-size: 20px;
            font-weight: 600;
        }

        .total-amount {
            color: #f5576c;
            font-size: 28px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }

        .submit-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.3s;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
        }

        .back-home-btn {
            width: 100%;
            padding: 12px;
            background: #f5f5f5;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.3s;
        }

        .back-home-btn:hover {
            background: #e0e0e0;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            max-width: 500px;
            width: 90%;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-title {
            font-size: 24px;
            color: #333;
        }

        .close-btn {
            font-size: 28px;
            color: #999;
            cursor: pointer;
            background: none;
            border: none;
        }

        .close-btn:hover {
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
        <h1 class="page-title">确认订单</h1>

        <div class="checkout-form">
            <div class="left-section">
                <div class="section-card">
                    <h3 class="section-title">收货地址</h3>
                    <div class="address-list" id="addressList">
                        <!-- 地址列表将通过JavaScript动态加载 -->
                    </div>
                </div>

                <div class="section-card">
                    <h3 class="section-title">商品信息</h3>
                    <div class="order-items" id="orderItems">
                        <!-- 商品列表将通过JavaScript动态加载 -->
                    </div>
                </div>
            </div>

            <div class="right-section">
                <div class="summary-card">
                    <h3 class="section-title">订单摘要</h3>
                    <div class="summary-row">
                        <div>商品总额：</div>
                        <div id="totalAmount">¥0.00</div>
                    </div>
                    <div class="summary-row">
                        <div>运费：</div>
                        <div id="shippingFee">¥3.00</div>
                    </div>
                    <div class="summary-row total">
                        <div>应付金额：</div>
                        <div class="total-amount" id="actualAmount">¥0.00</div>
                    </div>

                    <div class="form-group" style="margin-top: 20px;">
                        <label class="form-label">支付方式</label>
                        <select class="form-select" id="paymentMethod">
                            <option value="1">支付宝</option>
                            <option value="2">微信</option>
                            <option value="3">银行卡</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">订单备注</label>
                        <textarea class="form-textarea" id="remark" placeholder="选填，可以告诉卖家您的特殊要求"></textarea>
                    </div>

                    <button class="submit-btn" onclick="submitOrder()">提交订单</button>
                    <button class="back-home-btn" onclick="window.location.href='${ctx}/index.jsp'">返回首页</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 添加地址模态框 -->
    <div class="modal" id="addressModal" style="display:none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="addressModalTitle">添加收货地址</h3>
                <button class="close-btn" onclick="closeAddressModal()">&times;</button>
            </div>
            <form id="addressForm" onsubmit="return false;">
                <input type="hidden" id="editAddressId">
                <div class="form-group">
                    <label class="form-label">收货人 *</label>
                    <input type="text" class="form-input" id="addrReceiverName" required>
                </div>
                <div class="form-group">
                    <label class="form-label">联系电话 *</label>
                    <input type="tel" class="form-input" id="addrPhone" required>
                </div>
                <div class="form-group">
                    <label class="form-label">省份 *</label>
                    <select class="form-input" id="addrProvince" onchange="loadCities()">
                        <option value="">请选择省份</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">城市 *</label>
                    <select class="form-input" id="addrCity" onchange="loadDistricts()">
                        <option value="">请选择城市</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">区县 *</label>
                    <select class="form-input" id="addrDistrict">
                        <option value="">请选择区县</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">详细地址 *</label>
                    <textarea class="form-textarea" id="addrDetail" rows="3" style="resize:none;" required></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">邮政编码</label>
                    <input type="text" class="form-input" id="addrPostalCode">
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="addrIsDefault" value="1"> 设为默认地址
                    </label>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="button" class="submit-btn" onclick="saveAddress()" style="flex:1;">保存地址</button>
                    <button type="button" class="submit-btn" onclick="closeAddressModal()" style="flex:1;background:#f5f5f5;color:#666;">取消</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const ctx = '${ctx}';

        function handleConfirmImgError(img) {
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

        let addresses = [];
        let selectedAddressId = null;
        let orderItems = [];
        let totalAmount = 0;
        const SHIPPING_FEE = 3.00; // 运费固定3元

        function isLoggedIn() {
            var username = '${sessionScope.username}';
            return username && username !== '';
        }

        function redirectToLogin(redirectUrl) {
            alert('请先登录');
            window.location.href = ctx + '/pages/login.jsp?redirect=' + encodeURIComponent(redirectUrl || window.location.href);
        }

        function init() {
            if (!isLoggedIn()) {
                redirectToLogin();
                return;
            }

            const urlParams = new URLSearchParams(window.location.search);
            const itemsParam = urlParams.get('items');
            const productId = urlParams.get('productId');
            const quantity = urlParams.get('quantity');

            if (itemsParam) {
                // 从购物车结算
                loadCartItems(itemsParam);
            } else if (productId && quantity) {
                // 立即购买
                orderItems = [{
                    productId: parseInt(productId),
                    quantity: parseInt(quantity)
                }];
                loadProductDetail(productId);
            }

            loadAddresses();
        }

        async function loadAddresses() {
    try {
        const response = await fetch(ctx + '/api/address/list');
        const result = await response.json();

        if (result.code === 200 && result.data) {
            addresses = result.data;
            console.log('加载地址数据:', addresses);
            renderAddresses();

            if (addresses.length > 0) {
                const defaultAddress = addresses.find(a => {
                    return a.isDefault === 1 || a.isDefault === true || a.isDefault === '1';
                });
                selectedAddressId = defaultAddress ? defaultAddress.id : addresses[0].id;
                updateSelectedAddress();
            }
        }
    } catch (error) {
        console.error('加载地址失败:', error);
    }
}


        function renderAddresses() {
            const container = document.getElementById('addressList');
            let html = '';

            if (!addresses || addresses.length === 0) {
                html = '<div style="text-align: center; padding: 20px; color: #999;">暂无收货地址，请添加</div>';
            } else {
                addresses.forEach(function(addr) {
                    const receiverName = (addr.receiverName || '未知收货人').toString().trim();
                    const phone = (addr.phone || '未填写电话').toString().trim();
                    const province = (addr.province || '').toString().trim();
                    const city = (addr.city || '').toString().trim();
                    const district = (addr.district || '').toString().trim();
                    const detail = (addr.detail || '').toString().trim();

                    const isDefault = addr.isDefault === 1 || addr.isDefault === true || addr.isDefault === '1';
                    const selected = addr.id === selectedAddressId ? 'selected' : '';
                    const defaultTag = isDefault ? '<span style="color: #667eea; font-size: 12px; margin-left: 8px;">[默认]</span>' : '';

                    html += '<div class="address-item ' + selected + '">' +
                        '<div onclick="selectAddress(' + addr.id + ')" style="cursor:pointer;">' +
                            '<div class="address-header">' +
                                '<span class="receiver-name">' + receiverName + defaultTag + '</span>' +
                                '<span class="receiver-phone">' + phone + '</span>' +
                            '</div>' +
                            '<div class="address-detail">' + province + city + district + detail + '</div>' +
                        '</div>' +
                        '<div style="margin-top:8px;padding-top:8px;border-top:1px dashed #eee;display:flex;gap:8px;">' +
                            '<button type="button" style="padding:4px 12px;font-size:12px;border:1px solid #ddd;background:#fff;color:#666;border-radius:4px;cursor:pointer;" onclick="event.stopPropagation();viewAddressDetail(' + addr.id + ')">编辑</button>' +
                            '<button type="button" style="padding:4px 12px;font-size:12px;border:1px solid #ddd;background:#fff;color:#666;border-radius:4px;cursor:pointer;" onclick="event.stopPropagation();deleteAddress(' + addr.id + ')">删除</button>' +
                        '</div>' +
                        '</div>';
                });
            }

            html += '<div class="add-address-btn" onclick="openAddressModal()">+ 添加新地址</div>';
            container.innerHTML = html;
        }


        async function selectAddress(addressId) {
            try {
                var response = await fetch(ctx + '/api/address/default?addressId=' + addressId, {
                    method: 'POST'
                });

                var result = await response.json();

                if (result.code === 200) {
                    await loadAddresses();
                } else {
                    console.error('设置默认地址失败:', result.message);
                    selectedAddressId = addressId;
                    updateSelectedAddress();
                }
            } catch (error) {
                console.error('设置默认地址请求失败:', error);
                selectedAddressId = addressId;
                updateSelectedAddress();
            }
        }

        function updateSelectedAddress() {
            document.querySelectorAll('.address-item').forEach((item, index) => {
                if (addresses[index] && addresses[index].id === selectedAddressId) {
                    item.classList.add('selected');
                } else {
                    item.classList.remove('selected');
                }
            });
        }

        async function loadCartItems(itemsParam) {
            try {
                const itemIds = itemsParam.split(',');

                const response = await fetch(ctx + '/api/cart/list');
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    orderItems = result.data.filter(item =>
                        itemIds.includes(item.id.toString())
                    );
                    renderOrderItems();
                }
            } catch (error) {
                console.error('加载购物车失败:', error);
            }
        }

        async function loadProductDetail(productId) {
            try {
                var response = await fetch(ctx + '/api/product/detail?id=' + productId);
                var result = await response.json();

                if (result.code === 200 && result.data) {
                    var product = result.data;
                    if (product.status === 0) {
                        alert('该商品已下架');
                        window.location.href = ctx + '/index.jsp';
                        return;
                    }
                    var item = orderItems[0];
                    item.productName = product.name;
                    item.productPrice = product.price;
                    item.productImage = product.image;
                    renderOrderItems();
                }
            } catch (error) {
                console.error('加载商品失败:', error);
            }
        }

        function renderOrderItems() {
            var container = document.getElementById('orderItems');
            var html = '';
            totalAmount = 0;

            if (!orderItems || orderItems.length === 0) {
                html = '<div style="text-align: center; padding: 20px; color: #999;">暂无商品信息</div>';
                container.innerHTML = html;
                updateSummary();
                return;
            }

            orderItems.forEach(function(item) {
                var productName = item.productName || item.product_name;
                if (!productName || productName === 'false' || productName === "false") {
                    productName = '未知商品';
                }

                var price = parseFloat(item.productPrice || item.product_price);
                if (isNaN(price) || price === null || price === undefined) {
                    price = 0;
                }

                var productImage = item.productImage || item.product_image || '';
                var productId = item.productId || item.product_id || 0;
                var primaryImgUrl;
                if (productImage && productImage.startsWith('http')) {
                    primaryImgUrl = productImage;
                } else {
                    var tsMatch = productImage.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
                    if (tsMatch) {
                        primaryImgUrl = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
                    } else if (productId && productId > 0) {
                        primaryImgUrl = ctx + '/images/products/' + productId + '.jpg';
                    } else if (productImage && productImage.length > 0) {
                        primaryImgUrl = ctx + '/images/products/' + productImage;
                    } else {
                        primaryImgUrl = ctx + '/images/products/default-product.jpg';
                    }
                }
                var imageHtml = '<div style="width:80px;height:80px;border-radius:5px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">' +
                    '<img src="' + primaryImgUrl + '" alt="" style="width:100%;height:100%;object-fit:cover;" onerror="handleConfirmImgError(this)">' +
                    '<span style="display:none;font-size:30px;color:#ccc;">📦</span>' +
                    '</div>';

                var quantity = parseInt(item.quantity) || 1;
                var subtotal = price * quantity;
                totalAmount += subtotal;

                html += '<div class="order-item" style="padding: 15px;">' +
                    imageHtml +
                    '<div class="item-details">' +
                        '<div class="item-name">' + productName + '</div>' +
                        '<div class="item-price">¥' + price.toFixed(2) + '</div>' +
                        '<div class="item-quantity">x ' + quantity + '</div>' +
                    '</div>' +
                    '</div>';
            });

            container.innerHTML = html;
            updateSummary();
        }

        function updateSummary() {
            const actualAmount = totalAmount + SHIPPING_FEE;
            document.getElementById('totalAmount').textContent = '¥' + totalAmount.toFixed(2);
            document.getElementById('shippingFee').textContent = '¥' + SHIPPING_FEE.toFixed(2);
            document.getElementById('actualAmount').textContent = '¥' + actualAmount.toFixed(2);
        }

        const regionData = {
            "北京市": {"北京市": ["东城区", "西城区", "朝阳区", "海淀区", "丰台区", "石景山区"]},
            "上海市": {"上海市": ["黄浦区", "徐汇区", "长宁区", "静安区", "普陀区", "虹口区", "杨浦区"]},
            "天津市": {"天津市": ["和平区", "河东区", "河西区", "南开区", "河北区", "红桥区"]},
            "重庆市": {"重庆市": ["渝中区", "大渡口区", "江北区", "沙坪坝区", "九龙坡区", "南岸区"]},
            "广东省": {
                "广州市": ["荔湾区", "越秀区", "海珠区", "天河区", "白云区", "黄埔区"],
                "深圳市": ["罗湖区", "福田区", "南山区", "宝安区", "龙岗区", "盐田区"],
                "佛山市": ["禅城区", "南海区", "顺德区"]
            },
            "浙江省": {
                "杭州市": ["上城区", "下城区", "江干区", "拱墅区", "西湖区", "滨江区"],
                "宁波市": ["海曙区", "江北区", "北仑区", "镇海区", "鄞州区"]
            },
            "江苏省": {
                "南京市": ["玄武区", "秦淮区", "建邺区", "鼓楼区", "浦口区", "栖霞区"],
                "苏州市": ["姑苏区", "虎丘区", "吴中区", "相城区", "吴江区"]
            },
            "山东省": {
                "济南市": ["历下区", "市中区", "槐荫区", "天桥区", "历城区"],
                "青岛市": ["市南区", "市北区", "黄岛区", "崂山区", "李沧区"]
            },
            "河南省": {
                "郑州市": ["中原区", "二七区", "管城回族区", "金水区", "上街区"],
                "洛阳市": ["老城区", "西工区", "瀍河回族区", "涧西区", "洛龙区"]
            },
            "四川省": {
                "成都市": ["锦江区", "青羊区", "金牛区", "武侯区", "成华区", "龙泉驿区"]
            },
            "湖北省": {
                "武汉市": ["江岸区", "江汉区", "硚口区", "汉阳区", "武昌区", "青山区"]
            },
            "湖南省": {
                "长沙市": ["芙蓉区", "天心区", "岳麓区", "开福区", "雨花区", "望城区"]
            },
            "福建省": {
                "福州市": ["鼓楼区", "台江区", "仓山区", "马尾区", "晋安区"],
                "厦门市": ["思明区", "海沧区", "湖里区", "集美区", "同安区"]
            },
            "陕西省": {
                "西安市": ["新城区", "碑林区", "莲湖区", "灞桥区", "未央区", "雁塔区"]
            },
            "辽宁省": {
                "沈阳市": ["和平区", "沈河区", "大东区", "皇姑区", "铁西区"],
                "大连市": ["中山区", "西岗区", "沙河口区", "甘井子区"]
            },
            "吉林省": {
                "长春市": ["南关区", "宽城区", "朝阳区", "二道区", "绿园区"]
            },
            "黑龙江省": {
                "哈尔滨市": ["道里区", "南岗区", "道外区", "平房区", "松北区"]
            },
            "河北省": {
                "石家庄市": ["长安区", "桥西区", "新华区", "裕华区", "井陉矿区"]
            },
            "山西省": {
                "太原市": ["小店区", "迎泽区", "杏花岭区", "尖草坪区", "万柏林区"]
            },
            "安徽省": {
                "合肥市": ["瑶海区", "庐阳区", "蜀山区", "包河区", "长丰县"]
            },
            "江西省": {
                "南昌市": ["东湖区", "西湖区", "青云谱区", "湾里区", "青山湖区"]
            },
            "云南省": {
                "昆明市": ["五华区", "盘龙区", "官渡区", "西山区", "东川区"]
            },
            "贵州省": {
                "贵阳市": ["南明区", "云岩区", "花溪区", "乌当区", "白云区"]
            },
            "广西壮族自治区": {
                "南宁市": ["兴宁区", "青秀区", "江南区", "西乡塘区", "良庆区"]
            },
            "海南省": {
                "海口市": ["秀英区", "龙华区", "琼山区", "美兰区"]
            },
            "甘肃省": {
                "兰州市": ["城关区", "七里河区", "西固区", "安宁区", "红古区"]
            },
            "青海省": {
                "西宁市": ["城东区", "城中区", "城西区", "城北区"]
            },
            "台湾省": {"台北市": ["中正区", "大同区", "中山区", "松山区", "大安区"]},
            "内蒙古自治区": {"呼和浩特市": ["新城区", "回民区", "玉泉区", "赛罕区"]},
            "西藏自治区": {"拉萨市": ["城关区", "堆龙德庆区", "达孜区"]},
            "宁夏回族自治区": {"银川市": ["兴庆区", "西夏区", "金凤区", "永宁县"]},
            "新疆维吾尔自治区": {"乌鲁木齐市": ["天山区", "沙依巴克区", "新市区", "水磨沟区"]},
            "香港特别行政区": {"香港": ["中西区", "湾仔区", "东区", "南区", "油尖旺区"]},
            "澳门特别行政区": {"澳门": ["花地玛堂区", "圣安多尼堂区", "大堂区", "望德堂区"]}
        };

        function initProvinceSelect() {
            const provinceSelect = document.getElementById('addrProvince');
            provinceSelect.innerHTML = '<option value="">请选择省份</option>';
            Object.keys(regionData).forEach(province => {
                const option = document.createElement('option');
                option.value = province;
                option.textContent = province;
                provinceSelect.appendChild(option);
            });
        }

        function loadCities() {
            const province = document.getElementById('addrProvince').value;
            const citySelect = document.getElementById('addrCity');
            const districtSelect = document.getElementById('addrDistrict');
            citySelect.innerHTML = '<option value="">请选择城市</option>';
            districtSelect.innerHTML = '<option value="">请选择区县</option>';
            if (province && regionData[province]) {
                Object.keys(regionData[province]).forEach(city => {
                    const option = document.createElement('option');
                    option.value = city;
                    option.textContent = city;
                    citySelect.appendChild(option);
                });
            }
        }

        function loadDistricts() {
            const province = document.getElementById('addrProvince').value;
            const city = document.getElementById('addrCity').value;
            const districtSelect = document.getElementById('addrDistrict');
            districtSelect.innerHTML = '<option value="">请选择区县</option>';
            if (province && city && regionData[province] && regionData[province][city]) {
                regionData[province][city].forEach(district => {
                    const option = document.createElement('option');
                    option.value = district;
                    option.textContent = district;
                    districtSelect.appendChild(option);
                });
            }
        }

        function openAddressModal() {
            document.getElementById('addressForm').reset();
            document.getElementById('editAddressId').value = '';
            document.getElementById('addressModalTitle').textContent = '添加收货地址';
            initProvinceSelect();
            document.getElementById('addrCity').innerHTML = '<option value="">请选择城市</option>';
            document.getElementById('addrDistrict').innerHTML = '<option value="">请选择区县</option>';
            document.getElementById('addressModal').classList.add('show');
            document.getElementById('addressModal').style.display = 'flex';
        }

        function closeAddressModal() {
            document.getElementById('addressModal').classList.remove('show');
            document.getElementById('addressModal').style.display = 'none';
        }

        function viewAddressDetail(addressId) {
            var addr = addresses.find(function(a) { return a.id === addressId; });
            if (!addr) return;
            document.getElementById('addressForm').reset();
            document.getElementById('editAddressId').value = addr.id;
            document.getElementById('addressModalTitle').textContent = '编辑地址';
            initProvinceSelect();
            document.getElementById('addrReceiverName').value = addr.receiverName || '';
            document.getElementById('addrPhone').value = addr.phone || '';
            document.getElementById('addrProvince').value = addr.province || '';
            if (addr.province && regionData[addr.province]) {
                // Populate cities
                const citySelect = document.getElementById('addrCity');
                citySelect.innerHTML = '<option value="">请选择城市</option>';
                Object.keys(regionData[addr.province]).forEach(city => {
                    const option = document.createElement('option');
                    option.value = city;
                    option.textContent = city;
                    citySelect.appendChild(option);
                });
                document.getElementById('addrCity').value = addr.city || '';
            }
            if (addr.province && addr.city && regionData[addr.province] && regionData[addr.province][addr.city]) {
                const districtSelect = document.getElementById('addrDistrict');
                districtSelect.innerHTML = '<option value="">请选择区县</option>';
                regionData[addr.province][addr.city].forEach(district => {
                    const option = document.createElement('option');
                    option.value = district;
                    option.textContent = district;
                    districtSelect.appendChild(option);
                });
                document.getElementById('addrDistrict').value = addr.district || '';
            }
            document.getElementById('addrDetail').value = addr.detail || '';
            document.getElementById('addrPostalCode').value = addr.postalCode || '';
            document.getElementById('addrIsDefault').checked = (addr.isDefault === 1 || addr.isDefault === true);
            document.getElementById('addressModal').classList.add('show');
            document.getElementById('addressModal').style.display = 'flex';
        }

        async function saveAddress() {
            const receiverName = document.getElementById('addrReceiverName').value.trim();
            const phone = document.getElementById('addrPhone').value.trim();
            const province = document.getElementById('addrProvince').value;
            const city = document.getElementById('addrCity').value;
            const district = document.getElementById('addrDistrict').value;
            const detail = document.getElementById('addrDetail').value.trim();
            const postalCode = document.getElementById('addrPostalCode').value.trim();
            if (!receiverName || !phone || !province || !city || !district || !detail) {
                alert('请填写完整的地址信息');
                return;
            }
            const formData = new URLSearchParams();
            formData.append('receiverName', receiverName);
            formData.append('phone', phone);
            formData.append('province', province);
            formData.append('city', city);
            formData.append('district', district);
            formData.append('detail', detail);
            formData.append('postalCode', postalCode);

            const editId = document.getElementById('editAddressId').value;
            let url, successMsg;
            if (editId) {
                formData.append('addressId', editId);
                url = ctx + '/api/address/update';
                successMsg = '修改地址成功！';
            } else {
                if (document.getElementById('addrIsDefault').checked) {
                    formData.append('isDefault', '1');
                }
                url = ctx + '/api/address/add';
                successMsg = '添加地址成功！';
            }

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    alert(successMsg);
                    closeAddressModal();
                    loadAddresses();
                } else {
                    alert(result.message || '操作失败');
                }
            } catch (error) {
                console.error('操作失败:', error);
                alert('操作失败，请重试');
            }
        }

        async function deleteAddress(addressId) {
            if (!confirm('确定要删除这个地址吗？')) return;
            try {
                const formData = new URLSearchParams();
                formData.append('addressId', addressId);
                const response = await fetch(ctx + '/api/address/delete', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    alert('删除成功！');
                    loadAddresses();
                } else {
                    alert(result.message || '删除失败');
                }
            } catch (error) {
                console.error('删除地址失败:', error);
                alert('删除失败，请重试');
            }
        }

        async function submitOrder() {
            if (!isLoggedIn()) {
                redirectToLogin();
                return;
            }

            if (!selectedAddressId) {
                alert('请选择收货地址');
                return;
            }

            if (orderItems.length === 0) {
                alert('没有要购买的商品');
                return;
            }

            const selectedAddress = addresses.find(a => a.id === selectedAddressId);
            const paymentMethod = parseInt(document.getElementById('paymentMethod').value);
            const remark = document.getElementById('remark').value;

            try {
                const orderData = {
                    addressId: selectedAddressId,
                    receiverName: selectedAddress.receiverName,
                    receiverPhone: selectedAddress.phone,
                    receiverProvince: selectedAddress.province,
                    receiverCity: selectedAddress.city,
                    receiverDistrict: selectedAddress.district,
                    receiverAddress: selectedAddress.detail,
                    paymentMethod: paymentMethod,
                    remark: remark,
                    items: orderItems.map(item => ({
                        productId: item.productId,
                        quantity: item.quantity
                    }))
                };

                const response = await fetch(ctx + '/api/order/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(orderData)
                });

                const result = await response.json();

                if (result.code === 200) {
                    const cartIds = orderItems.filter(item => item.id).map(item => item.id);
                    if (cartIds.length > 0) {
                        for (const cartId of cartIds) {
                            try {
                                await fetch(ctx + '/api/cart/delete', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded'
                                    },
                                    body: 'id=' + cartId
                                });
                            } catch (e) {
                                console.error('删除购物车项失败:', e);
                            }
                        }
                    }

                    // 跳转到支付页面（支付第一个订单）
                    const firstOrder = result.data[0];
                    window.location.href = ctx + '/pages/pay.jsp?orderId=' + firstOrder.id + '&paymentMethod=' + paymentMethod;
                } else {
                    alert(result.message || '创建订单失败');
                }
            } catch (error) {
                console.error('创建订单失败:', error);
                alert('创建订单失败，请重试');
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