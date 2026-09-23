<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重置密码 - 黑科大购物商城后台管理</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #1a1a2e;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .reset-wrapper {
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }
        .reset-card {
            background: rgba(255,255,255,0.97);
            border-radius: 16px;
            padding: 40px 35px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .logo-section {
            text-align: center;
            margin-bottom: 25px;
        }
        .logo-img {
            width: 56px;
            height: 56px;
            border-radius: 10px;
            object-fit: cover;
            margin-bottom: 10px;
        }
        .logo-section h1 { font-size: 18px; color: #1a1a2e; }
        .logo-section .subtitle { font-size: 12px; color: #999; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 13px; color: #555; margin-bottom: 6px; font-weight: 500; }
        .form-input {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background: #fafafa;
            outline: none;
            transition: all 0.3s;
        }
        .form-input:focus { border-color: #4facfe; background: #fff; box-shadow: 0 0 0 3px rgba(79,172,254,0.1); }
        .form-input.error { border-color: #ff4d4f; background: #fff2f0; }
        .error-msg { font-size: 11px; color: #ff4d4f; margin-top: 3px; display: none; }
        .error-msg.show { display: block; }
        .btn {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            letter-spacing: 1px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #fff;
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 8px 25px rgba(79,172,254,0.4); }
        .btn-primary:disabled { background: #ccc; cursor: not-allowed; transform: none; box-shadow: none; }
        .btn-success { background: #52c41a; color: #fff; }
        .switch-link {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #999;
        }
        .switch-link a { color: #4facfe; text-decoration: none; }
        .switch-link a:hover { text-decoration: underline; }
        .step-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            font-size: 13px;
            color: #999;
        }
        .step-indicator .step {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #e0e0e0;
            color: #999;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 12px;
        }
        .step-indicator .step.active { background: #4facfe; color: #fff; }
        .step-indicator .step.done { background: #52c41a; color: #fff; }
        .step-indicator .line { width: 40px; height: 2px; background: #e0e0e0; margin: 0 6px; }
        .step-indicator .line.done { background: #52c41a; }
        .user-info-card {
            background: #f6ffed;
            border: 1px solid #b7eb8f;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 18px;
            font-size: 13px;
        }
        .user-info-card p { margin: 4px 0; }
        .user-info-card .label { color: #999; }
        .alert-toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 14px;
            z-index: 9999;
            animation: slideDown 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateX(-50%) translateY(-20px); }
            to { opacity: 1; transform: translateX(-50%) translateY(0); }
        }
        .alert-error { background: #fff2f0; color: #ff4d4f; border: 1px solid #ffccc7; }
        .alert-success { background: #f6ffed; color: #52c41a; border: 1px solid #b7eb8f; }
        .footer-info {
            text-align: center;
            margin-top: 20px;
            font-size: 11px;
            color: rgba(255,255,255,0.5);
            line-height: 1.8;
        }
    </style>
</head>
<body>
    <div class="reset-wrapper">
        <div class="reset-card">
            <div class="logo-section">
                <img src="${ctx}/images/logo.jpg" alt="Logo" class="logo-img" onerror="this.style.display='none';">
                <h1>重置管理员密码</h1>
                <p class="subtitle">黑科大购物商城 · 后台管理系统</p>
            </div>

            <!-- 步骤1：查找账号 -->
            <div id="step1">
                <div class="step-indicator">
                    <span class="step active">1</span>
                    <span class="line"></span>
                    <span class="step">2</span>
                    <span class="line"></span>
                    <span class="step">3</span>
                </div>

                <div class="form-group">
                    <label>手机号</label>
                    <input type="text" id="phone" class="form-input" placeholder="请输入管理员绑定的手机号" maxlength="11">
                    <div class="error-msg" id="phoneError">请输入正确的手机号</div>
                </div>

                <div class="form-group">
                    <label>邮箱</label>
                    <input type="text" id="email" class="form-input" placeholder="请输入管理员绑定的邮箱">
                    <div class="error-msg" id="emailError">请输入正确的邮箱</div>
                </div>

                <button class="btn btn-primary" onclick="searchAdmin()">查找管理员账号</button>
            </div>

            <!-- 步骤2：确认身份 -->
            <div id="step2" style="display:none;">
                <div class="step-indicator">
                    <span class="step done">✓</span>
                    <span class="line done"></span>
                    <span class="step active">2</span>
                    <span class="line"></span>
                    <span class="step">3</span>
                </div>

                <div class="user-info-card" id="userInfoCard"></div>

                <div class="form-group">
                    <label>请输入管理员真实姓名以确认身份</label>
                    <input type="text" id="confirmRealName" class="form-input" placeholder="请输入管理员真实姓名">
                    <div class="error-msg" id="confirmRealNameError">真实姓名不匹配</div>
                </div>

                <button class="btn btn-primary" onclick="confirmIdentity()">确认身份，重置密码</button>
                <button class="btn btn-success" style="margin-top:10px;background:#fff;color:#4facfe;border:1px solid #4facfe;" onclick="backToStep1()">返回上一步</button>
            </div>

            <!-- 步骤3：重置密码 -->
            <div id="step3" style="display:none;">
                <div class="step-indicator">
                    <span class="step done">✓</span>
                    <span class="line done"></span>
                    <span class="step done">✓</span>
                    <span class="line done"></span>
                    <span class="step active">3</span>
                </div>

                <div class="user-info-card" id="userInfoCard2"></div>

                <div class="form-group">
                    <label>新密码</label>
                    <input type="password" id="newPassword" class="form-input" placeholder="请输入新密码（至少6位）" maxlength="30">
                    <div class="error-msg" id="newPasswordError">密码至少6位</div>
                </div>

                <div class="form-group">
                    <label>确认新密码</label>
                    <input type="password" id="confirmPassword" class="form-input" placeholder="请再次输入新密码" maxlength="30">
                    <div class="error-msg" id="confirmPasswordError">两次密码不一致</div>
                </div>

                <button class="btn btn-primary" onclick="doResetPassword()">重置密码</button>
            </div>

            <div class="switch-link">
                <a href="${ctx}/pages/admin-login.jsp">返回管理员登录</a>
            </div>
        </div>

        <div class="footer-info">
            <span>黑科大购物商城 v2.0 | 后台管理系统</span>
            <span>&copy; 2024-2026 黑龙江科技大学 | 软件工程</span>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';
        var foundAdmin = null;

        function showToast(msg, type) {
            var existing = document.querySelector('.alert-toast');
            if (existing) existing.remove();
            var toast = document.createElement('div');
            toast.className = 'alert-toast alert-' + (type || 'error');
            toast.textContent = msg;
            document.body.appendChild(toast);
            setTimeout(function() { toast.remove(); }, 3000);
        }

        function searchAdmin() {
            var phone = document.getElementById('phone').value.trim();
            var email = document.getElementById('email').value.trim();
            document.getElementById('phoneError').classList.remove('show');
            document.getElementById('emailError').classList.remove('show');

            var valid = true;
            if (!phone) {
                document.getElementById('phoneError').classList.add('show');
                valid = false;
            } else if (!/^1\d{10}$/.test(phone)) {
                document.getElementById('phoneError').textContent = '请输入正确的手机号';
                document.getElementById('phoneError').classList.add('show');
                valid = false;
            }
            if (!email) {
                document.getElementById('emailError').classList.add('show');
                valid = false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = '请输入正确的邮箱';
                document.getElementById('emailError').classList.add('show');
                valid = false;
            }
            if (!valid) return;

            var params = new URLSearchParams();
            if (phone) params.append('phone', phone);
            if (email) params.append('email', email);

            fetch(ctx + '/api/admin/findByPhoneOrEmail?' + params.toString())
                .then(function(r) { return r.json(); })
                .then(function(res) {
                    if (res.code === 200 && res.data) {
                        foundAdmin = res.data;
                        // 步骤2不显示真实姓名，让用户凭记忆输入以验证身份
                        var info = '<p><span class="label">用户名：</span>' + foundAdmin.username + '</p>';
                        if (phone) info += '<p><span class="label">手机号：</span>' + phone + '</p>';
                        if (email) info += '<p><span class="label">邮箱：</span>' + email + '</p>';
                        document.getElementById('userInfoCard').innerHTML = info;
                        // 步骤3可显示完整信息
                        var info3 = '<p><span class="label">真实姓名：</span><b>' + foundAdmin.realName + '</b></p>';
                        info3 += '<p><span class="label">用户名：</span>' + foundAdmin.username + '</p>';
                        if (phone) info3 += '<p><span class="label">手机号：</span>' + phone + '</p>';
                        if (email) info3 += '<p><span class="label">邮箱：</span>' + email + '</p>';
                        document.getElementById('userInfoCard2').innerHTML = info3;
                        document.getElementById('step1').style.display = 'none';
                        document.getElementById('step2').style.display = 'block';
                        document.getElementById('step3').style.display = 'none';
                    } else {
                        showToast(res.message || '未找到该管理员账号', 'error');
                    }
                })
                .catch(function() {
                    showToast('查询失败，请重试', 'error');
                });
        }

        function confirmIdentity() {
            var realName = document.getElementById('confirmRealName').value.trim();
            document.getElementById('confirmRealNameError').classList.remove('show');

            if (!realName) {
                document.getElementById('confirmRealNameError').textContent = '请输入真实姓名';
                document.getElementById('confirmRealNameError').classList.add('show');
                return;
            }
            if (realName !== foundAdmin.realName) {
                document.getElementById('confirmRealNameError').textContent = '真实姓名不匹配，请重新输入';
                document.getElementById('confirmRealNameError').classList.add('show');
                return;
            }

            document.getElementById('step1').style.display = 'none';
            document.getElementById('step2').style.display = 'none';
            document.getElementById('step3').style.display = 'block';
        }

        function backToStep1() {
            foundAdmin = null;
            document.getElementById('step1').style.display = 'block';
            document.getElementById('step2').style.display = 'none';
            document.getElementById('step3').style.display = 'none';
            document.getElementById('confirmUsername').value = '';
        }

        function doResetPassword() {
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            document.getElementById('newPasswordError').classList.remove('show');
            document.getElementById('confirmPasswordError').classList.remove('show');

            if (!newPassword || newPassword.length < 6) {
                document.getElementById('newPasswordError').classList.add('show');
                return;
            }
            if (newPassword !== confirmPassword) {
                document.getElementById('confirmPasswordError').classList.add('show');
                return;
            }

            var params = new URLSearchParams();
            params.append('userId', foundAdmin.id);
            params.append('newPassword', newPassword);

            fetch(ctx + '/api/admin/resetPasswordByVerification', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(r) { return r.json(); })
            .then(function(res) {
                if (res.code === 200) {
                    showToast('密码重置成功！请返回登录', 'success');
                    setTimeout(function() {
                        window.location.href = ctx + '/pages/admin-login.jsp';
                    }, 1500);
                } else {
                    showToast(res.message || '重置失败', 'error');
                }
            })
            .catch(function() {
                showToast('重置失败，请重试', 'error');
            });
        }
    </script>
</body>
</html>