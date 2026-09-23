<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:if test="${sessionScope.role != 1}">
    <c:redirect url="/pages/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理后台 - 购物系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', 'Segoe UI', sans-serif; background: #f0f2f5; min-height: 100vh; display: flex; font-size: 14px; }
        
        .sidebar {
            width: 230px; min-height: 100vh; background: linear-gradient(180deg, #0f0c29 0%, #1a1a3e 50%, #24243e 100%);
            color: #fff; padding: 24px 0; position: fixed; top: 0; left: 0; bottom: 0; overflow-y: auto; z-index: 100;
            box-shadow: 2px 0 20px rgba(0,0,0,0.15);
        }
        .sidebar .logo {
            font-size: 22px; font-weight: bold; padding: 0 20px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.08); margin-bottom: 12px; text-align: center;
            letter-spacing: 1px;
        }
        .sidebar .nav-item {
            display: block; padding: 13px 20px; color: rgba(255,255,255,0.6); cursor: pointer; transition: all 0.3s;
            font-size: 15px; border-left: 3px solid transparent; text-decoration: none; text-align: center;
            margin: 2px 8px; border-radius: 8px;
        }
        .sidebar .nav-item:hover, .sidebar .nav-item.active {
            color: #fff; background: rgba(79,172,254,0.15); border-left-color: #4facfe;
        }
        .sidebar .nav-item .icon { margin-right: 8px; }
        .sidebar .nav-section { font-size: 11px; color: rgba(255,255,255,0.3); padding: 16px 20px 6px; text-transform: uppercase; letter-spacing: 2px; text-align: center; font-weight: 600; }

        .main { margin-left: 230px; flex: 1; padding: 24px; }
        .header {
            background: #fff; padding: 18px 28px; border-radius: 14px; display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        }
        .header .welcome { font-size: 20px; color: #666; }
        .header .welcome strong { color: #4facfe; }
        .header .welcome .last-login { display: block; margin-top: 8px; color: #999; font-size: 14px; }
        .header .user-info { display: flex; align-items: center; gap: 12px; }
        .header .avatar { width: 40px; height: 40px; border-radius: 50%; background: #e8f4ff; display: flex; align-items: center; justify-content: center; font-size: 20px; cursor: pointer; overflow: hidden; transition: box-shadow 0.2s; }
        .header .avatar:hover { box-shadow: 0 0 0 3px rgba(79,172,254,0.2); }
        .header .avatar img { width: 100%; height: 100%; object-fit: cover; }
        .header .logout-btn { background: #ff4d4f; color: #fff; border: none; padding: 8px 18px; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.2s; }
        .header .logout-btn:hover { background: #e04345; box-shadow: 0 4px 12px rgba(255,77,79,0.3); }

        .tab-content { display: none; }
        .tab-content.active { display: block; }

        .card {
            background: #fff; border-radius: 14px; padding: 28px; margin-bottom: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04); transition: box-shadow 0.3s;
        }
        .card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.06); }
        .card h3 { font-size: 18px; margin-bottom: 20px; color: #333; padding-bottom: 14px; border-bottom: 1px solid #f0f0f0; font-weight: 600; }
        
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 2px 10px rgba(0,0,0,0.04); transition: all 0.3s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .clickable { cursor: pointer; }
        .stat-card .stat-value { font-size: 32px; font-weight: bold; color: #333; }
        .stat-card .stat-label { font-size: 14px; color: #999; margin-top: 6px; font-weight: 500; }
        .stat-card.blue { border-left: 4px solid #4facfe; }
        .stat-card.green { border-left: 4px solid #43e97b; }
        .stat-card.orange { border-left: 4px solid #fa709a; }
        .stat-card.purple { border-left: 4px solid #a18cd1; }
        .stat-card.clickable { cursor: pointer; }
        .stat-card.clickable:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.1); }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 15px; vertical-align: middle; }
        th { background: #f8f9fb; font-weight: 600; color: #555; letter-spacing: 0.5px; font-size: 14px; }
        tr { transition: background 0.2s; }
        tr:hover { background: #f5f8ff; }
        tr:last-child td { border-bottom: none; }
        .btn { padding: 8px 18px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; transition: all 0.25s; font-weight: 500; letter-spacing: 0.3px; }
        .btn-primary { background: #4facfe; color: #fff; }
        .btn-primary:hover { background: #3d8fd9; box-shadow: 0 4px 14px rgba(79,172,254,0.35); transform: translateY(-1px); }
        .btn-success { background: #52c41a; color: #fff; }
        .btn-success:hover { box-shadow: 0 4px 14px rgba(82,196,26,0.35); transform: translateY(-1px); }
        .btn-warning { background: #faad14; color: #fff; }
        .btn-warning:hover { box-shadow: 0 4px 14px rgba(250,173,20,0.35); transform: translateY(-1px); }
        .btn-danger { background: #ff4d4f; color: #fff; }
        .btn-danger:hover { box-shadow: 0 4px 14px rgba(255,77,79,0.35); transform: translateY(-1px); }
        .btn-sm { padding: 7px 18px; font-size: 15px; }
        .btn-xs { padding: 6px 14px; font-size: 13px; border-radius: 6px; font-weight: 500; letter-spacing: 0.5px; }
        .btn-lg { padding: 10px 22px; font-size: 15px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; color: #555; margin-bottom: 8px; font-weight: 600; letter-spacing: 0.3px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 11px 14px; border: 2px solid #e8e8e8; border-radius: 10px; font-size: 15px; outline: none;
            transition: border-color 0.25s, box-shadow 0.25s; background: #f8f9fb;
        }
        .form-group input:hover, .form-group select:hover, .form-group textarea:hover {
            border-color: #c0d8f0;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #4facfe;
            box-shadow: 0 0 0 4px rgba(79,172,254,0.1);
            background: #fff;
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.55); z-index: 1000; justify-content: center; align-items: center; backdrop-filter: blur(3px); }
        .modal-overlay.show { display: flex; }
        .modal { background: #fff; border-radius: 16px; padding: 32px; width: 90%; max-width: 720px; max-height: 85vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.2); animation: modalIn 0.3s ease-out; }
        @keyframes modalIn { from { opacity: 0; transform: scale(0.95) translateY(-10px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        .modal h3 { margin-bottom: 24px; font-weight: 700; }
        .modal-actions { display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px; }

        .badge { padding: 5px 14px; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .badge-success { background: #f6ffed; color: #52c41a; }
        .badge-warning { background: #fffbe6; color: #faad14; }
        .badge-danger { background: #fff2f0; color: #ff4d4f; }
        .badge-info { background: #e6f7ff; color: #1890ff; }

        .comment-card:hover { box-shadow: 0 2px 12px rgba(0,0,0,0.08); border-color: #d0d0d0; }

        .tabs { display: flex; gap: 0; border-bottom: 2px solid #f0f0f0; margin-bottom: 20px; }
        .tabs .tab { padding: 12px 22px; cursor: pointer; font-size: 15px; color: #888; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.2s; font-weight: 500; }
        .tabs .tab.active { color: #4facfe; border-bottom-color: #4facfe; font-weight: 600; }
        .tabs .tab:hover { color: #4facfe; }

        .empty-state { text-align: center; padding: 50px; color: #999; font-size: 15px; }
        .pagination { display: flex; gap: 6px; justify-content: center; margin-top: 20px; }
        .pagination button { padding: 7px 14px; border: 2px solid #e8e8e8; background: #fff; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.2s; }
        .pagination button:hover { border-color: #4facfe; color: #4facfe; }
        .pagination button.active { background: #4facfe; color: #fff; border-color: #4facfe; }
        .pagination button:disabled { opacity: 0.4; cursor: not-allowed; }

        .search-bar { display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; align-items: center; }
        .search-bar input, .search-bar select { padding: 10px 14px; border: 2px solid #e8e8e8; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.25s, box-shadow 0.25s; background: #f8f9fb; }
        .search-bar input:focus, .search-bar select:focus { border-color: #4facfe; box-shadow: 0 0 0 3px rgba(79,172,254,0.1); background: #fff; }
        .search-bar input { width: 200px; }
        .search-bar .date-group { display: flex; align-items: center; gap: 6px; }
        .search-bar .date-group label { font-size: 13px; color: #888; white-space: nowrap; margin: 0; font-weight: 500; }
        .search-bar .date-group input { width: 150px; }

        .stock-warning { color: #ff4d4f; font-weight: bold; }
        .stock-normal { color: #52c41a; }

        .log-entry { padding: 8px 0; border-bottom: 1px solid #f5f5f5; font-size: 13px; color: #666; }
        .log-entry .time { color: #999; margin-right: 10px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="logo">🛒 管理后台</div>
        <div class="nav-section">数据概览</div>
        <a class="nav-item active" onclick="switchTab('dashboard')"><span class="icon">📊</span> 控制台</a>
        <div class="nav-section">商品管理</div>
        <a class="nav-item" onclick="switchTab('category')"><span class="icon">📂</span> 分类管理</a>
        <a class="nav-item" onclick="switchTab('product')"><span class="icon">📦</span> 商品管理</a>
        <a class="nav-item" onclick="switchTab('stock')"><span class="icon">🏪</span> 库存管理</a>
        <a class="nav-item" onclick="switchTab('comment')"><span class="icon">💬</span> 评论管理</a>
        <div class="nav-section">用户与订单</div>
        <a class="nav-item" onclick="switchTab('user')"><span class="icon">👥</span> 用户管理</a>
        <a class="nav-item" onclick="switchTab('order')"><span class="icon">📋</span> 订单管理</a>
        <div class="nav-section">数据分析</div>
        <a class="nav-item" onclick="switchTab('stats')"><span class="icon">📈</span> 数据统计</a>
        <div class="nav-section">系统设置</div>
        <a class="nav-item" onclick="switchTab('profile')"><span class="icon">👤</span> 个人资料</a>
        <a class="nav-item" onclick="switchTab('logs')"><span class="icon">📝</span> 日志管理</a>
    </div>

    <div class="main">
        <div class="header">
            <div class="welcome">
                欢迎回来，<strong>${sessionScope.username}</strong> 管理员
                <c:set var="lastLoginDisplay" value="${sessionScope.lastLoginTime}" />
                <c:if test="${empty lastLoginDisplay}">
                    <c:set var="lastLoginDisplay" value="初次登录" />
                </c:if>
                <span class="last-login">上次登录：${lastLoginDisplay}</span>
            </div>
            <div class="user-info">
                <div class="avatar" id="headerAvatar" onclick="switchTab('profile')" title="点击更换头像">
                    <c:set var="sessionAvatar" value="${sessionScope.avatar}" />
                    <c:choose>
                        <c:when test="${not empty sessionAvatar}">
                            <c:choose>
                                <c:when test="${fn:startsWith(sessionAvatar, 'http') or fn:startsWith(sessionAvatar, 'data:')}">
                                    <img src="${sessionAvatar}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="this.onerror=null;this.parentElement.innerHTML='<span>👤</span>';">
                                </c:when>
                                <c:otherwise>
                                    <img src="${ctx}/images/avatars/${sessionAvatar}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="this.onerror=null;this.parentElement.innerHTML='<span>👤</span>';">
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span id="headerAvatarText">👤</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <span style="font-size:16px;font-weight:500;">${sessionScope.username}</span>
                <button class="logout-btn" onclick="logout()">退出</button>
            </div>
        </div>

        <!-- ==================== 控制台 ==================== -->
        <div id="tab-dashboard" class="tab-content active">
            <div class="stats-row" id="dashboardStats"></div>
            <div class="card">
                <h3>📈 最近7天销售趋势</h3>
                <div id="salesChart" style="width:100%;height:280px;padding:10px 0;"></div>
            </div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                <div class="card">
                    <h3>🔥 热销商品 TOP5</h3>
                    <div id="hotProducts"></div>
                </div>
                <div class="card">
                    <h3>⚠️ 库存预警</h3>
                    <div id="stockAlerts"></div>
                </div>
            </div>
        </div>

        <!-- ==================== 分类管理 ==================== -->
        <div id="tab-category" class="tab-content">
            <div class="card">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;">
                    <h3 style="margin:0;padding:0;border:none;font-size:18px;">📂 商品分类管理</h3>
                    <button class="btn btn-primary btn-lg" onclick="showCategoryModal()">+ 新增分类</button>
                </div>
                <table style="font-size:16px;"><thead><tr><th>ID</th><th>分类名称</th><th></th></tr></thead>
                <tbody id="categoryTable"></tbody></table>
            </div>
        </div>

        <!-- ==================== 商品管理 ==================== -->
        <div id="tab-product" class="tab-content">
            <div class="card">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;">
                    <h3 style="margin:0;padding:0;border:none;font-size:18px;">📦 商品信息管理</h3>
                    <div style="display:flex;gap:10px;">
                        <button class="btn btn-warning btn-lg" onclick="batchToggleProduct(1)">批量上架</button>
                        <button class="btn btn-danger btn-lg" onclick="batchToggleProduct(0)">批量下架</button>
                        <button class="btn btn-primary btn-lg" onclick="showProductModal()">+ 新增商品</button>
                    </div>
                </div>
                <div class="search-bar">
                    <input type="text" id="productSearch" placeholder="搜索商品名称..." oninput="loadProducts()">
                    <select id="productCategoryFilter" onchange="loadProducts()"><option value="">全部分类</option></select>
                    <select id="productStatusFilter" onchange="loadProducts()">
                        <option value="">全部状态</option><option value="1">上架</option><option value="0">下架</option>
                    </select>
                </div>
                <table><thead><tr>
                    <th><input type="checkbox" id="selectAllProducts" onchange="toggleSelectAll(this)"></th>
                    <th>ID</th><th>图片</th><th>名称</th><th>分类</th><th>售价</th><th>原价</th><th style="text-align:center;">库存</th><th style="text-align:center;">销量</th><th style="text-align:center;">状态</th><th style="text-align:center;"></th>
                </tr></thead><tbody id="productTable"></tbody></table>
                <div class="pagination" id="productPagination"></div>
            </div>
        </div>

        <!-- ==================== 库存管理 ==================== -->
        <div id="tab-stock" class="tab-content">
            <div class="card">
                <h3 style="font-size:18px;">📦 库存管理</h3>
                <div class="search-bar">
                    <input type="text" id="stockSearch" placeholder="搜索商品..." oninput="loadStock()">
                    <select id="stockAlertFilter" onchange="loadStock()">
                        <option value="">全部</option><option value="warning">库存预警</option><option value="normal">库存正常</option>
                    </select>
                </div>
                <table><thead><tr><th>ID</th><th>商品名称</th><th>当前库存</th><th>预警阈值</th><th>状态</th><th>操作</th></tr></thead>
                <tbody id="stockTable"></tbody></table>
            </div>
            <div class="card">
                <h3 style="font-size:18px;">📋 库存变动记录</h3>
                <div id="stockLogs" style="max-height:300px;overflow-y:auto;"></div>
            </div>
        </div>

        <!-- ==================== 评论管理 ==================== -->
        <div id="tab-comment" class="tab-content">
            <div class="card">
                <h3 style="font-size:18px;">💬 商品评论管理</h3>
                <div class="search-bar">
                    <input type="text" id="commentSearch" placeholder="搜索用户名..." oninput="loadComments()">
                    <select id="commentProductFilter" onchange="loadComments()"><option value="">全部商品</option></select>
                </div>
                <div id="commentList"></div>
            </div>
        </div>

        <!-- ==================== 用户管理 ==================== -->
        <div id="tab-user" class="tab-content">
            <div class="card">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;">
                    <h3 style="margin:0;padding:0;border:none;font-size:18px;">👥 用户管理</h3>
                    <div style="display:flex;gap:8px;">
                        <button class="btn btn-primary btn-sm" onclick="showAddUserModal()">添加用户</button>
                        <button class="btn btn-primary btn-sm" onclick="exportUsers()">导出用户列表</button>
                    </div>
                </div>
                <div class="search-bar">
                    <input type="text" id="userSearch" placeholder="搜索昵称..." style="width:220px;" oninput="loadUsers()">
                    <select id="userRoleFilter" style="padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;" onchange="loadUsers()">
                        <option value="">全部</option>
                        <option value="0">普通用户</option>
                        <option value="1">管理员</option>
                    </select>
                </div>
                <table><thead><tr><th>ID</th><th>头像</th><th>昵称</th><th>真实姓名</th><th>手机号</th><th>身份</th><th>注册时间</th><th>订单数</th><th>点赞数</th><th>操作</th></tr></thead>
                <tbody id="userTable"></tbody></table>
                <div class="pagination" id="userPagination"></div>
            </div>
        </div>

        <!-- ==================== 订单管理 ==================== -->
        <div id="tab-order" class="tab-content">
            <div class="card">
                <h3 style="font-size:16px;">📋 订单管理</h3>
                <div class="search-bar">
                    <input type="text" id="orderSearch" placeholder="🔍 订单号/用户名..." oninput="loadOrders()">
                    <select id="orderStatusFilter" onchange="loadOrders()">
                        <option value="">全部状态</option>
                        <option value="0">待支付</option><option value="7">已超时</option>
                        <option value="1">未发货</option>
                        <option value="2">已发货</option>
                        <option value="3">已完成</option>
                        <option value="4">已取消</option>
                        <option value="5">退款中</option>
                        <option value="6">已退款</option>
                    </select>
                    <div class="date-group">
                        <label>创建订单起始时间</label>
                        <input type="date" id="orderDateFrom" onchange="loadOrders()">
                    </div>
                    <div class="date-group">
                        <label>创建订单结束时间</label>
                        <input type="date" id="orderDateTo" onchange="loadOrders()">
                    </div>
                </div>
                <table><thead><tr><th>订单号</th><th>用户</th><th>金额</th><th>状态</th><th>支付方式</th><th>创建时间</th><th>操作</th></tr></thead>
                <tbody id="orderTable"></tbody></table>
                <div class="pagination" id="orderPagination"></div>
            </div>
        </div>

        <!-- ==================== 数据统计 ==================== -->
        <div id="tab-stats" class="tab-content">
            <div class="stats-row" id="statsOverview"></div>
            <div class="card"><h3>📊 每日销售额</h3><div id="dailySalesChart" style="height:250px;display:flex;align-items:flex-end;gap:8px;"></div></div>
            <div class="card"><h3>📊 每月销售额</h3><div id="monthlySalesChart" style="height:250px;display:flex;align-items:flex-end;gap:8px;"></div></div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                <div class="card"><h3>🔥 热销排行榜</h3><div id="topProducts"></div></div>
                <div class="card"><h3>👥 用户统计</h3><div id="userStats"></div></div>
            </div>
        </div>

        <!-- ==================== 个人资料 ==================== -->
        <div id="tab-profile" class="tab-content">
            <div class="card">
                <h3>👤 个人资料</h3>
                <div style="display:flex;gap:30px;align-items:flex-start;">
                    <div style="text-align:center;">
                        <div class="avatar" id="profileAvatar" style="width:100px;height:100px;font-size:40px;cursor:pointer;" onclick="document.getElementById('avatarFileInput').click()">
                            <span id="profileAvatarText">👤</span>
                        </div>
                        <input type="file" id="avatarFileInput" accept="image/*" style="display:none;" onchange="uploadAvatar(this)">
                        <p style="font-size:12px;color:#999;margin-top:5px;">点击更换头像</p>
                    </div>
                    <div style="flex:1;">
                        <div class="form-row">
                            <div class="form-group"><label>用户名</label><input type="text" id="profileUsername"></div>
                            <div class="form-group"><label>真实姓名</label><input type="text" id="profileRealName"></div>
                        </div>
                        <div class="form-row">
                            <div class="form-group"><label>手机号</label><input type="text" id="profilePhone"></div>
                            <div class="form-group"><label>邮箱</label><input type="text" id="profileEmail"></div>
                        </div>
                        <button class="btn btn-primary" onclick="updateProfile()">保存修改</button>
                    </div>
                </div>
            </div>
            <div class="card">
                <h3>🔒 修改密码</h3>
                <div class="form-row">
                    <div class="form-group"><label>旧密码</label><input type="password" id="oldPassword"></div>
                    <div class="form-group"><label>新密码</label><input type="password" id="newPassword"></div>
                </div>
                <div class="form-group"><label>确认新密码</label><input type="password" id="confirmPassword"></div>
                <button class="btn btn-primary" onclick="changePassword()">修改密码</button>
            </div>
        </div>

        <!-- ==================== 日志管理 ==================== -->
        <div id="tab-logs" class="tab-content">
            <div class="card">
                <h3>📝 操作日志</h3>
                <div class="search-bar">
                    <input type="text" id="logSearch" placeholder="搜索日志..." oninput="loadLogs()">
                    <span style="font-size:16px;color:#333;font-weight:500;">起始时间：</span><input type="date" id="logDateFrom" onchange="loadLogs()">
                    <span style="font-size:16px;color:#333;font-weight:500;">结束时间：</span><input type="date" id="logDateTo" onchange="loadLogs()">
                </div>
                <div id="logList" style="max-height:calc(100vh - 360px);overflow-y:auto;"></div>
            </div>
        </div>
    </div>

    <!-- 通用模态框 -->
    <div class="modal-overlay" id="modalOverlay">
        <div class="modal" id="modalContent"></div>
    </div>

    <script>
        const ctx = '${ctx}';
        function escapeHtml(str) { if (!str) return ''; return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;'); }
        function handleProductImgError(img) { if (!img) return; var defaultSrc = ctx + '/images/products/default-product.jpg'; img.onerror = function() { this.style.display = 'none'; if (this.nextElementSibling) this.nextElementSibling.style.display = 'flex'; }; img.src = defaultSrc; setTimeout(function() { if (img.naturalWidth === 0) { img.style.display = 'none'; if (img.nextElementSibling) img.nextElementSibling.style.display = 'flex'; } }, 60); }
        function handleProductPreviewImgError(img) { if (!img) return; var defaultSrc = ctx + '/images/products/default-product.jpg'; img.onerror = function() { if (this.parentElement) this.parentElement.style.display = 'none'; }; img.src = defaultSrc; setTimeout(function() { if (img.naturalWidth === 0 && img.parentElement) img.parentElement.style.display = 'none'; }, 60); }
        function handleAvatarImgError(img) { if (!img) return; img.onerror = function() { if (this.parentElement) this.parentElement.innerHTML = '👤'; }; img.src = img.src; }
        function handleAvatarComplexError(img) { if (!img) return; img.onerror = function() { if (this.parentElement) { this.parentElement.style.border = 'none'; this.parentElement.style.background = '#e6f7ff'; this.parentElement.style.display = 'flex'; this.parentElement.style.alignItems = 'center'; this.parentElement.style.justifyContent = 'center'; this.parentElement.style.fontSize = '16px'; this.parentElement.innerHTML = '👤'; } }; img.src = img.src; }
        function handleOrderAvatarError(img) { if (!img) return; img.onerror = function() { this.style.display = 'none'; if (this.parentElement) this.parentElement.innerHTML = '👤'; }; img.src = img.src; }
        function handleUserAvatarInline(img) { if (!img) return; img.onerror = null; if (img.parentElement) img.parentElement.innerHTML = '👤'; }
        function toggleAddrDefaultBadge() { var e = document.getElementById('userAddrDefault'); if (!e) return; var c = e.getAttribute('data-default') === '1'; e.setAttribute('data-default', c ? '0' : '1'); e.textContent = c ? '' : '默认'; e.style.background = c ? '#f0f0f0' : '#52c41a'; e.style.color = c ? '#bbb' : '#fff'; }
        function toggleCardHoverOn(el) { if (el) el.style.boxShadow = '0 2px 8px rgba(0,0,0,0.08)'; }
        function toggleCardHoverOff(el) { if (el) el.style.boxShadow = 'none'; }
        function stopProp(e) { if (e && e.stopPropagation) e.stopPropagation(); }
        function handleHeaderAvatarError(img) { if (img && img.parentElement) img.parentElement.innerHTML = '<span>👤</span>'; }
        function handleProfileAvatarError(img) { if (img && img.parentElement) img.parentElement.innerHTML = '<span id=profileAvatarText>👤</span>'; }
        const adminUser = { id: '${sessionScope.userId}', username: '${sessionScope.username}', role: '${sessionScope.role}' };
        let selectedProductIds = [];
        let currentPage = { product: 1, user: 1, order: 1 };
        let _userDetailContext = null; // 记录从用户详情进入的上下文，关闭订单详情时返回用户详情
        let _addrData = []; // 用户详情地址数据，供下拉切换使用

        function showAddr(idx) {
            var addr = _addrData && _addrData[idx];
            if (!addr) return;
            var el = document.getElementById('addrDetail');
            if (!el) return;
            el.innerHTML = 
                '<div style="padding:14px;border-radius:8px;background:' + (addr.isDefault ? '#e6f7ff' : '#fff') + ';border:1px solid ' + (addr.isDefault ? '#91d5ff' : '#e0e0e0') + ';font-size:14px;">' +
                '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">' +
                '<div style="font-weight:600;color:#333;font-size:15px;">' + escapeHtml(addr.receiverName) + ' ' + escapeHtml(addr.receiverPhone) + '</div>' +
                (addr.isDefault ? '<span style="background:#52c41a;color:#fff;font-size:12px;padding:2px 10px;border-radius:10px;font-weight:500;">默认</span>' : '') +
                '</div>' +
                '<div style="color:#666;line-height:1.6;word-break:break-all;font-size:13px;">📍 ' + escapeHtml(addr.province) + escapeHtml(addr.city) + escapeHtml(addr.district) + ' ' + escapeHtml(addr.address) + '</div>' +
                '</div>';
        }

        // ==================== 初始化 ====================
        window.onload = function() {
            loadDashboard();
            loadAdminAvatar();
        };

        function loadAdminAvatar() {
            fetch(ctx + '/api/user/detail')
                .then(r => r.json()).then(res => {
                    if (res.code === 200 && res.data) {
                        const avatar = res.data.avatar;
                        if (avatar && String(avatar).trim() !== '') {
                            const src = String(avatar).startsWith('http') || String(avatar).startsWith('data:') ? avatar : ctx + '/images/avatars/' + avatar;
                            document.getElementById('headerAvatar').innerHTML = '<img src="' + src + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="handleHeaderAvatarError(this)">';
                            document.getElementById('profileAvatar').innerHTML = '<img src="' + src + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="handleProfileAvatarError(this)">';
                        } else {
                            document.getElementById('headerAvatar').innerHTML = '<span id="headerAvatarText">👤</span>';
                            document.getElementById('profileAvatar').innerHTML = '<span id="profileAvatarText">👤</span>';
                        }
                    }
                }).catch(() => {
                    document.getElementById('headerAvatar').innerHTML = '<span id="headerAvatarText">👤</span>';
                    document.getElementById('profileAvatar').innerHTML = '<span id="profileAvatarText">👤</span>';
                });
        }

        // ==================== 标签切换 ====================
        function switchTab(tab) {
            document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            document.getElementById('tab-' + tab).classList.add('active');
            var navItem = document.querySelector('.nav-item[onclick="switchTab(\'' + tab + '\')"]');
            if (navItem) { navItem.classList.add('active'); }
            switch(tab) {
                case 'dashboard': loadDashboard(); break;
                case 'category': loadCategories(); break;
                case 'product': loadCategoriesForFilter(); loadProducts(); break;
                case 'stock': loadStock(); break;
                case 'comment': loadComments(); loadProductsForCommentFilter(); break;
                case 'user': loadUsers(); break;
                case 'order': loadOrders(); break;
                case 'stats': loadStats(); break;
                case 'profile': loadProfile(); break;
                case 'logs': document.body.style.overflow = 'hidden'; loadLogs(); break;
            }
            if (tab !== 'logs') document.body.style.overflow = '';
        }

        // ==================== 控制台 ====================
        function loadDashboard() {
            fetch(ctx + '/api/admin/dashboard')
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        const d = res.data;
                        document.getElementById('dashboardStats').innerHTML = 
                            '<div class="stat-card blue clickable" onclick="switchTab(\'product\')"><div class="stat-value">' + (d.totalProducts || 0) + '</div><div class="stat-label">商品总数</div></div>' +
                            '<div class="stat-card green clickable" onclick="switchTab(\'order\')"><div class="stat-value">' + (d.totalOrders || 0) + '</div><div class="stat-label">总订单数</div></div>' +
                            '<div class="stat-card orange clickable" onclick="showTotalSalesDetail()"><div class="stat-value">¥' + (d.totalSales || 0).toFixed(2) + '</div><div class="stat-label">总销售额</div></div>' +
                            '<div class="stat-card purple clickable" onclick="switchTab(\'user\')"><div class="stat-value">' + (d.totalUsers || 0) + '</div><div class="stat-label">用户总数</div></div>';
                        if (d.recentSales && d.recentSales.length > 0) {
                            const W = 700, H = 250, PAD_L = 55, PAD_R = 20, PAD_T = 30, PAD_B = 30;
                            const plotW = W - PAD_L - PAD_R, plotH = H - PAD_T - PAD_B;
                            const maxVal = Math.max(...d.recentSales.map(s => s.amount), 1);
                            const n = d.recentSales.length;
                            const stepX = plotW / Math.max(n - 1, 1);
                            const points = d.recentSales.map((s, i) => ({
                                x: PAD_L + i * stepX,
                                y: PAD_T + plotH - (s.amount / maxVal * plotH),
                                label: s.date.substring(5),
                                val: s.amount
                            }));
                            const polyline = points.map(p => p.x + ',' + p.y).join(' ');
                            const circles = points.map(p => '<circle cx="' + p.x + '" cy="' + p.y + '" r="4" fill="#4facfe" stroke="#fff" stroke-width="2"/>').join('');
                            const labels = points.map(p => '<text x="' + p.x + '" y="' + (p.y - 10) + '" text-anchor="middle" font-size="11" fill="#333" font-weight="600">¥' + p.val.toFixed(0) + '</text>').join('');
                            const xLabels = points.map(p => '<text x="' + p.x + '" y="' + (H - 4) + '" text-anchor="middle" font-size="11" fill="#999">' + p.label + '</text>').join('');
                            const gridLines = [0, 0.25, 0.5, 0.75, 1].map(ratio => {
                                const y = PAD_T + plotH * (1 - ratio);
                                return '<line x1="' + PAD_L + '" y1="' + y + '" x2="' + (W - PAD_R) + '" y2="' + y + '" stroke="#f0f0f0" stroke-width="1"/><text x="' + (PAD_L - 6) + '" y="' + (y + 4) + '" text-anchor="end" font-size="10" fill="#bbb">¥' + (maxVal * ratio).toFixed(0) + '</text>';
                            }).join('');
                            document.getElementById('salesChart').innerHTML = '<svg viewBox="0 0 ' + W + ' ' + H + '" style="width:100%;height:100%;">' +
                                '<defs><linearGradient id="lineGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#4facfe" stop-opacity="0.2"/><stop offset="100%" stop-color="#4facfe" stop-opacity="0"/></linearGradient></defs>' +
                                gridLines +
                                '<polygon points="' + points[0].x + ',' + (PAD_T + plotH) + ' ' + points.map(p => p.x + ',' + p.y).join(' ') + ' ' + points[points.length-1].x + ',' + (PAD_T + plotH) + '" fill="url(#lineGrad)"/>' +
                                '<polyline points="' + polyline + '" fill="none" stroke="#4facfe" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>' +
                                circles + labels + xLabels +
                                '</svg>';
                        }
                        if (d.hotProducts) {
                            document.getElementById('hotProducts').innerHTML = d.hotProducts.map((p,i) => 
                                '<div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f5f5f5;"><span>' + (i+1) + '. ' + p.name + '</span><span style="color:#4facfe;">销量: ' + p.salesCount + '</span></div>'
                            ).join('');
                        }
                        if (d.stockAlerts) {
                            document.getElementById('stockAlerts').innerHTML = d.stockAlerts.length > 0 ? 
                                d.stockAlerts.map(p => '<div style="padding:6px 0;border-bottom:1px solid #f5f5f5;color:#ff4d4f;">⚠ ' + p.name + ' (库存: ' + p.stock + ')</div>').join('') :
                                '<div class="empty-state">暂无库存预警</div>';
                        }
                    }
                });
        }

        // ==================== 分类管理 ====================
        function loadCategories() {
            fetch(ctx + '/api/category/list')
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        document.getElementById('categoryTable').innerHTML = res.data.map((c, i) => 
                            '<tr><td style="text-align:center;">' + (i + 1) + '</td><td style="text-align:center;">' + c.name + '</td>' +
                            '<td style="text-align:center;"><button class="btn btn-primary btn-sm" onclick="editCategory(' + c.id + ',\'' + c.name + '\')">编辑</button>&nbsp;&nbsp;<button class="btn btn-danger btn-sm" onclick="deleteCategory(' + c.id + ')">删除</button></td></tr>'
                        ).join('');
                    }
                });
        }
        function showCategoryModal(cat) {
            const isEdit = cat && cat.id;
            document.getElementById('modalContent').innerHTML = 
                '<h3>' + (isEdit ? '编辑分类' : '新增分类') + '</h3>' +
                '<div class="form-group"><label>分类名称</label><input type="text" id="catName" value="' + (cat ? cat.name : '') + '"></div>' +
                '<div class="modal-actions"><button class="btn" onclick="closeModal()">取消</button><button class="btn btn-primary" onclick="saveCategory(' + (isEdit ? cat.id : 'null') + ')">保存</button></div>';
            document.getElementById('modalOverlay').classList.add('show');
        }
        function saveCategory(id) {
            const name = document.getElementById('catName').value;
            if (!name) { alert('请输入分类名称'); return; }
            const params = new URLSearchParams();
            params.append('name', name);
            if (id) params.append('id', id);
            fetch(ctx + '/api/admin/category/save', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString() })
                .then(r => r.json()).then(res => {
                    alert(res.message);
                    if (res.code === 200) { closeModal(); loadCategories(); }
                });
        }
        function editCategory(id, name) {
            showCategoryModal({ id, name });
        }
        function deleteCategory(id) {
            if (!confirm('确定删除该分类？')) return;
            fetch(ctx + '/api/admin/category/delete?id=' + id).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadCategories();
            });
        }

        // ==================== 商品管理 ====================
        function loadCategoriesForFilter() {
            fetch(ctx + '/api/category/list').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    document.getElementById('productCategoryFilter').innerHTML = '<option value="">全部分类</option>' + res.data.map(c => '<option value="' + c.id + '">' + c.name + '</option>').join('');
                }
            });
        }
        function resolveProductImage(p) {
            var pImg = p.image || '';
            var pId = p.id || 0;
            if (pImg && pImg.startsWith('http')) return pImg;
            var tsMatch = pImg.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i);
            if (tsMatch) return ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3];
            // 优先使用商品 ID 来构建 URL
            if (pId && pId > 0) return ctx + '/images/products/' + pId + '.jpg';
            if (pImg && pImg.length > 0) return ctx + '/images/products/' + pImg;
            return ctx + '/images/products/default-product.jpg';
        }
        function buildProductRowHtml(p, idx) {
            var img = resolveProductImage(p);
            var statusBadge = p.status === 1 ? '<span class="badge badge-success">上架</span>' : '<span class="badge badge-danger">下架</span>';
            var rowNum = (currentPage.product - 1) * 10 + idx + 1;
            var html = '';
            html += '<tr>';
            html += '<td><input type="checkbox" value="' + p.id + '" onchange="updateSelected()"></td>';
            html += '<td>' + rowNum + '</td>';
            html += '<td style="display:flex;justify-content:center;align-items:center;min-height:60px;">';
            html += '<div style="width:50px;height:50px;border-radius:6px;overflow:hidden;background:#f5f5f5;display:flex;align-items:center;justify-content:center;flex-shrink:0;">';
            html += '<img src="' + img + '" style="width:100%;height:100%;object-fit:cover;" onerror="handleProductImgError(this)">';
            html += '<span style="font-size:18px;color:#ccc;display:none;">&#128247;</span>';
            html += '</div></td>';
            var hotBadge = p.isHot === 1 ? '<span style="display:inline-block;background:linear-gradient(135deg,#f5576c,#ff6b6b);color:#fff;font-size:11px;font-weight:bold;padding:2px 6px;border-radius:3px;margin-right:4px;">Hot</span>' : '';
var newBadge = p.isNew === 1 ? '<span style="display:inline-block;background:linear-gradient(135deg,#4facfe,#00f2fe);color:#fff;font-size:11px;font-weight:bold;padding:2px 6px;border-radius:3px;margin-right:4px;">New</span>' : '';
html += '<td>' + hotBadge + newBadge + p.name + '</td>';
            html += '<td>' + (p.categoryName || '-') + '</td>';
            html += '<td>¥' + (p.price || 0).toFixed(2) + '</td>';
            html += '<td style="text-decoration:line-through;color:#999;">¥' + (p.originalPrice || 0).toFixed(2) + '</td>';
            html += '<td style="text-align:center;">' + p.stock + '</td>';
            html += '<td style="text-align:center;">' + p.salesCount + '</td>';
            html += '<td style="text-align:center;">' + statusBadge + '</td>';
            html += '<td style="text-align:center;">';
            html += '<button class="btn btn-primary btn-sm" onclick="editProduct(' + p.id + ')">编辑</button> ';
            html += '<button class="btn btn-warning btn-sm" onclick="toggleProduct(' + p.id + ',' + (p.status === 1 ? 0 : 1) + ')">' + (p.status === 1 ? '下架' : '上架') + '</button> ';
            html += '<button class="btn btn-danger btn-sm" onclick="deleteProduct(' + p.id + ')">删除</button>';
            html += '</td></tr>';
            return html;
        }
        function loadProducts(page) {
            if (page) currentPage.product = page;
            const params = new URLSearchParams();
            params.append('page', currentPage.product);
            params.append('pageSize', 10);
            const kw = document.getElementById('productSearch').value;
            const cat = document.getElementById('productCategoryFilter').value;
            const status = document.getElementById('productStatusFilter').value;
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            if (cat) params.append('categoryId', cat);
            if (status) params.append('status', status);
            fetch(ctx + '/api/admin/product/list?' + params.toString())
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        document.getElementById('productTable').innerHTML = res.data.list.map((p, i) => buildProductRowHtml(p, i)).join('');
                        renderPagination('productPagination', res.data.total, currentPage.product, 10, loadProducts);
                    }
                });
        }
        function updateSelected() {
            selectedProductIds = Array.from(document.querySelectorAll('#productTable input[type=checkbox]:checked')).map(c => c.value);
            document.getElementById('selectAllProducts').checked = selectedProductIds.length > 0 && 
                selectedProductIds.length === document.querySelectorAll('#productTable input[type=checkbox]').length;
        }
        function toggleSelectAll(el) {
            document.querySelectorAll('#productTable input[type=checkbox]').forEach(c => { c.checked = el.checked; });
            updateSelected();
        }
        function batchToggleProduct(status) {
            if (selectedProductIds.length === 0) { alert('请先选择商品'); return; }
            fetch(ctx + '/api/admin/product/batchStatus', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'ids=' + selectedProductIds.join(',') + '&status=' + status
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadProducts(); });
        }

        function showProductModal(product) {
            const isEdit = product && product.id;
            document.getElementById('modalContent').innerHTML = 
                '<h3>' + (isEdit ? '编辑商品' : '新增商品') + '</h3>' +
                '<table style="font-size:16px;width:100%;"><tbody>' +
                (function() { var previewSrc = ''; if (isEdit && product) { var pImg = product.image || ''; if (pImg && pImg.startsWith('http')) { previewSrc = pImg; } else { var tsMatch = pImg.match(/^(\d+)_(\d+)\.(jpg|jpeg|png|gif)$/i); if (tsMatch) { previewSrc = ctx + '/images/products/' + tsMatch[2] + '.' + tsMatch[3]; } else if (pImg && pImg.length > 0) { previewSrc = ctx + '/images/products/' + pImg; } else { previewSrc = ctx + '/images/products/' + (product.id || 0) + '.jpg'; } } } return '<tr><td style="padding:8px 12px;"><label>商品图片</label></td><td style="padding:8px 12px;"><div id="productImagePreview" style="margin-bottom:8px;' + (previewSrc ? '' : 'display:none;') + '"><img src="' + previewSrc + '" style="width:120px;height:120px;object-fit:cover;border-radius:8px;border:1px solid #e8e8e8;" onerror="handleProductPreviewImgError(this)"></div><input type="file" id="productImageFile" accept="image/*" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;" onchange="previewProductImage(this)"></td></tr>'; })() +
                '<tr><td style="padding:8px 12px;"><label>商品名称</label></td><td style="padding:8px 12px;"><input type="text" id="prodName" value="' + (product ? product.name : '') + '" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label>分类</label></td><td style="padding:8px 12px;"><select id="prodCategoryId" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"></select></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label>价格 (¥)</label></td><td style="padding:8px 12px;"><input type="number" step="0.01" id="prodPrice" value="' + (product ? product.price : '') + '" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label><input type="checkbox" id="prodDiscount" onchange="toggleDiscount()"> 设置打折</label></td><td style="padding:8px 12px;"></td></tr>' +
                '<tr id="discountSectionRow" style="display:none;"><td style="padding:8px 12px;"><label>折扣 (如 8 折=0.8)</label></td><td style="padding:8px 12px;"><input type="number" step="0.1" id="prodDiscountRate" value="1" oninput="calcFinalPrice()" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"></td></tr>' +
                '<tr id="finalPriceRow" style="display:none;"><td style="padding:8px 12px;"><label>最终售价 (¥)</label></td><td style="padding:8px 12px;"><input type="number" step="0.01" id="prodFinalPrice" readonly style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;background:#f5f5f5;"></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label>库存</label></td><td style="padding:8px 12px;"><input type="number" id="prodStock" value="' + (product ? product.stock : '') + '" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label>详情介绍</label></td><td style="padding:8px 12px;"><textarea id="prodDescription" rows="3" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;">' + (product ? product.description : '') + '</textarea></td></tr>' +
                '<tr><td style="padding:8px 12px;"><label>商品标记</label></td><td style="padding:8px 12px;"><label style="margin-right:20px;"><input type="checkbox" id="prodIsHot" ' + (product && product.isHot === 1 ? 'checked' : '') + '> 热销(Hot)</label><label><input type="checkbox" id="prodIsNew" ' + (product && product.isNew === 1 ? 'checked' : '') + '> 新品(New)</label></td></tr><tr><td style="padding:8px 12px;"><label>状态</label></td><td style="padding:8px 12px;"><select id="prodStatus" style="width:100%;padding:8px 12px;border:1px solid #d9d9d9;border-radius:6px;font-size:14px;"><option value="1" ' + (!product || product.status === 1 ? 'selected' : '') + '>上架</option><option value="0" ' + (product && product.status === 0 ? 'selected' : '') + '>下架</option></select></td></tr>' +
                '</tbody></table>' +
                '<div class="modal-actions" style="margin-top:20px;"><button class="btn" onclick="closeModal()">取消</button><button class="btn btn-primary" onclick="saveProduct(' + (isEdit ? product.id : 'null') + ')">保存</button></div>';
            document.getElementById('modalOverlay').classList.add('show');
            fetch(ctx + '/api/category/list').then(r => r.json()).then(res => {
                if (res.code === 200) document.getElementById('prodCategoryId').innerHTML = res.data.map(c => '<option value="' + c.id + '" ' + (product && product.categoryId === c.id ? 'selected' : '') + '>' + c.name + '</option>').join('');
            });
            if (product && product.originalPrice && product.originalPrice > product.price) {
                document.getElementById('prodDiscount').checked = true;
                document.getElementById('discountSectionRow').style.display = 'table-row';
                document.getElementById('finalPriceRow').style.display = 'table-row';
                document.getElementById('prodDiscountRate').value = (product.price / product.originalPrice).toFixed(2);
                document.getElementById('prodFinalPrice').value = product.price;
            }
        }
        function toggleDiscount() {
            document.getElementById('discountSectionRow').style.display = document.getElementById('prodDiscount').checked ? 'table-row' : 'none';
            document.getElementById('finalPriceRow').style.display = document.getElementById('prodDiscount').checked ? 'table-row' : 'none';
            calcFinalPrice();
        }
        function previewProductImage(input) {
            const preview = document.getElementById('productImagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.style.display = '';
                    preview.innerHTML = '<img src="' + e.target.result + '" style="width:120px;height:120px;object-fit:cover;border-radius:8px;border:1px solid #e8e8e8;">';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        function calcFinalPrice() {
            const price = parseFloat(document.getElementById('prodPrice').value) || 0;
            const rate = parseFloat(document.getElementById('prodDiscountRate').value) || 1;
            document.getElementById('prodFinalPrice').value = (price * rate).toFixed(2);
        }
        function saveProduct(id) {
            const formData = new FormData();
            formData.append('name', document.getElementById('prodName').value);
            formData.append('categoryId', document.getElementById('prodCategoryId').value);
            formData.append('price', document.getElementById('prodPrice').value);
            formData.append('stock', document.getElementById('prodStock').value);
            formData.append('description', document.getElementById('prodDescription').value);
            formData.append('status', document.getElementById('prodStatus').value);
            formData.append('isHot', document.getElementById('prodIsHot').checked ? '1' : '0');
            formData.append('isNew', document.getElementById('prodIsNew').checked ? '1' : '0');
            if (document.getElementById('prodDiscount').checked) {
                formData.append('discountRate', document.getElementById('prodDiscountRate').value);
            }
            if (id) formData.append('id', id);
            const imageFile = document.getElementById('productImageFile').files[0];
            if (imageFile) formData.append('image', imageFile);
            fetch(ctx + '/api/admin/product/save', { method: 'POST', body: formData })
                .then(r => r.json()).then(res => {
                    alert(res.message);
                    if (res.code === 200) { closeModal(); loadProducts(); }
                });
        }
        function editProduct(id) {
            fetch(ctx + '/api/product/detail?id=' + id).then(r => r.json()).then(res => {
                if (res.code === 200) showProductModal(res.data);
            });
        }
        function toggleProduct(id, status) {
            fetch(ctx + '/api/admin/product/status', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id + '&status=' + status
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadProducts(); });
        }
        function deleteProduct(id) {
            if (!confirm('确定删除该商品？')) return;
            fetch(ctx + '/api/admin/product/delete?id=' + id).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadProducts();
            });
        }

        // ==================== 库存管理 ====================
        function loadStock() {
            const kw = document.getElementById('stockSearch').value;
            const alert = document.getElementById('stockAlertFilter').value;
            const params = new URLSearchParams();
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            if (alert) params.append('alert', alert);
            fetch(ctx + '/api/admin/stock/list?' + params.toString())
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        document.getElementById('stockTable').innerHTML = res.data.map((p, i) => 
                            '<tr><td>' + (i + 1) + '</td><td>' + p.name + '</td><td class="' + (p.stock <= 10 ? 'stock-warning' : 'stock-normal') + '">' + p.stock + '</td>' +
                            '<td>10</td><td>' + (p.stock <= 10 ? '<span class="badge badge-danger">库存不足</span>' : '<span class="badge badge-success">正常</span>') + '</td>' +
                            '<td><button class="btn btn-primary btn-sm" onclick="adjustStock(' + p.id + ',\'' + p.name + '\',' + p.stock + ')">调整库存</button></td></tr>'
                        ).join('');
                    }
                });
            loadStockLogs();
        }
        function adjustStock(id, name, currentStock) {
            document.getElementById('modalContent').innerHTML = 
                '<h3>调整库存 - ' + name + '</h3><p>当前库存: ' + currentStock + '</p>' +
                '<div class="form-group"><label>变动数量 (正数入库，负数出库)</label><input type="number" id="adjustQty" value="0"></div>' +
                '<div class="form-group"><label>变动原因</label><input type="text" id="adjustReason" placeholder="如：入库、售出、退换货"></div>' +
                '<div class="modal-actions"><button class="btn" onclick="closeModal()">取消</button><button class="btn btn-primary" onclick="doAdjustStock(' + id + ')">确认</button></div>';
            document.getElementById('modalOverlay').classList.add('show');
        }
        function doAdjustStock(id) {
            const qty = parseInt(document.getElementById('adjustQty').value) || 0;
            const reason = document.getElementById('adjustReason').value;
            if (qty === 0) { alert('请输入变动数量'); return; }
            fetch(ctx + '/api/admin/stock/adjust', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id + '&quantity=' + qty + '&reason=' + encodeURIComponent(reason)
            }).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) { closeModal(); loadStock(); }
            });
        }
        function loadStockLogs() {
            fetch(ctx + '/api/admin/stock/logs').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    document.getElementById('stockLogs').innerHTML = res.data.length > 0 ?
                        res.data.map(l => '<div class="log-entry"><span class="time">' + l.createTime + '</span><span style="color:#1890ff;font-size:12px;margin-left:8px;">by ' + (l.adminName || '系统') + '</span> ' + l.productName + ' <b>' + (l.quantity > 0 ? '+' : '') + l.quantity + '</b> (' + l.reason + ')</div>').join('') :
                        '<div class="empty-state">暂无库存变动记录</div>';
                }
            });
        }

        // ==================== 评论管理 ====================
        function loadProductsForCommentFilter() {
            fetch(ctx + '/api/admin/product/list?pageSize=1000').then(r => r.json()).then(res => {
                if (res.code === 200 && res.data.list) {
                    document.getElementById('commentProductFilter').innerHTML = '<option value="">全部商品</option>' + 
                        res.data.list.map(p => '<option value="' + p.id + '">' + p.name + '</option>').join('');
                }
            });
        }
        function loadComments() {
            const kw = document.getElementById('commentSearch').value;
            const pid = document.getElementById('commentProductFilter').value;
            const params = new URLSearchParams();
            params.append('pageSize', 50);
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            if (pid) params.append('productId', pid);
            fetch(ctx + '/api/admin/comment/list?' + params.toString())
                .then(r => r.json()).then(res => {
                    if (res.code === 200 && res.data) {
                        document.getElementById('commentList').innerHTML = res.data.map(c => {
                            var isEvaluation = c.orderId && c.rating && c.rating > 0;
                            var starsHtml = '';
                            var badgeHtml = '';
                            if (isEvaluation) {
                                starsHtml = '<div style="margin-bottom:8px;">' + buildRatingStars(c.rating) + '<span class="badge badge-info" style="margin-left:8px;font-size:12px;background:#fff3e0;color:#ff9800;border:none;padding:2px 8px;">评价</span></div>';
                            } else {
                                badgeHtml = '<span class="badge badge-default" style="font-size:12px;background:#e3f2fd;color:#1976d2;border:none;padding:2px 8px;margin-left:8px;">评论</span>';
                            }
                            return '<div class="comment-card" style="background:#fff;border:1px solid #e8e8e8;border-radius:8px;padding:16px 20px;margin-bottom:12px;transition:box-shadow 0.2s;">' +
                            '<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:10px;">' +
                            '<div style="display:flex;align-items:center;gap:10px;">' +
                            '<div class="comment-avatar" style="width:36px;height:36px;border-radius:50%;overflow:hidden;flex-shrink:0;cursor:pointer;border:1px solid #e8e8e8;" onclick="viewUserDetail(' + c.userId + ')" title="点击查看用户详情">' + (c.avatar ? '<img src="' + (c.avatar.startsWith('http')||c.avatar.startsWith('data:') ? c.avatar : ctx + '/images/avatars/' + c.avatar) + '" style="width:36px;height:36px;object-fit:cover;border-radius:50%;" onerror="handleAvatarComplexError(this)">' : '<span style="font-size:16px;">👤</span>') + '</div>' +
                            '<div>' +
                            '<div style="font-weight:600;font-size:15px;color:#333;">' + c.username + badgeHtml + '</div>' +
                            '<div style="font-size:13px;color:#999;">' + c.createTime + ' · <span style="color:#1890ff;">' + (c.productName || '商品') + '</span> · 👍 ' + (c.likeCount || 0) + '</div>' +
                            '</div>' +
                            '</div>' +
                            (c.status === -1 ? '<span class="badge badge-danger" style="font-size:13px;">已删除</span>' : '') +
                            '</div>' +
                            starsHtml +
                            '<div style="display:flex;justify-content:space-between;align-items:center;">' +
                            '<div style="font-size:14px;color:#666;line-height:1.6;flex:1;padding-right:16px;">' + c.content + '</div>' +
                            '<div style="display:flex;gap:8px;flex-shrink:0;">' +
                            '<button class="btn btn-primary btn-sm" onclick="replyComment(' + c.id + ')" style="white-space:nowrap;">回复</button>' +
                            (c.status === 1 ? '<button class="btn btn-danger btn-sm" onclick="deleteComment(' + c.id + ')" style="white-space:nowrap;">删除</button>' :
                            '<button class="btn btn-success btn-sm" onclick="restoreComment(' + c.id + ')" style="white-space:nowrap;">恢复</button>') +
                            '</div>' +
                            '</div>' +
                            (c.replyContent ? '<div style="margin-top:12px;padding:12px 16px;background:#f6ffed;border-left:3px solid #52c41a;border-radius:0 6px 6px 0;font-size:14px;color:#333;display:flex;justify-content:space-between;align-items:center;">' +
                            '<span>🔹 <strong>管理员回复：</strong>' + c.replyContent + '</span>' +
                            '<button class="btn btn-danger btn-xs" onclick="deleteReply(' + c.id + ')" style="white-space:nowrap;flex-shrink:0;padding:2px 8px;font-size:11px;opacity:0.7;">删除回复</button>' +
                            '</div>' : '') +
                            '</div>';
                        }).join('');
                    }
                });
        }
        function replyComment(id) {
            const reply = prompt('请输入回复内容：');
            if (!reply) return;
            fetch(ctx + '/api/admin/comment/reply', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'commentId=' + id + '&replyContent=' + encodeURIComponent(reply)
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadComments(); });
        }
        function deleteComment(id) {
            if (!confirm('确定删除该评论？')) return;
            fetch(ctx + '/api/admin/comment/delete?id=' + id).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadComments();
            });
        }
        function restoreComment(id) {
            fetch(ctx + '/api/admin/comment/restore?id=' + id).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadComments();
            });
        }
        function deleteReply(id) {
            if (!confirm('确定删除该回复？')) return;
            fetch(ctx + '/api/admin/comment/reply/delete?id=' + id).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadComments();
            });
        }

        // ==================== 用户管理 ====================
        function loadUsers(page) {
            if (page) currentPage.user = page;
            const kw = document.getElementById('userSearch').value;
            const params = new URLSearchParams();
            params.append('page', currentPage.user);
            params.append('pageSize', 10);
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            fetch(ctx + '/api/admin/user/list?' + params.toString())
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        document.getElementById('userTable').innerHTML = res.data.list.map((u, i) => 
                            '<tr><td>' + ((currentPage.user - 1) * 10 + i + 1) + '</td><td><div class="avatar" style="width:32px;height:32px;font-size:14px;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;">' + (u.avatar ? '<img src="' + (u.avatar.startsWith("http")||u.avatar.startsWith("data:") ? u.avatar : ctx + "/images/avatars/" + u.avatar) + '" style="width:32px;height:32px;object-fit:cover;border-radius:50%;" onerror="handleAvatarImgError(this)">' : '👤') + '</div></td>' +
                            '<td>' + u.username + '</td><td>' + (u.realName || '-') + '</td><td>' + (u.phone || '-') + '</td>' +
                            '<td>' + (u.role === 1 ? '<span style="color:#fff;background:#dc3545;padding:2px 8px;border-radius:10px;font-size:12px;">管理员</span>' : '<span style="color:#fff;background:#6c757d;padding:2px 8px;border-radius:10px;font-size:12px;">普通用户</span>') + '</td>' +
                            '<td>' + (u.createTime ? u.createTime.substring(0,10) : '-') + '</td><td>' + (u.orderCount || 0) + '</td><td>' + (u.likeCount || 0) + '</td>' +
                            '<td><button class="btn btn-primary btn-sm" onclick="viewUserDetail(' + u.id + ')">详情</button> ' +
                            '<button class="btn btn-danger btn-sm" onclick="resetUserPassword(' + u.id + ')">重置密码</button> ' +
                            '<button class="btn btn-danger btn-sm" onclick="deleteUser(' + u.id + ',\'' + escapeHtml(u.username) + '\')">删除</button></td></tr>'
                        ).join('');
                        renderPagination('userPagination', res.data.total, currentPage.user, 10, loadUsers);
                    }
                });
        }
        function viewUserDetail(id) {
            fetch(ctx + '/api/admin/user/detail?id=' + id).then(r => r.json()).then(res => {
                if (res.code === 200) {
                    const u = res.data;
                    _userDetailContext = u.id;
                    const addrCount = (u.addresses && u.addresses.length) || 0;
                    const orderCount = (u.recentOrders && u.recentOrders.length) || 0;
                    document.getElementById('modalContent').innerHTML = 
                        '<h3 style="margin-bottom:24px;font-size:20px;">👤 用户详情</h3>' +
                        '<div style="background:#fafafa;border-radius:10px;padding:24px;margin-bottom:20px;">' +
                        '<div style="display:flex;align-items:center;gap:16px;margin-bottom:24px;padding-bottom:16px;border-bottom:1px solid #e8e8e8;">' +
                        '<div style="width:56px;height:56px;border-radius:50%;background:#e6f7ff;display:flex;align-items:center;justify-content:center;font-size:26px;flex-shrink:0;overflow:hidden;">' + (u.avatar ? '<img src="' + (u.avatar.startsWith("http")||u.avatar.startsWith("data:") ? u.avatar : ctx + "/images/avatars/" + u.avatar) + '" style="width:56px;height:56px;object-fit:cover;border-radius:50%;" onerror="handleAvatarImgError(this)">' : '👤') + '</div>' +
                        '<div><div style="font-weight:600;font-size:18px;">' + escapeHtml(u.username) + '</div><div style="font-size:14px;color:#999;margin-top:2px;">用户ID: ' + u.id + '</div></div>' +
                        '</div>' +
                        '<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px 20px;">' +
                        '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">用户名</label><input id="editUsername" value="' + escapeHtml(u.username || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                        '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">真实姓名</label><input id="editRealName" value="' + escapeHtml(u.realName || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                        '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">手机号</label><input id="editPhone" value="' + escapeHtml(u.phone || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                        '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">邮箱</label><input id="editEmail" value="' + escapeHtml(u.email || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                         '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">身份</label><select id="editRole" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;background:#fff;"><option value="0"' + (u.role === 1 ? '' : ' selected') + '>普通用户</option><option value="1"' + (u.role === 1 ? ' selected' : '') + '>管理员</option></select></div>' +
                        '</div>' +
                        '<div style="margin-top:20px;display:flex;gap:20px;font-size:14px;color:#999;">' +
                        '<span>📅 注册时间：' + (u.createTime ? u.createTime.substring(0, 16) : '-') + '</span>' +
                        '<span>📦 订单数：' + (u.orderCount || 0) + '</span>' +
                        '</div>' +
                        '</div>' +
                        '<div style="display:flex;gap:20px;">' +
                        '<div style="flex:1;background:#fafafa;border-radius:10px;padding:20px;display:flex;flex-direction:column;">' +
                        '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-shrink:0;">' +
                        '<h4 style="margin:0;font-size:16px;padding:0;border:none;">📍 收货地址' + (addrCount > 0 ? ' <span style="font-size:12px;color:#999;font-weight:400;">（共 ' + addrCount + ' 个）</span>' : '') + '</h4>' +
                        '<button type="button" style="padding:5px 14px;background:#1890ff;color:#fff;border:none;border-radius:6px;font-size:13px;cursor:pointer;white-space:nowrap;" onclick="showAddAddress(' + u.id + ')">+ 添加地址</button>' +
                        '</div>' +
                        '<div style="flex:1;overflow-y:auto;overflow-x:hidden;max-height:200px;min-height:0;">' +
                        (u.addresses && u.addresses.length > 0 ? u.addresses.map(function(a, idx) { return '' +
                            '<div style="padding:14px;margin-bottom:10px;border-radius:8px;background:' + (a.isDefault ? '#e6f7ff' : '#fff') + ';border:1px solid ' + (a.isDefault ? '#91d5ff' : '#e0e0e0') + ';font-size:14px;">' +
                            '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">' +
                            '<div style="font-weight:600;color:#333;font-size:15px;cursor:pointer;" onclick="' + (a.isDefault ? 'editUserAddress(' + u.id + ',' + a.id + ')' : 'setUserAddressDefault(' + u.id + ',' + a.id + ')') + '">' + escapeHtml(a.receiverName) + ' ' + escapeHtml(a.receiverPhone) + '</div>' +
                            (a.isDefault ? '<span style="background:#52c41a;color:#fff;font-size:12px;padding:2px 10px;border-radius:10px;font-weight:500;">默认</span>' : '') +
                            '</div>' +
                            '<div style="color:#666;line-height:1.6;word-break:break-all;font-size:13px;cursor:pointer;" onclick="' + (a.isDefault ? 'editUserAddress(' + u.id + ',' + a.id + ')' : 'setUserAddressDefault(' + u.id + ',' + a.id + ')') + '">📍 ' + escapeHtml(a.province) + escapeHtml(a.city) + escapeHtml(a.district) + ' ' + escapeHtml(a.address) + '</div>' +
                            '<div style="margin-top:8px;display:flex;gap:8px;"><button type="button" style="padding:4px 10px;font-size:12px;background:#fff;border:1px solid #ddd;color:#666;border-radius:4px;cursor:pointer;" onclick="event.stopPropagation();editUserAddress(' + u.id + ',' + a.id + ')">编辑</button><button type="button" style="padding:4px 10px;font-size:12px;background:#fff;border:1px solid #ff4d4f;color:#ff4d4f;border-radius:4px;cursor:pointer;" onclick="event.stopPropagation();deleteUserAddress(' + u.id + ',' + a.id + ')">删除</button></div>' +
                            '</div>'; }).join('') : '<p style="color:#999;font-size:14px;padding:8px 0;">暂无地址</p>') +
                        '</div>' +
                        '</div>' +
                        '<div style="flex:1;background:#fafafa;border-radius:10px;padding:20px;display:flex;flex-direction:column;">' +
                        '<h4 style="margin:0 0 16px;font-size:16px;padding:0;border:none;flex-shrink:0;">📋 最近订单' + (orderCount > 0 ? ' <span style="font-size:12px;color:#999;font-weight:400;">（共 ' + orderCount + ' 个）</span>' : '') + '</h4>' +
                        '<div style="flex:1;overflow-y:auto;overflow-x:hidden;max-height:200px;min-height:0;">' +
                        (u.recentOrders && u.recentOrders.length > 0 ? u.recentOrders.map(function(o) { return '' +
                            '<div style="padding:14px;margin-bottom:10px;border-radius:8px;background:#fff;border:1px solid #e0e0e0;font-size:14px;cursor:pointer;transition:box-shadow 0.2s;" onclick="viewOrderDetail(' + o.id + ')" onmouseover="toggleCardHoverOn(this)" onmouseout="toggleCardHoverOff(this)">' +
                            '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">' +
                            '<div style="font-family:monospace;font-size:12px;color:#999;">订单号：' + (o.orderNo || '-') + '</div>' +
                            '<span class="badge ' + getStatusBadge(o) + '" style="font-size:12px;">' + getStatusText(o) + '</span>' +
                            '</div>' +
                            (o.items && o.items.length > 0 ? '<div style="color:#666;font-size:13px;margin-bottom:8px;line-height:1.6;">' + o.items.map(function(item) { return '' +
                                '<span style="display:inline-block;background:#f5f5f5;padding:2px 8px;border-radius:4px;margin:2px 4px 2px 0;">' + escapeHtml(item.productName) + ' x' + item.quantity + '</span>'; }).join('') + '</div>' : '') +
                            '<div style="display:flex;justify-content:space-between;align-items:center;padding-top:6px;border-top:1px dashed #f0f0f0;">' +
                            '<span style="color:#ff4d4f;font-weight:600;font-size:16px;">¥' + Number(o.actualAmount || 0).toFixed(2) + '</span>' +
                            '<span style="color:#4facfe;font-size:12px;">查看详情 →</span>' +
                            '</div>' +
                            '</div>'; }).join('') : '<p style="color:#999;font-size:14px;padding:8px 0;">暂无订单</p>') +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="modal-actions" style="margin-top:24px;">' +
                        '<button class="btn btn-primary" onclick="saveUserDetail(' + u.id + ')" style="padding:8px 20px;font-size:14px;">保存修改</button>' +
                        '<button class="btn" onclick="_userDetailContext=null;closeModal()" style="padding:8px 20px;font-size:14px;">关闭</button>' +
                        '</div>';
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = 'visible';
                    mc.style.maxHeight = 'none';
                    document.getElementById('modalOverlay').classList.add('show');
                } else {
                    alert('加载失败: ' + res.message);
                }
            }).catch(function(err) {
                alert('请求失败: ' + err.message);
            });
        }
        function saveUserDetail(id) {
            const formData = new URLSearchParams();
            formData.append('id', id);
            formData.append('username', document.getElementById('editUsername').value);
            formData.append('realName', document.getElementById('editRealName').value);
            formData.append('phone', document.getElementById('editPhone').value);
            formData.append('email', document.getElementById('editEmail').value);
            formData.append('role', document.getElementById('editRole').value);
            fetch(ctx + '/api/admin/user/update', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            }).then(r => r.json()).then(res => {
                alert(res.message);
                if (res.code === 200) { closeModal(); loadUsers(); }
            });
        }
        function resetUserPassword(id) {
            if (!confirm('确定重置该用户密码为默认密码？')) return;
            fetch(ctx + '/api/admin/user/resetPassword?id=' + id, { method: 'POST' }).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadUsers();
            });
        }
        function buildRatingStars(rating) {
            var r = rating || 0;
            var html = '<span style="color:#faad14;letter-spacing:1px;">';
            for (var si = 0; si < r; si++) html += '★';
            for (var si = r; si < 5; si++) html += '<span style="color:#d9d9d9;">★</span>';
            html += '</span>';
            return html;
        }
        function exportUsers() {
            var a = document.createElement('a');
            a.href = ctx + '/api/admin/user/export';
            a.download = 'users.csv';
            a.style.display = 'none';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
        function showAddUserModal() {
            document.getElementById('modalContent').innerHTML =
                '<h3 style="margin-bottom:24px;font-size:20px;">➕ 添加用户</h3>' +
                '<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px 20px;">' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">用户名 *</label><input id="addUsername" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">密码 *</label><input id="addPassword" type="password" placeholder="请输入密码" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">真实姓名 *</label><input id="addRealName" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">手机号 *</label><input id="addPhone" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div style="grid-column:span 2;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">邮箱 *</label><input id="addEmail" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div style="grid-column:span 2;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">身 份</label><select id="addRole" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="0">普通用户</option><option value="1">管理员</option></select></div>' +
                '</div>' +
                '<div class="modal-actions" style="margin-top:24px;">' +
                '<button class="btn btn-primary" onclick="addUser()" style="padding:8px 20px;font-size:14px;">添加</button>' +
                '<button class="btn" onclick="closeModal()" style="padding:8px 20px;font-size:14px;">取消</button>' +
                '</div>';
            document.getElementById('modalOverlay').classList.add('show');
        }
        function addUser() {
            const username = document.getElementById('addUsername').value.trim();
            const password = document.getElementById('addPassword').value.trim();
            const realName = document.getElementById('addRealName').value.trim();
            const phone = document.getElementById('addPhone').value.trim();
            const email = document.getElementById('addEmail').value.trim();
            const role = document.getElementById('addRole').value;
            if (!username) { alert('请输入用户名'); return; }
            if (!password) { alert('请输入密码'); return; }
            if (!realName) { alert('请输入真实姓名'); return; }
            if (!phone) { alert('请输入手机号'); return; }
            if (!email) { alert('请输入邮箱'); return; }
            const formData = new URLSearchParams();
            formData.append('username', username);
            formData.append('password', password);
            formData.append('realName', realName);
            formData.append('phone', phone);
            formData.append('email', email);
            formData.append('role', role);
            fetch(ctx + '/api/admin/user/add', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            }).then(r => r.json()).then(res => {
                alert(res.message);
                if (res.code === 200) { closeModal(); loadUsers(); }
            });
        }
        function deleteUser(id, username) {
            if (!confirm('确定删除用户 "' + username + '" 吗？此操作不可恢复！')) return;
    // 判断是否是当前页的最后一条记录
    const currentRows = document.querySelectorAll('#userTable tr');
    const isLastOnPage = currentRows.length === 1;
    if (isLastOnPage && currentPage.user > 1) currentPage.user = currentPage.user - 1;
            fetch(ctx + '/api/admin/user/delete?id=' + id, { method: 'POST' }).then(r => r.json()).then(res => {
                alert(res.message); if (res.code === 200) loadUsers();
            });
        }

        // ==================== 订单管理 ====================
        function loadOrders(page) {
            if (page) currentPage.order = page;
            const params = new URLSearchParams();
            params.append('page', currentPage.order);
            params.append('pageSize', 10);
            const kw = document.getElementById('orderSearch').value;
            const status = document.getElementById('orderStatusFilter').value;
            const from = document.getElementById('orderDateFrom').value;
            const to = document.getElementById('orderDateTo').value;
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            if (status) params.append('status', status);
            if (from) params.append('dateFrom', from);
            if (to) params.append('dateTo', to);
            const url = ctx + '/api/admin/order/list?' + params.toString();
            fetch(url)
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        const list = res.data.list || [];
                        document.getElementById('orderTable').innerHTML = list.length === 0
                            ? '<tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">暂无订单数据</td></tr>'
                            : list.map(o => 
                                '<tr><td>' + o.orderNo + '</td><td>' + (o.username || '-') + '</td>' +
                                '<td>¥' + (o.actualAmount || 0).toFixed(2) + '</td>' +
                                '<td><span class="badge ' + getStatusBadge(o) + '">' + getStatusText(o) + '</span></td>' +
                                '<td>' + getPaymentMethod(o.paymentMethod) + '</td>' +
                                '<td>' + (o.createTime ? formatTime(o.createTime) : '-') + '</td>' +
                                '<td style="white-space:nowrap;padding-right:16px;"><div style="display:flex;gap:3px;align-items:center;min-width:175px;">' +
                                '<button class="btn btn-primary btn-xs" style="margin:0;flex:1;min-width:0;" onclick="viewOrderDetail(' + o.id + ')">详情</button>' +
                                getOrderActions(o) +
                                '</div></td></tr>'
                            ).join('');
                        renderPagination('orderPagination', res.data.total, currentPage.order, 10, loadOrders);
                    } else {
                        // 不将后端错误消息直接渲染到页面
                        document.getElementById('orderTable').innerHTML = '<tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">暂无订单数据</td></tr>';
                    }
                }).catch(e => {
                    // 不将异常信息显示到页面
                    document.getElementById('orderTable').innerHTML = '<tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">暂无订单数据</td></tr>';
                });
        }
        function getOrderActions(o) {
            let html = '';
            if (o.status === 1) html += '<button class="btn btn-warning btn-xs" style="margin:0;flex:1;min-width:0;" onclick="shipOrder(' + o.id + ')">发货</button>';
            if (o.status === 5) html += '<button class="btn btn-success btn-xs" style="margin:0;flex:1;min-width:0;" onclick="refundOrder(' + o.id + ')">同意退款</button>';
            html += '<button class="btn btn-danger btn-xs" style="margin:0;flex:1;min-width:0;" onclick="addOrderRemark(' + o.id + ')">备注</button>';
            return html;
        }
        function viewOrderDetail(id) {
            fetch(ctx + '/api/order/detail?id=' + id).then(r => r.json()).then(res => {
                if (res.code === 200) {
                    const o = res.data;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = 'auto';
                    mc.style.maxHeight = '85vh';
                    const avatarHtml = (o.avatar && String(o.avatar).trim() !== '')
                        ? '<img src="' + (String(o.avatar).startsWith('http') || String(o.avatar).startsWith('data:') ? o.avatar : (ctx + '/images/avatars/' + o.avatar)) + '" style="width:48px;height:48px;object-fit:cover;border-radius:50%;" onerror="handleOrderAvatarError(this)">'
                        : '👤';
                    document.getElementById('modalContent').innerHTML = 
                        '<h3 style="margin-bottom:24px;font-size:20px;">📋 订单详情 - ' + o.orderNo + '</h3>' +
                        '<div style="background:#fafafa;border-radius:10px;padding:24px;margin-bottom:20px;">' +
                        '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid #e8e8e8;">' +
                        '<div style="display:flex;align-items:center;gap:12px;">' +
                        '<div style="width:48px;height:48px;border-radius:50%;background:#e6f7ff;display:flex;align-items:center;justify-content:center;font-size:22px;overflow:hidden;">' + avatarHtml + '</div>' +
                        '<div>' +
                        '<div style="font-weight:600;font-size:16px;color:#333;">' + (o.username || '用户') + '</div>' +
                        '<div style="font-size:13px;color:#999;margin-top:2px;">订单号：' + o.orderNo + '</div>' +
                        '</div>' +
                        '</div>' +
                        '<span class="badge ' + getStatusBadge(o) + '" style="font-size:14px;padding:6px 14px;">' + getStatusText(o) + '</span>' +
                        '</div>' +
                        '<div style="display:grid;grid-template-columns:1fr 1fr;gap:14px 24px;">' +
                        '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">支付方式</label><span style="font-size:15px;color:#333;">' + getPaymentMethod(o.paymentMethod) + '</span></div>' +
                        '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">支付时间</label><span style="font-size:15px;color:#333;">' + (o.paymentTime ? formatTime(o.paymentTime) : '未支付') + '</span></div>' +
                        '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">创建时间</label><span style="font-size:15px;color:#333;">' + (o.createTime ? formatTime(o.createTime) : '-') + '</span></div>' +
                        (o.deliveryTime ? '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">发货时间</label><span style="font-size:15px;color:#333;">' + formatTime(o.deliveryTime) + '</span></div>' : '') +
                        (o.finishTime ? '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">完成时间</label><span style="font-size:15px;color:#333;">' + formatTime(o.finishTime) + '</span></div>' : '') +
                        '</div>' +
                        '</div>' +
                        '<div style="display:flex;gap:16px;margin-bottom:20px;">' +
                        '<div style="flex:1;background:#fafafa;border-radius:10px;padding:20px;">' +
                        '<h4 style="margin:0 0 14px;font-size:16px;padding:0;border:none;">📍 收货信息</h4>' +
                        '<div style="font-size:14px;color:#333;line-height:1.8;">' +
                        '<div style="font-weight:500;margin-bottom:6px;">' + (o.receiverName || '-') + ' ' + (o.receiverPhone || '') + '</div>' +
                        '<div style="color:#666;">' + (o.receiverProvince || '') + (o.receiverCity || '') + (o.receiverDistrict || '') + ' ' + (o.receiverAddress || '') + '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div style="flex:1;background:#fafafa;border-radius:10px;padding:20px;">' +
                        '<h4 style="margin:0 0 14px;font-size:16px;padding:0;border:none;">💰 金额明细</h4>' +
                        '<div style="font-size:14px;line-height:2;">' +
                        '<div style="display:flex;justify-content:space-between;"><span style="color:#666;">商品总额</span><span>¥' + (o.totalAmount || 0).toFixed(2) + '</span></div>' +
                        '<div style="display:flex;justify-content:space-between;"><span style="color:#666;">优惠金额</span><span style="color:#52c41a;">-¥' + (o.discountAmount || 0).toFixed(2) + '</span></div>' +
                        '<div style="display:flex;justify-content:space-between;border-top:1px solid #e8e8e8;padding-top:8px;margin-top:4px;font-weight:600;font-size:16px;">' +
                        '<span>实付金额</span><span style="color:#ff4d4f;">¥' + (o.actualAmount || 0).toFixed(2) + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        ((((o.status === 5 || o.status === 6) && o.refundReason) || (o.status === 4 && (o.cancelReason || o.refundReason))) ? 
                            '<div style="background:#fff1f0;border-radius:10px;padding:20px;margin-bottom:20px;border-left:3px solid #ff4d4f;">' +
                            '<h4 style="margin:0 0 10px;font-size:16px;">💱 退款信息</h4>' +
                            '<div style="font-size:14px;color:#333;line-height:1.8;">' +
                            (o.refundReason ? '退款原因：' + o.refundReason : '') +
                            ((o.status === 4 && o.cancelReason) ? (o.refundReason ? '<br/>' : '') + '取消原因：' + o.cancelReason : '') +
                            (o.refundCompleteTime ? '<br/>退款完成时间：' + formatTime(o.refundCompleteTime) : '') +
                            '</div></div>' : '') +
                        (o.deliveryCompany ? '<div style="background:#fafafa;border-radius:10px;padding:20px;margin-bottom:20px;">' +
                        '<h4 style="margin:0 0 14px;font-size:16px;padding:0;border:none;">🚚 物流信息</h4>' +
                        '<div style="display:flex;gap:24px;font-size:14px;">' +
                        '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">物流公司</label><span style="color:#333;">' + o.deliveryCompany + '</span></div>' +
                        '<div><label style="font-size:13px;color:#999;display:block;margin-bottom:4px;">物流单号</label><span style="color:#333;font-family:monospace;">' + o.deliveryNo + '</span></div>' +
                        '</div></div>' : '') +
                        (o.remark ? '<div style="background:#fffbe6;border-radius:10px;padding:16px 20px;margin-bottom:20px;border-left:3px solid #faad14;">' +
                            '<div style="font-size:13px;color:#999;margin-bottom:4px;">📝 用户备注</div>' +
                            '<div style="font-size:14px;color:#333;">' + o.remark + '</div></div>' : '') +
                        (o.adminRemark ? '<div style="background:#e6f7ff;border-radius:10px;padding:16px 20px;margin-bottom:20px;border-left:3px solid #1890ff;">' +
                            '<div style="font-size:13px;color:#999;margin-bottom:4px;">📝 管理员备注</div>' +
                            '<div style="font-size:14px;color:#333;">' + o.adminRemark + '</div></div>' : '') +
                        ((o.comments && o.comments.length > 0) ? 
                            '<div style="background:#fff7e6;border-radius:10px;padding:20px;margin-bottom:20px;border-left:3px solid #fa8c16;">' +
                            '<h4 style="margin:0 0 14px;font-size:16px;padding:0;border:none;">⭐ 用户评价</h4>' +
                            '<div style="max-height:240px;overflow-y:auto;">' +
                            o.comments.map(function(c) {
                                var isEval = c.orderId && c.rating && c.rating > 0;
                                var innerStars = isEval ? buildRatingStars(c.rating) + '<span class="badge badge-info" style="margin-left:8px;font-size:12px;background:#fff3e0;color:#ff9800;border:none;padding:2px 8px;">评价</span>' : '<span class="badge badge-default" style="font-size:12px;background:#e3f2fd;color:#1976d2;border:none;padding:2px 8px;">评论</span>';
                                return '' +
                                    '<div style="padding:14px;margin-bottom:10px;border-radius:8px;background:#fff;font-size:14px;">' +
                                    '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">' +
                                    '<div style="font-weight:500;color:#333;">' + (c.isAnonymous ? '匿名用户' : (c.username || '用户')) + '</div>' +
                                    '<div style="font-size:12px;color:#999;">' + (c.createTime ? formatTime(c.createTime) : '') + '</div>' +
                                    '</div>' +
                                    (c.productName ? '<div style="font-size:12px;color:#999;margin-bottom:6px;">商品：' + c.productName + '</div>' : '') +
                                    '<div style="font-size:14px;margin-bottom:6px;">' + innerStars + '</div>' +
                                    '<div style="font-size:14px;color:#333;line-height:1.6;">' + (c.content || '') + '</div>' +
                                    (c.replyContent ? '<div style="margin-top:10px;padding:10px 12px;background:#f0f0f0;border-radius:6px;"><div style="font-size:12px;color:#999;margin-bottom:4px;">管理员回复：</div><div style="font-size:13px;color:#333;">' + c.replyContent + '</div></div>' : '') +
                                    '</div>';
                            }).join('') +
                            '</div></div>' : '') +
                        '<div style="background:#fafafa;border-radius:10px;padding:20px;margin-bottom:20px;">' +
                        '<h4 style="margin:0 0 14px;font-size:16px;padding:0;border:none;">🛒 商品列表</h4>' +
                        (o.items && o.items.length > 0 ? 
                        '<div style="max-height:220px;overflow-y:auto;">' +
                        o.items.map(function(i) { return '' +
                            '<div style="display:flex;align-items:center;justify-content:space-between;padding:10px 12px;background:#fff;border-radius:8px;margin-bottom:8px;">' +
                            '<div style="flex:1;font-size:14px;color:#333;">' + (i.productName || '商品') + '</div>' +
                            '<div style="color:#999;font-size:13px;margin:0 16px;">x' + i.quantity + '</div>' +
                            '<div style="font-size:14px;font-weight:500;color:#ff4d4f;">¥' + (i.price || 0).toFixed(2) + '</div>' +
                            '</div>'; }).join('') + '</div>' :
                        '<p style="color:#999;font-size:14px;padding:8px 0;">暂无商品</p>') +
                        '</div>' +
                        '<div class="modal-actions" style="margin-top:24px;">' +
                        '<button class="btn" onclick="if(_userDetailContext){viewUserDetail(_userDetailContext)}else{closeModal()}" style="padding:8px 20px;font-size:14px;">' + (_userDetailContext ? '返回用户详情' : '关闭') + '</button>' +
                        '</div>';
                    document.getElementById('modalOverlay').classList.add('show');
                } else {
                    alert('加载失败: ' + res.message);
                }
            }).catch(function(err) {
                alert('请求失败: ' + err.message);
            });
        }
        function shipOrder(id) {
            const company = prompt('物流公司：');
            const no = prompt('物流单号：');
            if (!company || !no) return;
            fetch(ctx + '/api/admin/order/ship', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id + '&deliveryCompany=' + encodeURIComponent(company) + '&deliveryNo=' + encodeURIComponent(no)
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadOrders(); });
        }
        function refundOrder(id) {
            if (!confirm('确定同意退款？')) return;
            fetch(ctx + '/api/admin/order/refund', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadOrders(); });
        }
        function addOrderRemark(id) {
            const remark = prompt('请输入备注：');
            if (!remark) return;
            fetch(ctx + '/api/admin/order/remark', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id + '&remark=' + encodeURIComponent(remark)
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) loadOrders(); });
        }

        function getStatusText(o) { 
            var s = (typeof o === 'object') ? o.status : o; 
            if (typeof o === 'object' && s === 0 && o.createTime) {
                var ct = typeof o.createTime === 'string' ? o.createTime.replace(' ', 'T') : o.createTime;
                if (Date.now() - new Date(ct).getTime() > 20 * 60 * 1000) return '已超时';
                return '未支付';
            }
            return ['未支付','未发货','已发货','已完成','已取消','退款中','已退款','已超时'][s] || '未知'; 
        }
        function getStatusBadge(o) { 
            var s = (typeof o === 'object') ? o.status : o; 
            if (typeof o === 'object' && s === 0 && o.createTime) {
                var ct = typeof o.createTime === 'string' ? o.createTime.replace(' ', 'T') : o.createTime;
                if (Date.now() - new Date(ct).getTime() > 20 * 60 * 1000) return 'badge-danger';
                return 'badge-warning';
            }
            return ['badge-warning','badge-warning','badge-info','badge-success','badge-danger','badge-warning','badge-danger','badge-dark'][s] || ''; 
        }
        function getPaymentMethod(m) { return ['','支付宝','微信','银行卡'][m] || '未知'; }

        // ==================== 数据统计 ====================
        function loadStats() {
            fetch(ctx + '/api/admin/stats/overview').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    const d = res.data;
                    document.getElementById('statsOverview').innerHTML = 
                        '<div class="stat-card blue clickable" onclick="showSalesDetail(\'today\')"><div class="stat-value">¥' + (d.todaySales || 0).toFixed(2) + '</div><div class="stat-label">今日销售额</div></div>' +
                        '<div class="stat-card green clickable" onclick="showSalesDetail(\'week\')"><div class="stat-value">¥' + (d.weekSales || 0).toFixed(2) + '</div><div class="stat-label">本周销售额</div></div>' +
                        '<div class="stat-card orange clickable" onclick="showSalesDetail(\'month\')"><div class="stat-value">¥' + (d.monthSales || 0).toFixed(2) + '</div><div class="stat-label">本月销售额</div></div>' +
                        '<div class="stat-card purple clickable" onclick="showNewUsers()"><div class="stat-value">' + (d.newUsers || 0) + '</div><div class="stat-label">本月新增用户</div></div>';
                }
            });
            fetch(ctx + '/api/admin/stats/daily').then(r => r.json()).then(res => {
                if (res.code === 200 && res.data) {
                    const maxVal = Math.max(...res.data.map(s => s.amount), 1);
                    document.getElementById('dailySalesChart').innerHTML = res.data.map(s => {
                        const h = (s.amount / maxVal * 200) || 2;
                        return '<div style="flex:1;text-align:center;min-width:20px;cursor:pointer;" onclick="showDaySalesDetail(\'' + s.date + '\')"><div style="background:linear-gradient(180deg,#fa709a,#fee140);height:' + h + 'px;border-radius:4px 4px 0 0;margin:0 2px;position:relative;" title="¥' + s.amount.toFixed(2) + '"><span style="position:absolute;top:-18px;left:50%;transform:translateX(-50%);font-size:10px;color:#666;white-space:nowrap;">¥' + s.amount.toFixed(0) + '</span></div><div style="font-size:11px;color:#999;margin-top:4px;">' + s.date.substring(5) + '</div></div>';
                    }).join('');
                }
            });
            fetch(ctx + '/api/admin/stats/monthly').then(r => r.json()).then(res => {
                if (res.code === 200 && res.data) {
                    const maxVal = Math.max(...res.data.map(s => s.amount), 1);
                    document.getElementById('monthlySalesChart').innerHTML = res.data.map(s => {
                        const h = (s.amount / maxVal * 200) || 2;
                        return '<div style="flex:1;text-align:center;min-width:40px;cursor:pointer;" onclick="showMonthSalesDetail(\'' + s.month + '\')"><div style="background:linear-gradient(180deg,#a18cd1,#fbc2eb);height:' + h + 'px;border-radius:4px 4px 0 0;margin:0 2px;position:relative;" title="¥' + s.amount.toFixed(2) + '"><span style="position:absolute;top:-18px;left:50%;transform:translateX(-50%);font-size:10px;color:#666;white-space:nowrap;">¥' + s.amount.toFixed(0) + '</span></div><div style="font-size:11px;color:#999;margin-top:4px;">' + s.month + '</div></div>';
                    }).join('');
                }
            });
            fetch(ctx + '/api/admin/stats/topProducts').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    document.getElementById('topProducts').innerHTML = res.data.map((p,i) => 
                        '<div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #f5f5f5;"><span>' + (i+1) + '. ' + p.name + '</span><span style="color:#fa709a;">销量: ' + p.salesCount + '</span></div>'
                    ).join('');
                }
            });
            fetch(ctx + '/api/admin/stats/userStats').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    const d = res.data;
                    document.getElementById('userStats').innerHTML = 
                        '<p>新增用户(本月): <b>' + (d.newUsers || 0) + '</b></p>' +
                        '<p>活跃用户: <b>' + (d.activeUsers || 0) + '</b></p>' +
                        '<p>复购率: <b>' + ((d.repurchaseRate || 0) * 100).toFixed(1) + '%</b></p>';
                }
            });
        }

        function showSalesDetail(type) {
            var titles = { today: '今日', week: '本周', month: '本月' };
            var title = titles[type] || '';
            fetch(ctx + '/api/admin/stats/' + type + 'Detail').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    var d = res.data;
                    var html = '<h3 style="margin-bottom:20px;">📋 ' + title + '销售详情</h3>';
                    html += '<div style="background:#f0f7ff;border-radius:8px;padding:16px;margin-bottom:20px;text-align:center;">';
                    html += '<span style="font-size:14px;color:#666;">' + title + '总销售额</span>';
                    html += '<div style="font-size:28px;font-weight:700;color:#1890ff;margin-top:4px;">¥' + (d.totalSales || 0).toFixed(2) + '</div>';
                    html += '</div>';
                    if (d.items && d.items.length > 0) {
                        html += '<table style="font-size:14px;"><thead><tr><th>商品名称</th><th style="text-align:center;">销量</th><th style="text-align:right;">销售额</th></tr></thead><tbody>';
                        d.items.forEach(function(item) {
                            html += '<tr><td>' + escapeHtml(item.productName) + '</td><td style="text-align:center;">' + item.quantity + '</td><td style="text-align:right;">¥' + (item.amount || 0).toFixed(2) + '</td></tr>';
                        });
                        html += '</tbody></table>';
                    } else {
                        html += '<div class="empty-state">暂无销售数据</div>';
                    }
                    html += '<div class="modal-actions"><button class="btn" onclick="closeModal()">关闭</button></div>';
                    document.getElementById('modalContent').innerHTML = html;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = '';
                    mc.style.maxHeight = '';
                    document.getElementById('modalOverlay').classList.add('show');
                }
            });
        }

        function showNewUsers() {
            fetch(ctx + '/api/admin/stats/newUsers').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    var d = res.data;
                    var html = '<h3 style="margin-bottom:20px;">📋 本月新增用户详情</h3>';
                    html += '<div style="background:#f0f7ff;border-radius:8px;padding:16px;margin-bottom:20px;text-align:center;">';
                    html += '<span style="font-size:14px;color:#666;">本月新增用户总数</span>';
                    html += '<div style="font-size:28px;font-weight:700;color:#722ed1;margin-top:4px;">' + (d.total || 0) + ' 人</div>';
                    html += '</div>';
                    if (d.users && d.users.length > 0) {
                        html += '<table style="font-size:14px;"><thead><tr><th>用户名</th><th>手机号</th><th>邮箱</th><th>注册时间</th></tr></thead><tbody>';
                        d.users.forEach(function(u) {
                            var ct = u.createTime || '-';
                            if (ct && ct !== '-' && ct.indexOf('.') > -1) ct = ct.substring(0, ct.indexOf('.'));
                            html += '<tr><td>' + escapeHtml(u.username) + '</td><td>' + (u.phone || '-') + '</td><td>' + (u.email || '-') + '</td><td>' + ct + '</td></tr>';
                        });
                        html += '</tbody></table>';
                    } else {
                        html += '<div class="empty-state">本月暂无新增用户</div>';
                    }
                    html += '<div class="modal-actions"><button class="btn" onclick="closeModal()">关闭</button></div>';
                    document.getElementById('modalContent').innerHTML = html;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = '';
                    mc.style.maxHeight = '';
                    document.getElementById('modalOverlay').classList.add('show');
                }
            });
        }

        function showTotalSalesDetail() {
            fetch(ctx + '/api/admin/stats/totalDetail').then(r => r.json()).then(res => {
                if (res.code === 200) {
                    var d = res.data;
                    var html = '<h3 style="margin-bottom:20px;">📋 全部销售详情</h3>';
                    html += '<div style="background:#f0f7ff;border-radius:8px;padding:16px;margin-bottom:20px;text-align:center;">';
                    html += '<span style="font-size:14px;color:#666;">历史总销售额</span>';
                    html += '<div style="font-size:28px;font-weight:700;color:#1890ff;margin-top:4px;">¥' + (d.totalSales || 0).toFixed(2) + '</div>';
                    html += '</div>';
                    if (d.items && d.items.length > 0) {
                        html += '<table style="font-size:14px;"><thead><tr><th>商品名称</th><th style="text-align:center;">总销量</th><th style="text-align:right;">总销售额</th></tr></thead><tbody>';
                        d.items.forEach(function(item) {
                            html += '<tr><td>' + escapeHtml(item.productName) + '</td><td style="text-align:center;">' + item.quantity + '</td><td style="text-align:right;">¥' + (item.amount || 0).toFixed(2) + '</td></tr>';
                        });
                        html += '</tbody></table>';
                    } else {
                        html += '<div class="empty-state">暂无销售数据</div>';
                    }
                    html += '<div class="modal-actions"><button class="btn" onclick="closeModal()">关闭</button></div>';
                    document.getElementById('modalContent').innerHTML = html;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = '';
                    mc.style.maxHeight = '';
                    document.getElementById('modalOverlay').classList.add('show');
                }
            });
        }

        function showDaySalesDetail(date) {
            fetch(ctx + '/api/admin/stats/daySalesDetail?date=' + encodeURIComponent(date)).then(r => r.json()).then(res => {
                if (res.code === 200) {
                    var d = res.data;
                    var html = '<h3 style="margin-bottom:20px;">📋 ' + (d.date || date) + ' 销售详情</h3>';
                    html += '<div style="background:#f0f7ff;border-radius:8px;padding:16px;margin-bottom:20px;text-align:center;">';
                    html += '<span style="font-size:14px;color:#666;">当日总销售额</span>';
                    html += '<div style="font-size:28px;font-weight:700;color:#fa709a;margin-top:4px;">¥' + (d.totalSales || 0).toFixed(2) + '</div>';
                    html += '</div>';
                    if (d.items && d.items.length > 0) {
                        html += '<table style="font-size:14px;"><thead><tr><th>商品名称</th><th style="text-align:center;">销量</th><th style="text-align:right;">销售额</th></tr></thead><tbody>';
                        d.items.forEach(function(item) {
                            html += '<tr><td>' + escapeHtml(item.productName) + '</td><td style="text-align:center;">' + item.quantity + '</td><td style="text-align:right;">¥' + (item.amount || 0).toFixed(2) + '</td></tr>';
                        });
                        html += '</tbody></table>';
                    } else {
                        html += '<div class="empty-state">当日暂无销售数据</div>';
                    }
                    html += '<div class="modal-actions"><button class="btn" onclick="closeModal()">关闭</button></div>';
                    document.getElementById('modalContent').innerHTML = html;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = '';
                    mc.style.maxHeight = '';
                    document.getElementById('modalOverlay').classList.add('show');
                }
            });
        }

        function showMonthSalesDetail(month) {
            fetch(ctx + '/api/admin/stats/monthSalesDetail?month=' + encodeURIComponent(month)).then(r => r.json()).then(res => {
                if (res.code === 200) {
                    var d = res.data;
                    var html = '<h3 style="margin-bottom:20px;">📋 ' + (d.month || month) + ' 销售详情</h3>';
                    html += '<div style="background:#f0f7ff;border-radius:8px;padding:16px;margin-bottom:20px;text-align:center;">';
                    html += '<span style="font-size:14px;color:#666;">当月总销售额</span>';
                    html += '<div style="font-size:28px;font-weight:700;color:#a18cd1;margin-top:4px;">¥' + (d.totalSales || 0).toFixed(2) + '</div>';
                    html += '</div>';
                    if (d.items && d.items.length > 0) {
                        html += '<table style="font-size:14px;"><thead><tr><th>商品名称</th><th style="text-align:center;">销量</th><th style="text-align:right;">销售额</th></tr></thead><tbody>';
                        d.items.forEach(function(item) {
                            html += '<tr><td>' + escapeHtml(item.productName) + '</td><td style="text-align:center;">' + item.quantity + '</td><td style="text-align:right;">¥' + (item.amount || 0).toFixed(2) + '</td></tr>';
                        });
                        html += '</tbody></table>';
                    } else {
                        html += '<div class="empty-state">当月暂无销售数据</div>';
                    }
                    html += '<div class="modal-actions"><button class="btn" onclick="closeModal()">关闭</button></div>';
                    document.getElementById('modalContent').innerHTML = html;
                    var mc = document.getElementById('modalContent');
                    mc.style.overflowY = '';
                    mc.style.maxHeight = '';
                    document.getElementById('modalOverlay').classList.add('show');
                }
            });
        }

        // ==================== 个人资料 ====================
        function loadProfile() {
            fetch(ctx + '/api/user/detail?_=' + Date.now()).then(r => r.json()).then(res => {
                if (res.code === 200) {
                    const u = res.data;
                    document.getElementById('profileUsername').value = u.username || '';
                    document.getElementById('profileRealName').value = u.realName || '';
                    document.getElementById('profilePhone').value = u.phone || '';
                    document.getElementById('profileEmail').value = u.email || '';
                    if (u.avatar && u.avatar.trim() !== '') {
                        const avatarStr = String(u.avatar);
                        const avatarUrl = avatarStr.startsWith('http') || avatarStr.startsWith('data:') ? avatarStr : ctx + '/images/avatars/' + avatarStr;
                        var img = '<img src="' + avatarUrl + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="handleHeaderAvatarError(this)">';
                        document.getElementById('profileAvatar').innerHTML = img;
                        document.getElementById('headerAvatar').innerHTML = img;
                    } else {
                        document.getElementById('profileAvatar').innerHTML = '<span id="profileAvatarText">👤</span>';
                        document.getElementById('headerAvatar').innerHTML = '<span id="headerAvatarText">👤</span>';
                    }
                } else {
                    alert('加载个人资料失败：' + (res.message || '未知错误'));
                }
            }).catch(function(e) {
                alert('加载个人资料失败：' + e.message);
            });
        }
        function updateProfile() {
            const params = new URLSearchParams();
            params.append('username', document.getElementById('profileUsername').value);
            params.append('realName', document.getElementById('profileRealName').value);
            params.append('phone', document.getElementById('profilePhone').value);
            params.append('email', document.getElementById('profileEmail').value);
            fetch(ctx + '/api/user/update', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString()
            }).then(r => r.json()).then(res => alert(res.message));
        }
        function uploadAvatar(input) {
            const file = input.files[0];
            if (!file) return;
            const formData = new FormData();
            formData.append('avatar', file);
            fetch(ctx + '/api/user/uploadAvatar', { method: 'POST', body: formData })
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        const avatarUrl = ctx + '/images/avatars/' + res.data;
                        var imgHtml = '<img src="' + avatarUrl + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="handleHeaderAvatarError(this)">';
                        document.getElementById('profileAvatar').innerHTML = imgHtml;
                        document.getElementById('headerAvatar').innerHTML = imgHtml;
                        alert('头像更新成功');
                    } else alert(res.message || '头像更新失败');
                }).catch(function(e) {
                    alert('头像上传失败：' + e.message);
                });
        }
        function changePassword() {
            const oldPwd = document.getElementById('oldPassword').value;
            const newPwd = document.getElementById('newPassword').value;
            const confirmPwd = document.getElementById('confirmPassword').value;
            if (!oldPwd || !newPwd) { alert('请填写密码'); return; }
            if (newPwd !== confirmPwd) { alert('两次密码不一致'); return; }
            fetch(ctx + '/api/user/changePassword', {
                method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'oldPassword=' + encodeURIComponent(oldPwd) + '&newPassword=' + encodeURIComponent(newPwd)
            }).then(r => r.json()).then(res => { alert(res.message); if (res.code === 200) { document.getElementById('oldPassword').value = ''; document.getElementById('newPassword').value = ''; document.getElementById('confirmPassword').value = ''; } });
        }

        // ==================== 日志管理 ====================
        function loadLogs() {
            const kw = document.getElementById('logSearch').value;
            const from = document.getElementById('logDateFrom').value;
            const to = document.getElementById('logDateTo').value;
            const params = new URLSearchParams();
            if (kw) params.append('keyword', kw);
    const roleVal = document.getElementById('userRoleFilter').value;
    if (roleVal !== '' && roleVal !== undefined) params.append('role', roleVal);
            if (from) params.append('dateFrom', from);
            if (to) params.append('dateTo', to);
            fetch(ctx + '/api/admin/logs/list?' + params.toString())
                .then(r => r.json()).then(res => {
                    if (res.code === 200) {
                        document.getElementById('logList').innerHTML = res.data.length > 0 ?
                            res.data.map(l => '<div class="log-entry"><span class="time">' + l.createTime + '</span> [' + l.type + '] ' + l.adminName + ' - ' + l.content + '</div>').join('') :
                            '<div class="empty-state">暂无日志记录</div>';
                    }
                });
        }

        let _currentEditUserId = null;
        const _userRegionData = {
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

        function _userAddrInitProvinces(selectedProvince) {
            const el = document.getElementById('userAddrProvince');
            if (!el) return;
            el.innerHTML = '<option value="">请选择省份</option>';
            Object.keys(_userRegionData).forEach(function(province) {
                const opt = document.createElement('option');
                opt.value = province;
                opt.textContent = province;
                if (province === selectedProvince) opt.selected = true;
                el.appendChild(opt);
            });
        }
        function _userAddrLoadCities(selectedCity) {
            const province = document.getElementById('userAddrProvince').value;
            const cityEl = document.getElementById('userAddrCity');
            const distEl = document.getElementById('userAddrDistrict');
            cityEl.innerHTML = '<option value="">请选择城市</option>';
            distEl.innerHTML = '<option value="">请选择区县</option>';
            if (province && _userRegionData[province]) {
                Object.keys(_userRegionData[province]).forEach(function(city) {
                    const opt = document.createElement('option');
                    opt.value = city;
                    opt.textContent = city;
                    if (city === selectedCity) opt.selected = true;
                    cityEl.appendChild(opt);
                });
            }
        }
        function _userAddrLoadDistricts(selectedDistrict) {
            const province = document.getElementById('userAddrProvince').value;
            const city = document.getElementById('userAddrCity').value;
            const distEl = document.getElementById('userAddrDistrict');
            distEl.innerHTML = '<option value="">请选择区县</option>';
            if (province && city && _userRegionData[province] && _userRegionData[province][city]) {
                _userRegionData[province][city].forEach(function(district) {
                    const opt = document.createElement('option');
                    opt.value = district;
                    opt.textContent = district;
                    if (district === selectedDistrict) opt.selected = true;
                    distEl.appendChild(opt);
                });
            }
        }

        function editUserAddress(userId, addressId) {
            _currentEditUserId = userId;
            var mc = document.getElementById('modalContent');
            mc.style.overflowY = '';
            mc.style.maxHeight = '';
            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('addressId', addressId);
            fetch(ctx + '/api/admin/user/address/detail', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: params })
                .then(function(r) { return r.json(); })
                .then(function(res) {
                    if (res.code === 200) {
                        const a = res.data;
                        document.getElementById('modalContent').innerHTML =
                            '<h3 style="margin-bottom:24px;font-size:20px;">✏️ 编辑收货地址</h3>' +
                            '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">收货人 *</label><input id="userAddrReceiver" value="' + escapeHtml(a.receiverName || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                            '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">联系电话 *</label><input id="userAddrPhone" value="' + escapeHtml(a.receiverPhone || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                            '<div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:12px;">' +
                            '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">省份 *</label><select id="userAddrProvince" onchange="_userAddrLoadCities()" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择省份</option></select></div>' +
                            '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">城市 *</label><select id="userAddrCity" onchange="_userAddrLoadDistricts()" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择城市</option></select></div>' +
                            '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">区县 *</label><select id="userAddrDistrict" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择区县</option></select></div>' +
                            '</div>' +
                            '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">详细地址 *</label><textarea id="userAddrDetail" rows="3" style="resize:none;width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;">' + escapeHtml(a.address || '') + '</textarea></div>' +
                            '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">邮政编码</label><input id="userAddrPostal" value="' + escapeHtml(a.postalCode || '') + '" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                            '<div style="margin-bottom:20px;display:flex;align-items:center;gap:10px;"><span style="font-size:14px;color:#666;">默认地址</span><span id="userAddrDefault" data-default="' + (a.isDefault ? '1' : '0') + '" onclick="toggleAddrDefaultBadge()" style="display:inline-block;padding:4px 14px;border-radius:12px;font-size:13px;cursor:pointer;user-select:none;' + (a.isDefault ? 'background:#52c41a;color:#fff;' : 'background:#f0f0f0;color:#bbb;') + '">' + (a.isDefault ? '默认' : '') + '</span></div>' +
                            '<div style="display:flex;gap:10px;">' +
                            '<button class="btn btn-primary" onclick="saveUserAddress(' + userId + ',' + addressId + ')" style="flex:1;padding:10px;">保存</button>' +
                            '<button class="btn" onclick="closeUserAddressModal()" style="flex:1;padding:10px;">取消</button>' +
                            '</div>';
                        document.getElementById('modalOverlay').classList.add('show');
                        _userAddrInitProvinces(a.province);
                        _userAddrLoadCities(a.city);
                        _userAddrLoadDistricts(a.district);
                    } else {
                        alert(res.message || '获取地址详情失败');
                    }
                })
                .catch(function() { alert('网络错误'); });
        }

        function showAddAddress(userId) {
            _currentEditUserId = userId;
            var mc = document.getElementById('modalContent');
            mc.style.overflowY = '';
            mc.style.maxHeight = '';
            document.getElementById('modalContent').innerHTML =
                '<h3 style="margin-bottom:24px;font-size:20px;">➕ 添加收货地址</h3>' +
                '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">收货人 *</label><input id="userAddrReceiver" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">联系电话 *</label><input id="userAddrPhone" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:12px;">' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">省份 *</label><select id="userAddrProvince" onchange="_userAddrLoadCities()" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择省份</option></select></div>' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">城市 *</label><select id="userAddrCity" onchange="_userAddrLoadDistricts()" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择城市</option></select></div>' +
                '<div><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">区县 *</label><select id="userAddrDistrict" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"><option value="">请选择区县</option></select></div>' +
                '</div>' +
                '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">详细地址 *</label><textarea id="userAddrDetail" rows="3" style="resize:none;width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></textarea></div>' +
                '<div style="margin-bottom:12px;"><label style="font-size:14px;color:#666;display:block;margin-bottom:6px;">邮政编码</label><input id="userAddrPostal" style="width:100%;padding:10px 14px;border:1px solid #d9d9d9;border-radius:6px;font-size:15px;box-sizing:border-box;"></div>' +
                '<div style="margin-bottom:20px;display:flex;align-items:center;gap:10px;"><span style="font-size:14px;color:#666;">默认地址</span><span id="userAddrDefault" data-default="0" onclick="toggleAddrDefaultBadge()" style="display:inline-block;padding:4px 14px;border-radius:12px;font-size:13px;cursor:pointer;user-select:none;background:#f0f0f0;color:#bbb;"></span></div>' +
                '<div style="display:flex;gap:10px;">' +
                '<button class="btn btn-primary" onclick="saveUserAddress(' + userId + ',0)" style="flex:1;padding:10px;">保存</button>' +
                '<button class="btn" onclick="closeUserAddressModal()" style="flex:1;padding:10px;">取消</button>' +
                '</div>';
            document.getElementById('modalOverlay').classList.add('show');
            _userAddrInitProvinces('');
        }

        function closeUserAddressModal() {
            var uid = _currentEditUserId || _userDetailContext;
            if (uid) {
                viewUserDetail(uid);
            } else {
                document.getElementById('modalOverlay').classList.remove('show');
            }
        }

        function saveUserAddress(userId, addressId) {
            const receiver = document.getElementById('userAddrReceiver').value.trim();
            const phone = document.getElementById('userAddrPhone').value.trim();
            const province = document.getElementById('userAddrProvince').value;
            const city = document.getElementById('userAddrCity').value;
            const district = document.getElementById('userAddrDistrict').value;
            const detail = document.getElementById('userAddrDetail').value.trim();
            const postal = document.getElementById('userAddrPostal').value.trim();
            const isDefault = document.getElementById('userAddrDefault').getAttribute('data-default') === '1';
            if (!receiver || !phone || !province || !city || !district || !detail) {
                alert('请填写完整信息');
                return;
            }
            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('receiverName', receiver);
            params.append('receiverPhone', phone);
            params.append('province', province);
            params.append('city', city);
            params.append('district', district);
            params.append('address', detail);
            params.append('postalCode', postal);
            if (isDefault) params.append('isDefault', '1');
            let url, msg;
            if (addressId && addressId > 0) {
                params.append('addressId', addressId);
                url = ctx + '/api/admin/user/address/update';
                msg = '修改成功！';
            } else {
                url = ctx + '/api/admin/user/address/add';
                msg = '添加成功！';
            }
            fetch(url, { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: params })
                .then(function(r) { return r.json(); })
                .then(function(res) {
                    if (res.code === 200) {
                        alert(msg);
                        closeUserAddressModal();
                        var uid = _currentEditUserId || _userDetailContext;
                        if (uid) viewUserDetail(uid);
                    } else {
                        alert(res.message || '保存失败');
                    }
                })
                .catch(function() { alert('网络错误'); });
        }

        function deleteUserAddress(userId, addressId) {
            if (!confirm('确定删除该地址？')) return;
            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('addressId', addressId);
            fetch(ctx + '/api/admin/user/address/delete', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: params })
                .then(function(r) { return r.json(); })
                .then(function(res) {
                    if (res.code === 200) {
                        alert('删除成功！');
                        var uid = _currentEditUserId || _userDetailContext;
                        if (uid) viewUserDetail(uid);
                    } else {
                        alert(res.message || '删除失败');
                    }
                })
                .catch(function() { alert('网络错误'); });
        }

        function setUserAddressDefault(userId, addressId) {
            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('addressId', addressId);
            fetch(ctx + '/api/admin/user/address/default', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: params })
                .then(function(r) { return r.json(); })
                .then(function(res) {
                    if (res.code === 200) {
                        alert('设置成功！');
                        var uid = _currentEditUserId || _userDetailContext;
                        if (uid) viewUserDetail(uid);
                    } else {
                        alert(res.message || '设置失败');
                    }
                })
                .catch(function() { alert('网络错误'); });
        }

        // ==================== 通用函数 ====================
        function renderPagination(containerId, total, page, pageSize, callback) {
            const totalPages = Math.ceil(total / pageSize);
            if (totalPages <= 1) { document.getElementById(containerId).innerHTML = ''; return; }
            let html = '<button ' + (page <= 1 ? 'disabled' : '') + ' onclick="' + callback.name + '(' + (page-1) + ')">上一页</button>';
            for (let i = 1; i <= totalPages; i++) {
                html += '<button class="' + (i === page ? 'active' : '') + '" onclick="' + callback.name + '(' + i + ')">' + i + '</button>';
            }
            html += '<button ' + (page >= totalPages ? 'disabled' : '') + ' onclick="' + callback.name + '(' + (page+1) + ')">下一页</button>';
            document.getElementById(containerId).innerHTML = html;
        }
        function closeModal() { 
            var mc = document.getElementById('modalContent');
            mc.style.overflowY = '';
            mc.style.maxHeight = '';
            document.getElementById('modalOverlay').classList.remove('show'); 
        }
        function logout() {
            if (confirm('确定退出？')) {
                // 清除自动登录cookie
                document.cookie = 'autoLoginUserId=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
                document.cookie = 'autoLoginExpire=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
                localStorage.removeItem('admin_remembered');
                fetch(ctx + '/api/user/logout').then(function() {
                    window.location.href = ctx + '/pages/admin-login.jsp';
                });
            }
        }
        document.getElementById('modalOverlay').addEventListener('click', function(e) { if (e.target === this) closeModal(); });
    
        function formatTime(timestamp) {
            if (!timestamp) return '';
            var d = new Date(timestamp);
            var y = d.getFullYear();
            var m = d.getMonth() + 1;
            var day = d.getDate();
            var h = d.getHours();
            var min = d.getMinutes();
            var s = d.getSeconds();
            return y + '年' + (m < 10 ? '0' : '') + m + '月' + (day < 10 ? '0' : '') + day + '日 ' + (h < 10 ? '0' : '') + h + ':' + (min < 10 ? '0' : '') + min + ':' + (s < 10 ? '0' : '') + s;
        }
    </script>
</body>
</html>
