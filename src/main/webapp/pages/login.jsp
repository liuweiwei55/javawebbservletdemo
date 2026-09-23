<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <script>
        (function() {
            var cookies = document.cookie.split(';');
            var userId = null, expire = null;
            for (var i = 0; i < cookies.length; i++) {
                var c = cookies[i].trim();
                if (c.indexOf('autoLoginUserId=') === 0) userId = c.substring('autoLoginUserId='.length);
                if (c.indexOf('autoLoginExpire=') === 0) expire = c.substring('autoLoginExpire='.length);
            }
            if (userId && expire && parseInt(expire) > Date.now()) {
                window.location.replace('${ctx}/index.jsp');
            }
        })();
    </script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
            top: -150px; left: -150px;
            border-radius: 50%;
        }
        body::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.06) 0%, transparent 70%);
            bottom: -100px; right: -100px;
            border-radius: 50%;
        }
        .main-wrapper {
            width: 100%;
            max-width: 800px;
            background: rgba(255,255,255,0.95);
            border-radius: 24px;
            box-shadow: 0 25px 80px rgba(0,0,0,0.28);
            overflow: hidden;
            display: flex;
            position: relative;
            z-index: 1;
            animation: fadeUp 0.5s ease-out;
        }
        .brand-side {
            width: 45%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            top: 10%;
            left: 15%;
            width: 100px;
            height: 100px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        .brand-side::after {
            content: '';
            position: absolute;
            bottom: 15%;
            right: 10%;
            width: 70px;
            height: 70px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite reverse;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .brand-icon {
            width: 70px;
            height: 70px;
            background: rgba(255,255,255,0.2);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            margin-bottom: 22px;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        .brand-title {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: 2px;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }
        .brand-subtitle {
            font-size: 13px;
            opacity: 0.85;
            line-height: 1.6;
            letter-spacing: 1px;
            position: relative;
            z-index: 1;
        }
        .form-side {
            width: 55%;
            padding: 40px;
            background: #fff;
        }
        .login-container {
            background: transparent;
            padding: 0;
            border-radius: 0;
            box-shadow: none;
            width: 100%;
            max-width: none;
        }
        .login-title {
            text-align: center;
            font-size: 26px;
            color: #333;
            margin-bottom: 24px;
        }
        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-size: 14px;
        }
        .form-input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        .form-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .remember-group {
            display: flex;
            gap: 20px;
            margin-top: 8px;
        }
        .remember-option {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }
        .remember-select {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            background: white;
        }
        .agreement-group {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
        }
        .agreement-left {
            display: flex;
            align-items: flex-start;
            gap: 6px;
            flex: 1;
            min-width: 0;
        }
        .agreement-left input[type="checkbox"] {
            margin-top: 3px;
            cursor: pointer;
            flex-shrink: 0;
        }
        .agreement-left .agreement-text {
            cursor: pointer;
            line-height: 1.5;
            word-break: break-word;
        }
        .agreement-left a {
            color: #667eea;
            text-decoration: none;
        }
        .forgot-link {
            color: #667eea;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap;
            transition: color 0.2s;
        }
        .forgot-link:hover { color: #5568d3; text-decoration: underline; }
        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }
        .login-btn:hover { transform: translateY(-2px); }
        .login-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }
        .error-message {
            background: #fee;
            color: #c33;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }
        .links {
            margin-top: 20px;
            text-align: center;
        }
        .links a {
            color: #667eea;
            text-decoration: none;
            margin: 0 10px;
        }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="main-wrapper">
        <div class="brand-side">
            <div class="brand-icon">🛒</div>
            <div class="brand-title">黑科大购物商城</div>
            </div>
        <div class="form-side">
    <div class="login-container">
        <h1 class="login-title">用户登录</h1>
        <div class="error-message" id="errorMsg"></div>

        <form id="loginForm">
            <div class="form-group">
                <label class="form-label">用户名</label>
                <input type="text" class="form-input" name="username" id="username" required>
            </div>

            <div class="form-group">
                <label class="form-label">密码</label>
                <input type="password" class="form-input" name="password" id="password" required>
            </div>

            <div class="form-group">
                <label class="form-label">记住登录状态</label>
                <div class="remember-group">
                    <label class="remember-option">
                        <input type="radio" name="rememberMe" value="0" checked>
                        <span>不保存</span>
                    </label>
                    <label class="remember-option">
                        <input type="radio" name="rememberMe" value="1">
                        <span>1天</span>
                    </label>
                    <label class="remember-option">
                        <input type="radio" name="rememberMe" value="7">
                        <span>7天</span>
                    </label>
                    <label class="remember-option">
                        <input type="radio" name="rememberMe" value="30">
                        <span>30天</span>
                    </label>
                </div>
            </div>

            <div class="agreement-group">
                <div class="agreement-left">
                    <input type="checkbox" id="agreement" name="agreement" checked>
                    <span class="agreement-text" onclick="document.getElementById('agreement').click();" style="cursor:pointer;">我已阅读并同意<a href="#" onclick="event.stopPropagation(); alert('用户协议：本系统为购物系统，请遵守相关法律法规。'); return false;">《用户协议》</a></span>
                </div>
                <a href="<%= request.getContextPath() %>/pages/forgot-password.jsp" style="color:#667eea; font-size:13px; text-decoration:none; font-weight:500; white-space:nowrap;">忘记密码？</a>
            </div>

            <button type="submit" class="login-btn">登录</button>
        </form>

        <div class="links">
            <a href="<%= request.getContextPath() %>/pages/register.jsp">还没有账号？立即注册</a> / <a href="<%= request.getContextPath() %>/pages/admin-login.jsp">我是管理员</a>
            <br><br>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </div>
    </div>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';

        document.getElementById('loginForm').onsubmit = async function(e) {
            e.preventDefault();

            var errorMsg = document.getElementById('errorMsg');
            var submitBtn = this.querySelector('.login-btn');
            errorMsg.style.display = 'none';

            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;

            if (!username || !password) {
                errorMsg.textContent = '请输入用户名和密码';
                errorMsg.style.display = 'block';
                return;
            }

            if (!document.getElementById('agreement').checked) {
                errorMsg.textContent = '请先阅读并同意《用户协议》';
                errorMsg.style.display = 'block';
                return;
            }

            submitBtn.disabled = true;
            submitBtn.textContent = '登录中...';

            var formData = new URLSearchParams();
            formData.append('username', username);
            formData.append('password', password);
            formData.append('role', '0');

            var rememberRadios = document.getElementsByName('rememberMe');
            for (var j = 0; j < rememberRadios.length; j++) {
                if (rememberRadios[j].checked) {
                    formData.append('rememberMe', rememberRadios[j].value);
                    break;
                }
            }

            try {
                var response = await fetch(ctx + '/api/user/login', {
                    method: 'POST',
                    body: formData
                });

                var result = await response.json();

                if (result.code === 200) {
                    var redirect = new URLSearchParams(window.location.search).get('redirect');
                    window.location.href = redirect ? decodeURIComponent(redirect) : ctx + '/index.jsp';
                } else {
                    errorMsg.textContent = result.message || '登录失败';
                    errorMsg.style.display = 'block';
                    submitBtn.disabled = false;
                    submitBtn.textContent = '登录';
                }
            } catch (error) {
                errorMsg.textContent = '网络错误，请重试';
                errorMsg.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.textContent = '登录';
            }
        };
    </script>
</body>
</html>