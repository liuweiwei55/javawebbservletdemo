<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - 黑科大购物商城</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <script>
        // 自动登录检测：有cookie直接跳转管理页面，无需渲染登录表单
        (function() {
            var cookies = document.cookie.split(';');
            var userId = null, expire = null;
            for (var i = 0; i < cookies.length; i++) {
                var c = cookies[i].trim();
                if (c.indexOf('autoLoginUserId=') === 0) userId = c.substring('autoLoginUserId='.length);
                if (c.indexOf('autoLoginExpire=') === 0) expire = c.substring('autoLoginExpire='.length);
            }
            if (userId && expire && parseInt(expire) > Date.now()) {
                window.location.replace('${ctx}/pages/admin.jsp');
            }
        })();
    </script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', 'Segoe UI', Arial, sans-serif;
            background: #0a0a1a;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, #0a0a1a 0%, #0d1b3e 30%, #0f3460 60%, #0a1628 100%);
            z-index: -1;
            animation: bgShift 8s ease-in-out infinite alternate;
        }
        @keyframes bgShift {
            0% { background: linear-gradient(135deg, #0a0a1a 0%, #0d1b3e 30%, #0f3460 60%, #0a1628 100%); }
            100% { background: linear-gradient(135deg, #0a1628 0%, #0f3460 30%, #0d1b3e 60%, #0a0a1a 100%); }
        }
        body::after {
            content: '';
            position: absolute;
            width: 700px; height: 700px;
            background: radial-gradient(circle, rgba(79,172,254,0.12) 0%, transparent 60%);
            top: -250px; right: -250px;
            border-radius: 50%;
            z-index: -1;
            animation: floatGlow 6s ease-in-out infinite alternate;
        }
        @keyframes floatGlow {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(-30px, 30px) scale(1.1); }
        }
        .bg-particle {
            position: absolute;
            border-radius: 50%;
            background: rgba(79,172,254,0.06);
            z-index: -1;
            animation: particleFloat 10s ease-in-out infinite;
        }
        @keyframes particleFloat {
            0%, 100% { transform: translateY(0) scale(1); opacity: 0.3; }
            50% { transform: translateY(-40px) scale(1.5); opacity: 0.6; }
        }
        .main-wrapper {
            width: 100%;
            max-width: 820px;
            background: rgba(255,255,255,0.95);
            border-radius: 24px;
            box-shadow: 0 25px 80px rgba(0,0,0,0.35), 0 0 0 1px rgba(255,255,255,0.1);
            overflow: hidden;
            display: flex;
            position: relative;
            z-index: 1;
            animation: cardIn 0.6s ease-out;
        }
        @keyframes cardIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .brand-side {
            width: 45%;
            background: linear-gradient(135deg, #0d1b3e 0%, #0f3460 50%, #16213e 100%);
            padding: 60px 30px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            position: relative;
        }
        .brand-side::before {
            content: '';
            position: absolute;
            top: 8%;
            left: 12%;
            width: 100px;
            height: 100px;
            background: rgba(79,172,254,0.12);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        .brand-side::after {
            content: '';
            position: absolute;
            bottom: 12%;
            right: 10%;
            width: 70px;
            height: 70px;
            background: rgba(0,198,251,0.1);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite reverse;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        .brand-icon {
            width: 72px;
            height: 72px;
            background: rgba(79,172,254,0.2);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(79,172,254,0.3);
            position: relative;
            z-index: 1;
        }
        .brand-title {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: 2px;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
            background: linear-gradient(135deg, #4facfe, #00c6fb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .brand-badge {
            display: inline-block;
            background: rgba(79,172,254,0.2);
            border: 1px solid rgba(79,172,254,0.4);
            color: #4facfe;
            font-size: 11px;
            padding: 3px 12px;
            border-radius: 20px;
            letter-spacing: 1px;
            margin-bottom: 16px;
            position: relative;
            z-index: 1;
        }
        .brand-subtitle {
            font-size: 13px;
            opacity: 0.7;
            line-height: 1.6;
            letter-spacing: 1px;
            position: relative;
            z-index: 1;
        }
        .form-side {
            width: 55%;
            padding: 40px 38px;
            background: #fff;
        }
        .login-wrapper {
            width: 100%;
            padding: 20px;
            z-index: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-card {
            background: transparent;
            backdrop-filter: none;
            border-radius: 0;
            padding: 0;
            box-shadow: none;
            border: none;
        }
        .logo-section {
            text-align: center;
            margin-bottom: 34px;
        }
        .logo-img {
            width: 68px;
            height: 68px;
            border-radius: 16px;
            object-fit: cover;
            margin-bottom: 14px;
            box-shadow: 0 6px 20px rgba(79,172,254,0.25);
        }
        .logo-section h1 {
            font-size: 22px;
            color: #1a1a2e;
            font-weight: 700;
            margin-bottom: 6px;
            letter-spacing: 1px;
        }
        .logo-section .subtitle {
            font-size: 13px;
            color: #999;
            letter-spacing: 2px;
            text-transform: uppercase;
        }
        .form-group {
            margin-bottom: 18px;
            position: relative;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 7px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .input-wrapper {
            position: relative;
        }
        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 2px solid #e8e8e8;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fb;
            outline: none;
            color: #333;
        }
        .form-input:hover {
            border-color: #c0d8f0;
        }
        .form-input:focus {
            border-color: #4facfe;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(79,172,254,0.1);
        }
        .form-input.error {
            border-color: #ff4d4f;
            background: #fff5f5;
        }
        .password-toggle {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            font-size: 18px;
            user-select: none;
            background: none;
            border: none;
            padding: 4px;
            transition: color 0.2s;
        }
        .password-toggle:hover { color: #4facfe; }
        .captcha-group {
            display: flex;
            gap: 10px;
        }
        .captcha-group .form-input {
            flex: 1;
        }
        .captcha-img {
            width: 105px;
            height: 44px;
            border-radius: 10px;
            cursor: pointer;
            border: 2px solid #e8e8e8;
            object-fit: cover;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .captcha-img:hover {
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79,172,254,0.1);
        }
        .error-msg {
            font-size: 12px;
            color: #ff4d4f;
            margin-top: 4px;
            display: none;
            font-weight: 500;
        }
        .error-msg.show { display: block; }
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            font-size: 13px;
        }
        .remember-me {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            color: #666;
            font-weight: 500;
        }
        .remember-me input[type="checkbox"] {
            accent-color: #4facfe;
            width: 16px;
            height: 16px;
        }
        .forgot-link {
            color: #4facfe;
            text-decoration: none;
            cursor: pointer;
            font-weight: 500;
            transition: color 0.2s;
        }
        .forgot-link:hover { color: #2d8fd9; text-decoration: underline; }
        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #4facfe 0%, #00c6fb 50%, #4facfe 100%);
            background-size: 200% 200%;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 3px;
            animation: btnShine 3s ease-in-out infinite;
        }
        @keyframes btnShine {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(79,172,254,0.45);
        }
        .login-btn:active { transform: translateY(0); }
        .login-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
            animation: none;
        }
        .switch-link {
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
            color: #999;
        }
        .switch-link a {
            color: #4facfe;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .switch-link a:hover { color: #2d8fd9; text-decoration: underline; }
        .footer-info {
            text-align: center;
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #f0f0f0;
            font-size: 12px;
            color: #bbb;
            line-height: 1.8;
        }
        .footer-info span { display: block; }
        @media (max-width: 768px) {
            .main-wrapper {
                flex-direction: column;
                max-width: 420px;
            }
            .brand-side {
                width: 100%;
                padding: 30px 20px;
            }
            .brand-title { font-size: 20px; }
            .brand-icon { width: 56px; height: 56px; font-size: 28px; }
            .form-side {
                width: 100%;
                padding: 28px 24px;
            }
        }
        .alert-toast {
            position: fixed;
            top: 24px;
            left: 50%;
            transform: translateX(-50%);
            padding: 14px 28px;
            border-radius: 10px;
            font-size: 14px;
            z-index: 9999;
            animation: slideDown 0.35s ease;
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
            font-weight: 500;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateX(-50%) translateY(-20px); }
            to { opacity: 1; transform: translateX(-50%) translateY(0); }
        }
        .alert-error { background: #fff2f0; color: #ff4d4f; border: 1px solid #ffccc7; }
        .alert-warning { background: #fffbe6; color: #d48806; border: 1px solid #ffe58f; }
        .alert-info { background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }
    </style>
</head>
<body>
    <div class="bg-particle" style="width:120px;height:120px;top:15%;left:10%;animation-delay:0s;"></div>
    <div class="bg-particle" style="width:80px;height:80px;top:60%;left:80%;animation-delay:2s;"></div>
    <div class="bg-particle" style="width:60px;height:60px;top:75%;left:25%;animation-delay:4s;"></div>
    <div class="bg-particle" style="width:100px;height:100px;top:20%;left:70%;animation-delay:6s;"></div>
    <div class="login-wrapper">
        <div class="main-wrapper">
            <div class="brand-side">
                <div class="brand-icon">🛡️</div>
                <div class="brand-title">黑科大购物商城</div>
                <div class="brand-badge">后台管理系统</div>
            </div>
            <div class="form-side">
        <div class="login-card">
            <div class="logo-section">
                <img src="${ctx}/images/logo.jpg" alt="Logo" class="logo-img" onerror="this.style.display='none';">
                <h1>黑科大购物商城</h1>
                <p class="subtitle">后台管理系统</p>
            </div>

            <form id="adminLoginForm" autocomplete="off">
                <input type="hidden" id="csrfToken" value="${pageContext.session.id}">

                <div class="form-group">
                    <label>管理员账号</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" class="form-input" placeholder="请输入管理员账号" maxlength="30" autocomplete="off">
                    </div>
                    <div class="error-msg" id="usernameError">请输入管理员账号</div>
                </div>

                <div class="form-group">
                    <label>登录密码</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" class="form-input" placeholder="请输入登录密码" maxlength="30" autocomplete="off">
                        <button type="button" class="password-toggle" id="togglePwd" onclick="togglePassword()" title="显示/隐藏密码">👁️</button>
                    </div>
                    <div class="error-msg" id="passwordError">请输入登录密码</div>
                </div>

                <div class="form-group">
                    <label>验证码</label>
                    <div class="captcha-group">
                        <input type="text" id="captcha" class="form-input" placeholder="请输入验证码" maxlength="4" autocomplete="off">
                        <canvas id="captchaCanvas" class="captcha-img" onclick="generateCaptcha()" title="点击刷新验证码"></canvas>
                    </div>
                    <div class="error-msg" id="captchaError">验证码错误</div>
                </div>

                <div class="options-row">
                    <label class="remember-me">
                        <input type="checkbox" id="rememberMe">
                        <span>记住我</span>
                    </label>
                    <a class="forgot-link" onclick="forgotPassword()">忘记密码？</a>
                </div>

                <button type="submit" class="login-btn" id="loginBtn">登 录</button>
            </form>

            <div class="switch-link">
                <a href="${ctx}/pages/login.jsp">返回用户登录</a>
            </div>
        </div>
            <div class="footer-info">
                <span>黑科大购物商城 v2.0 | 后台管理系统</span>
                <span>&copy; 2024-2026 黑龙江科技大学 | 软件工程</span>
            </div>
            </div>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';
        var captchaText = '';
        var loginAttempts = 0;
        var maxAttempts = 5;
        var isLocked = false;
        var lockTimer = null;

        // ==================== 验证码 ====================
        function generateCaptcha() {
            var canvas = document.getElementById('captchaCanvas');
            var ctx2d = canvas.getContext('2d');
            canvas.width = 100;
            canvas.height = 42;

            var chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
            captchaText = '';
            for (var i = 0; i < 4; i++) {
                captchaText += chars.charAt(Math.floor(Math.random() * chars.length));
            }

            ctx2d.fillStyle = '#f0f0f0';
            ctx2d.fillRect(0, 0, 100, 42);

            for (var i = 0; i < 20; i++) {
                ctx2d.fillStyle = 'rgba(0,0,0,' + (Math.random() * 0.1) + ')';
                ctx2d.beginPath();
                ctx2d.arc(Math.random() * 100, Math.random() * 42, Math.random() * 2, 0, Math.PI * 2);
                ctx2d.fill();
            }

            for (var i = 0; i < 4; i++) {
                ctx2d.fillStyle = '#' + Math.floor(Math.random() * 0x666666 + 0x333333).toString(16);
                ctx2d.font = (20 + Math.random() * 6) + 'px Arial';
                ctx2d.save();
                ctx2d.translate(15 + i * 22, 28 + Math.random() * 6);
                ctx2d.rotate((Math.random() - 0.5) * 0.4);
                ctx2d.fillText(captchaText.charAt(i), 0, 0);
                ctx2d.restore();
            }

            for (var i = 0; i < 3; i++) {
                ctx2d.strokeStyle = 'rgba(0,0,0,' + (Math.random() * 0.2) + ')';
                ctx2d.beginPath();
                ctx2d.moveTo(Math.random() * 100, Math.random() * 42);
                ctx2d.lineTo(Math.random() * 100, Math.random() * 42);
                ctx2d.stroke();
            }
        }

        // ==================== 密码显示/隐藏 ====================
        function togglePassword() {
            var pwd = document.getElementById('password');
            var btn = document.getElementById('togglePwd');
            if (pwd.type === 'password') {
                pwd.type = 'text';
                btn.textContent = '🙈';
            } else {
                pwd.type = 'password';
                btn.textContent = '👁️';
            }
        }

        // ==================== Toast 提示 ====================
        function showToast(msg, type) {
            var existing = document.querySelector('.alert-toast');
            if (existing) existing.remove();
            var toast = document.createElement('div');
            toast.className = 'alert-toast alert-' + (type || 'error');
            toast.textContent = msg;
            document.body.appendChild(toast);
            setTimeout(function() { toast.remove(); }, 3000);
        }

        // ==================== 记住账号 ====================
        function loadRemembered() {
            var saved = localStorage.getItem('admin_username');
            if (saved) {
                document.getElementById('username').value = saved;
                document.getElementById('rememberMe').checked = true;
            }
        }
        function saveRemembered(username) {
            if (document.getElementById('rememberMe').checked) {
                localStorage.setItem('admin_username', username);
            } else {
                localStorage.removeItem('admin_username');
            }
        }

        // ==================== 忘记密码 ====================
        function forgotPassword() {
            window.location.href = ctx + '/pages/admin-reset-password.jsp';
        }

        // ==================== 表单提交 ====================
        document.getElementById('adminLoginForm').onsubmit = async function(e) {
            e.preventDefault();

            if (isLocked) {
                showToast('账号已锁定，请稍后再试', 'error');
                return;
            }

            var username = document.getElementById('username').value.trim();
            var password = document.getElementById('password').value;
            var captcha = document.getElementById('captcha').value.trim().toUpperCase();

            // 前端校验
            var valid = true;
            document.getElementById('usernameError').classList.remove('show');
            document.getElementById('passwordError').classList.remove('show');
            document.getElementById('captchaError').classList.remove('show');
            document.getElementById('username').classList.remove('error');
            document.getElementById('password').classList.remove('error');
            document.getElementById('captcha').classList.remove('error');

            if (!username) {
                document.getElementById('usernameError').classList.add('show');
                document.getElementById('username').classList.add('error');
                valid = false;
            }
            if (!password) {
                document.getElementById('passwordError').classList.add('show');
                document.getElementById('password').classList.add('error');
                valid = false;
            }
            if (!captcha) {
                document.getElementById('captchaError').textContent = '请输入验证码';
                document.getElementById('captchaError').classList.add('show');
                document.getElementById('captcha').classList.add('error');
                valid = false;
            } else if (captcha !== captchaText) {
                document.getElementById('captchaError').textContent = '验证码错误';
                document.getElementById('captchaError').classList.add('show');
                document.getElementById('captcha').classList.add('error');
                generateCaptcha();
                document.getElementById('captcha').value = '';
                valid = false;
            }
            if (!valid) return;

            // 密码简单加密传输
            var encryptedPwd = btoa(password);

            var btn = document.getElementById('loginBtn');
            btn.disabled = true;
            btn.textContent = '登录中...';

            try {
                var params = new URLSearchParams();
                params.append('username', username);
                params.append('password', password);
                params.append('role', '1');
                params.append('encrypted', '1');
                if (document.getElementById('rememberMe').checked) {
                    params.append('rememberMe', '30');
                }

                var response = await fetch(ctx + '/api/user/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                });

                var result = await response.json();

                if (result.code === 200) {
                    loginAttempts = 0;
                    saveRemembered(username);
                    showToast('登录成功，正在跳转...', 'info');
                    setTimeout(function() {
                        window.location.href = ctx + '/pages/admin.jsp';
                    }, 500);
                } else if (result.code === 403) {
                    loginAttempts++;
                    var msg = result.message || '账号已被禁用';
                    showToast(msg, 'error');
                    btn.disabled = false;
                    btn.textContent = '登 录';
                    generateCaptcha();
                    document.getElementById('captcha').value = '';
                } else if (result.code === 401) {
                    loginAttempts++;
                    showToast('账号或密码错误', 'error');
                    btn.disabled = false;
                    btn.textContent = '登 录';
                    generateCaptcha();
                    document.getElementById('captcha').value = '';
                    if (loginAttempts >= maxAttempts) {
                        lockAccount();
                    }
                } else {
                    showToast(result.message || '登录失败', 'error');
                    btn.disabled = false;
                    btn.textContent = '登 录';
                    generateCaptcha();
                    document.getElementById('captcha').value = '';
                }
            } catch (error) {
                console.error('登录失败:', error);
                showToast('网络错误，请重试', 'error');
                btn.disabled = false;
                btn.textContent = '登 录';
                generateCaptcha();
                document.getElementById('captcha').value = '';
            }
        };

        function lockAccount() {
            isLocked = true;
            var countdown = 60;
            var btn = document.getElementById('loginBtn');
            btn.disabled = true;
            showToast('登录失败次数过多，账号已锁定60秒', 'error');
            lockTimer = setInterval(function() {
                countdown--;
                btn.textContent = '请等待 ' + countdown + ' 秒';
                if (countdown <= 0) {
                    clearInterval(lockTimer);
                    isLocked = false;
                    loginAttempts = 0;
                    btn.disabled = false;
                    btn.textContent = '登 录';
                    showToast('锁定已解除，请重新登录', 'info');
                }
            }, 1000);
        }

        // ==================== 初始化 ====================
        window.onload = function() {
            generateCaptcha();
            loadRemembered();
        };
    </script>
</body>
</html>