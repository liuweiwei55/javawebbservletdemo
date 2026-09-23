<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 购物系统</title>
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

        .user-profile {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        .profile-sidebar {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: white;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            background-size: cover;
            background-position: center;
            transition: opacity 0.3s;
        }

        .avatar:hover {
            opacity: 0.8;
        }

        .username {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .user-role {
            color: #666;
            font-size: 14px;
        }

        .menu-list {
            margin-top: 30px;
        }

        .menu-item {
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .menu-item:hover {
            background: #f5f5f5;
        }

        .menu-item.active {
            background: #667eea;
            color: white;
        }

        .profile-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 24px;
            margin-bottom: 30px;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }

        .info-form {
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
            font-weight: 600;
        }

        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .form-input:disabled {
            background: #f5f5f5;
            cursor: not-allowed;
        }

        .save-btn {
            padding: 12px 40px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .save-btn:hover {
            background: #764ba2;
        }

        .form-buttons {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .home-btn {
            background: #764ba2;
        }

        .home-btn:hover {
            background: #5a3d8a;
        }

        .password-form {
            max-width: 600px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            border-radius: 10px;
            text-align: center;
            color: white;
            position: relative;
        }

        .stat-value {
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .stat-label {
            font-size: 16px;
            opacity: 0.9;
            position: absolute;
            bottom: 30px;
            left: 0;
            right: 0;
            text-align: center;
        }

        .hidden {
            display: none;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .address-card {
            background: #f8f8f8;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
        }

        .address-card:hover {
            background: #f0f0f0;
        }

        .address-card.default {
            border-left-color: #f5576c;
            background: #fff5f5;
        }

        .address-card.default:hover {
            background: #ffebeb;
        }

        .address-info {
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .address-detail {
            color: #666;
            margin-bottom: 10px;
            line-height: 1.6;
        }

        .address-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-small {
            padding: 6px 16px;
            font-size: 13px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-small.btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-small.btn-danger {
            background: #ff4d4f;
            color: white;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
        }

        .modal-close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 28px;
            cursor: pointer;
            color: #999;
            line-height: 1;
        }

        .modal-close:hover {
            color: #333;
        }

        .form-row {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
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
                        <c:redirect url="/pages/login.jsp"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="user-profile">
            <div class="profile-sidebar">
                <div class="avatar" id="avatarDisplay" onclick="document.getElementById('avatarInput').click()">
                    <span id="avatarText" style="pointer-events: none;">👤</span>
                </div>
                <input type="file" id="avatarInput" accept="image/jpeg,image/png,image/gif" style="display: none;">
                <div class="username" id="sidebarUsername"></div>
                <div class="user-role">普通用户</div>

                <div class="menu-list">
                    <div class="menu-item active" onclick="showSection('info')">
                        <span>📋</span> 个人信息
                    </div>
                    <div class="menu-item" onclick="showSection('password')">
                        <span>🔒</span> 修改密码
                    </div>
                    <div class="menu-item" onclick="showSection('address')">
                        <span>📍</span> 收货地址
                    </div>
                </div>
            </div>

            <div class="profile-content">
                <div id="infoSection">
                    <h2 class="section-title">个人信息</h2>
                    <div class="stats-grid">
                        <div class="stat-card" onclick="goToOrders()" style="cursor: pointer;">
                            <div class="stat-value" id="orderCount">0</div>
                            <div class="stat-label">订单数</div>
                        </div>
                        <div class="stat-card" onclick="goToCart()" style="cursor: pointer;">
                            <div class="stat-value" id="cartCount">0</div>
                            <div class="stat-label">购物车</div>
                        </div>
                        <div class="stat-card" onclick="showAddressSection()" style="cursor: pointer;">
                            <div class="stat-value" id="addressCount" style="font-size: 14px; word-break: break-all; line-height: 1.4;">未填写</div>
                            <div class="stat-label">收货地址</div>
                        </div>
                    </div>

                    <form class="info-form" id="infoForm">
                        <div class="form-group">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-input" id="username" name="username">
                        </div>
                        <div class="form-group">
                            <label class="form-label">真实姓名</label>
                            <input type="text" class="form-input" id="realName" name="realName">
                        </div>
                        <div class="form-group">
                            <label class="form-label">手机号</label>
                            <input type="tel" class="form-input" id="phone" name="phone">
                        </div>
                        <div class="form-group">
                            <label class="form-label">邮箱</label>
                            <input type="email" class="form-input" id="email" name="email">
                        </div>
                        <div class="form-buttons">
                            <button type="submit" class="save-btn">保存修改</button>
                            <button type="button" class="save-btn home-btn" onclick="window.location.href=ctx + '/index.jsp'">返回首页</button>
                        </div>
                    </form>
                </div>

                <div id="passwordSection" class="hidden">
                    <h2 class="section-title">修改密码</h2>
                    <form class="password-form" id="passwordForm">
                        <div class="form-group">
                            <label class="form-label">当前密码</label>
                            <input type="password" class="form-input" name="oldPassword" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">新密码</label>
                            <input type="password" class="form-input" name="newPassword" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">确认新密码</label>
                            <input type="password" class="form-input" name="confirmPassword" required>
                        </div>
                        <div style="text-align: center;">
                            <button type="submit" class="save-btn">确认修改</button>
                        </div>
                    </form>
                </div>

                <div id="addressSection" class="hidden">
                    <div class="address-header">
                        <h2 class="section-title" style="margin-bottom:0;border:none;padding-bottom:0;">收货地址</h2>
                        <button class="save-btn" onclick="openAddressModal()">+ 添加地址</button>
                    </div>
                    <div id="addressListContent" style="margin-top: 20px;">
                        <p style="text-align: center; padding: 40px; color: #999;">加载中...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="addressModal" class="modal-overlay" style="display:none;">
        <div class="modal-content">
            <span class="modal-close" onclick="closeAddressModal()">&times;</span>
            <h3 class="section-title" id="addressModalTitle" style="margin-bottom:20px;">添加收货地址</h3>
            <form id="addressForm" onsubmit="return false;">
                <input type="hidden" id="editAddressId">
                <div class="form-group">
                    <label class="form-label">收货人</label>
                    <input type="text" class="form-input" id="addrReceiverName" required>
                </div>
                <div class="form-group">
                    <label class="form-label">手机号码</label>
                    <input type="tel" class="form-input" id="addrPhone" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">省份</label>
                        <select class="form-input" id="addrProvince" onchange="loadCities()">
                            <option value="">请选择省份</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">城市</label>
                        <select class="form-input" id="addrCity" onchange="loadDistricts()">
                            <option value="">请选择城市</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">区县</label>
                    <select class="form-input" id="addrDistrict">
                        <option value="">请选择区县</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">详细地址</label>
                    <textarea class="form-input" id="addrDetail" rows="3" placeholder="请输入街道、门牌号、小区单元等" style="resize:none;"></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">邮政编码</label>
                    <input type="text" class="form-input" id="addrPostalCode">
                </div>
                <div class="form-buttons">
                    <button type="button" class="save-btn" id="addressSubmitBtn" onclick="saveAddress()">保存</button>
                    <button type="button" class="save-btn home-btn" onclick="closeAddressModal()">取消</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const ctx = '${ctx}';

        function goToOrders() {
            window.location.href = ctx + '/pages/order-list.jsp';
        }

        function goToCart() {
            window.location.href = ctx + '/pages/cart.jsp';
        }

        async function loadUserInfo() {
            try {
                const response = await fetch(ctx + '/api/user/info');
                const result = await response.json();

                if (result.code === 200 && result.data) {
                    const user = result.data;
                    document.getElementById('sidebarUsername').textContent = user.username;
                    document.getElementById('username').value = user.username;
                    document.getElementById('realName').value = user.realName || '';
                    document.getElementById('phone').value = user.phone || '';
                    document.getElementById('email').value = user.email || '';
                    updateAvatarDisplay(user.avatar);

                    await loadStats();
                } else if (result.code === 401) {
                    window.location.href = ctx + '/pages/login.jsp';
                }
            } catch (error) {
                console.error('加载用户信息失败:', error);
            }
        }

        async function loadStats() {
            try {
                const [orderResponse, cartResponse, addressResponse] = await Promise.all([
                    fetch(ctx + '/api/order/list'),
                    fetch(ctx + '/api/cart/list'),
                    fetch(ctx + '/api/address/list')
                ]);

                const orderResult = await orderResponse.json();
                const cartResult = await cartResponse.json();
                const addressResult = await addressResponse.json();

                const orderCount = (orderResult.code === 200 && orderResult.data) ? orderResult.data.length : 0;
                const cartCount = (cartResult.code === 200 && cartResult.data) ? cartResult.data.length : 0;

                document.getElementById('orderCount').textContent = orderCount;
                document.getElementById('cartCount').textContent = cartCount;

                if (addressResult.code === 200 && addressResult.data && addressResult.data.length > 0) {
                    const defaultAddr = addressResult.data.find(function(a) { return a.isDefault === 1; });
                    var addr = defaultAddr || addressResult.data[0];
                    var addrText = addr.receiverName + ' ' + (addr.province || '') + (addr.city || '') + (addr.district || '') + (addr.detail || '');
                    document.getElementById('addressCount').textContent = addrText || '未填写';
                } else {
                    document.getElementById('addressCount').textContent = '未填写';
                }
            } catch (error) {
                console.error('加载统计信息失败:', error);
            }
        }

        function showSection(section) {
            document.querySelectorAll('.menu-item').forEach(item => {
                item.classList.remove('active');
            });

            if (typeof event !== 'undefined' && event && event.target) {
                event.target.closest('.menu-item').classList.add('active');
            } else {
                const menuItems = document.querySelectorAll('.menu-item');
                if (section === 'info') menuItems[0].classList.add('active');
                else if (section === 'password') menuItems[1].classList.add('active');
                else if (section === 'address') menuItems[2].classList.add('active');
            }

            document.getElementById('infoSection').classList.add('hidden');
            document.getElementById('passwordSection').classList.add('hidden');
            document.getElementById('addressSection').classList.add('hidden');

            document.getElementById(section + 'Section').classList.remove('hidden');

            if (section === 'address') {
                loadAddressList();
            }
        }

        function showAddressSection() {
            document.querySelectorAll('.menu-item').forEach(item => {
                item.classList.remove('active');
            });
            document.querySelectorAll('.menu-item')[2].classList.add('active');

            document.getElementById('infoSection').classList.add('hidden');
            document.getElementById('passwordSection').classList.add('hidden');
            document.getElementById('addressSection').classList.remove('hidden');

            loadAddressList();
        }

        async function loadAddressList() {
            const container = document.getElementById('addressListContent');
            try {
                const response = await fetch(ctx + '/api/address/list');
                const result = await response.json();

                if (result.code === 200 && result.data && result.data.length > 0) {
                    let html = '<div style="display: flex; flex-direction: column; gap: 15px;">';
                    result.data.forEach(function(addr) {
                        const isDefault = addr.isDefault === 1;
                        const defaultTag = isDefault ? '<span style="background:#667eea;color:white;padding:2px 8px;border-radius:4px;font-size:12px;margin-left:10px;">默认</span>' : '';
                        const borderColor = isDefault ? '#667eea' : '#ddd';

                        html +=
                            '<div style="background: #f8f8f8; padding: 20px; border-radius: 8px; border-left: 4px solid ' + borderColor + '; cursor: pointer; transition: all 0.3s;" onclick="setDefaultAddress(' + addr.id + ')" onmouseover="this.style.background=\'#f0f0f0\'" onmouseout="this.style.background=\'#f8f8f8\'">' +
                                '<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">' +
                                    '<div style="font-weight: 600;">' + addr.receiverName + '  ' + addr.phone + defaultTag + '</div>' +
                                    '<div style="display: flex; gap: 8px;">' +
                                        '<button type="button" style="background:#667eea;color:white;border:none;padding:5px 15px;border-radius:4px;cursor:pointer;font-size:14px;" onclick="event.stopPropagation(); viewAddressDetail(' + addr.id + ')">查看详情</button>' +
                                        '<button type="button" style="background:#ff4d4f;color:white;border:none;padding:5px 15px;border-radius:4px;cursor:pointer;font-size:14px;" onclick="event.stopPropagation(); deleteAddress(' + addr.id + ', event)">删除</button>' +
                                    '</div>' +
                                '</div>' +
                                '<div style="color: #666;">' + (addr.province || '') + (addr.city || '') + (addr.district || '') + (addr.detail || '') + '</div>' +
                            '</div>';
                    });
                    html += '</div>';
                    container.innerHTML = html;
                } else {
                    container.innerHTML = '<p style="text-align: center; padding: 40px; color: #999;">暂无收货地址</p>';
                }
            } catch (error) {
                console.error('加载地址失败:', error);
                container.innerHTML = '<p style="text-align: center; padding: 40px; color: #999;">加载失败</p>';
            }
        }

        document.getElementById('infoForm').onsubmit = async function(e) {
            e.preventDefault();

            const formData = new URLSearchParams();
            formData.append('username', document.getElementById('username').value);
            formData.append('realName', document.getElementById('realName').value);
            formData.append('phone', document.getElementById('phone').value);
            formData.append('email', document.getElementById('email').value);

            try {
                const response = await fetch(ctx + '/api/user/update', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('保存成功！');
                    document.getElementById('sidebarUsername').textContent = document.getElementById('username').value;
                } else {
                    alert(result.message || '保存失败');
                }
            } catch (error) {
                console.error('保存失败:', error);
                alert('保存失败，请重试');
            }
        };

        document.getElementById('passwordForm').onsubmit = async function(e) {
            e.preventDefault();

            const oldPassword = document.querySelector('input[name="oldPassword"]').value;
            const newPassword = document.querySelector('input[name="newPassword"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;

            if (newPassword !== confirmPassword) {
                alert('两次输入的新密码不一致');
                return;
            }

            const formData = new URLSearchParams();
            formData.append('oldPassword', oldPassword);
            formData.append('newPassword', newPassword);

            try {
                const response = await fetch(ctx + '/api/user/password', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.code === 200) {
                    alert('密码修改成功！');
                    document.getElementById('passwordForm').reset();
                    showSection('info');
                } else {
                    alert(result.message || '修改失败');
                }
            } catch (error) {
                console.error('修改密码失败:', error);
                alert('修改失败，请重试');
            }
        };

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

        window.onload = loadUserInfo;

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
            document.getElementById('addressSubmitBtn').textContent = '保存';
            initProvinceSelect();
            document.getElementById('addrCity').innerHTML = '<option value="">请选择城市</option>';
            document.getElementById('addrDistrict').innerHTML = '<option value="">请选择区县</option>';
            document.getElementById('addressModal').style.display = 'flex';
        }

        function closeAddressModal() {
            document.getElementById('addressModal').style.display = 'none';
        }

        function viewAddressDetail(addressId) {
            fetch(ctx + '/api/address/list')
                .then(function(response) { return response.json(); })
                .then(function(result) {
                    if (result.code === 200 && result.data) {
                        var addr = result.data.find(function(a) { return a.id === addressId; });
                        if (addr) {
                            document.getElementById('addressForm').reset();
                            document.getElementById('editAddressId').value = addr.id;
                            document.getElementById('addressModalTitle').textContent = '地址详情';
                            document.getElementById('addressSubmitBtn').textContent = '确认修改';
                            initProvinceSelect();
                            document.getElementById('addrReceiverName').value = addr.receiverName || '';
                            document.getElementById('addrPhone').value = addr.phone || '';
                            document.getElementById('addrProvince').value = addr.province || '';
                            loadCities();
                            document.getElementById('addrCity').value = addr.city || '';
                            loadDistricts();
                            document.getElementById('addrDistrict').value = addr.district || '';
                            document.getElementById('addrDetail').value = addr.detail || '';
                            document.getElementById('addrPostalCode').value = addr.postalCode || '';
                            document.getElementById('addressModal').style.display = 'flex';
                        }
                    }
                })
                .catch(function(error) {
                    console.error('获取地址详情失败:', error);
                    alert('获取地址详情失败');
                });
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
                formData.append('isDefault', 0);
                url = ctx + '/api/address/add';
                successMsg = '添加地址成功！';
            }

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    alert(successMsg);
                    closeAddressModal();
                    loadAddressList();
                    loadStats();
                } else {
                    alert(result.message || '操作失败');
                }
            } catch (error) {
                console.error('操作失败:', error);
                alert('操作失败，请重试');
            }
        }

        async function deleteAddress(addressId, event) {
            event.stopPropagation();
            if (!confirm('确定要删除这个地址吗？')) return;
            try {
                const formData = new URLSearchParams();
                formData.append('addressId', addressId);
                const response = await fetch(ctx + '/api/address/delete', {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    alert('删除成功！');
                    loadAddressList();
                    loadStats();
                } else {
                    alert(result.message || '删除失败');
                }
            } catch (error) {
                console.error('删除地址失败:', error);
                alert('删除失败，请重试');
            }
        }

        async function setDefaultAddress(addressId) {
            try {
                const formData = new URLSearchParams();
                formData.append('addressId', addressId);
                const response = await fetch(ctx + '/api/address/default', {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                if (result.code === 200) {
                    loadAddressList();
                    loadStats();
                } else {
                    alert(result.message || '设置默认地址失败');
                }
            } catch (error) {
                console.error('设置默认地址失败:', error);
                alert('设置默认地址失败，请重试');
            }
        }

        function updateAvatarDisplay(avatar) {
            const display = document.getElementById('avatarDisplay');
            const text = document.getElementById('avatarText');
            if (avatar) {
                text.style.display = 'none';
                display.style.backgroundImage = 'url(' + avatar + ')';
            } else {
                text.style.display = 'block';
                display.style.backgroundImage = '';
            }
        }

        document.getElementById('avatarInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) return;

            if (!file.type.match(/image\/(jpeg|png|gif)/)) {
                alert('请选择 JPG、PNG 或 GIF 格式的图片');
                return;
            }

            if (file.size > 2 * 1024 * 1024) {
                alert('图片大小不能超过 2MB');
                return;
            }

            compressImage(file, 200, 200, 0.7).then(function(base64) {
                uploadAvatar(base64);
            }).catch(function(err) {
                alert('图片处理失败: ' + err);
            });
        });

        function compressImage(file, maxWidth, maxHeight, quality) {
            return new Promise(function(resolve, reject) {
                const img = new Image();
                const reader = new FileReader();
                reader.onload = function(e) {
                    img.src = e.target.result;
                    img.onload = function() {
                        let w = img.width, h = img.height;
                        if (w > h) {
                            if (w > maxWidth) { h = Math.round(h * maxWidth / w); w = maxWidth; }
                        } else {
                            if (h > maxHeight) { w = Math.round(w * maxHeight / h); h = maxHeight; }
                        }
                        const canvas = document.createElement('canvas');
                        canvas.width = w;
                        canvas.height = h;
                        const ctx2d = canvas.getContext('2d');
                        ctx2d.drawImage(img, 0, 0, w, h);
                        resolve(canvas.toDataURL('image/jpeg', quality));
                    };
                    img.onerror = reject;
                };
                reader.onerror = reject;
                reader.readAsDataURL(file);
            });
        }

        async function uploadAvatar(base64) {
            try {
                const formData = new URLSearchParams();
                formData.append('avatar', base64);

                const response = await fetch(ctx + '/api/user/info', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                if (result.code === 200) {
                    updateAvatarDisplay(base64);
                    alert('头像上传成功！');
                } else {
                    alert(result.message || '上传失败');
                }
            } catch (error) {
                console.error('上传头像失败:', error);
                alert('上传失败，请重试');
            }
        }
    </script>
</body>
</html>
