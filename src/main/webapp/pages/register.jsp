<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        .main-wrapper {
            width: 100%;
            max-width: 900px;
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
            width: 40%;
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
            width: 120px;
            height: 120px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        .brand-side::after {
            content: '';
            position: absolute;
            bottom: 15%;
            right: 10%;
            width: 80px;
            height: 80px;
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
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin-bottom: 24px;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255,255,255,0.3);
            position: relative;
            z-index: 1;
        }
        .brand-title {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: 2px;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }
        .brand-subtitle {
            font-size: 14px;
            opacity: 0.85;
            line-height: 1.6;
            letter-spacing: 1px;
            position: relative;
            z-index: 1;
        }
        .form-side {
            width: 60%;
            padding: 40px 44px;
            background: #fff;
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
        .register-container {
            padding: 0;
            border-radius: 0;
            box-shadow: none;
            width: 100%;
            max-width: none;
            position: relative;
            z-index: 1;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .register-title {
            text-align: center;
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .register-title::after {
            content: '';
            display: block;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            margin: 10px auto 0;
            border-radius: 2px;
        }
        .form-row {
            display: flex;
            gap: 16px;
            margin-bottom: 18px;
        }
        .form-group {
            flex: 1;
            min-width: 0;
        }
        .form-label {
            display: block;
            margin-bottom: 7px;
            color: #555;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.3px;
        }
        .form-input {
            width: 100%;
            padding: 11px 14px;
            border: 2px solid #e8e8e8;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fb;
            outline: none;
            color: #333;
        }
        .form-input:hover {
            border-color: #c0c0e0;
        }
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102,126,234,0.1);
        }
        .form-input::placeholder {
            color: #bbb;
        }
        .register-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            background-size: 200% 200%;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 2px;
            animation: btnShine 3s ease-in-out infinite;
        }
        @keyframes btnShine {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }
        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102,126,234,0.4);
        }
        .register-btn:active { transform: translateY(0); }
        .register-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
            animation: none;
            box-shadow: none;
        }
        .links {
            margin-top: 22px;
            text-align: center;
            font-size: 14px;
        }
        .links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            margin: 0 8px;
            transition: color 0.2s;
        }
        .links a:hover { color: #764ba2; text-decoration: underline; }
        .error-message {
            background: #fff5f5;
            color: #c33;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 18px;
            display: none;
            font-size: 14px;
            border-left: 4px solid #ff4d4f;
            font-weight: 500;
        }
        .success-message {
            background: #f0fff4;
            color: #38a169;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 18px;
            display: none;
            font-size: 14px;
            border-left: 4px solid #38a169;
            font-weight: 500;
        }
        .agreement-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }
        .agreement-group input[type="checkbox"] {
            cursor: pointer;
            accent-color: #667eea;
            width: 16px;
            height: 16px;
        }
        .agreement-group a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .agreement-group a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="main-wrapper">
        <div class="brand-side">
            <div class="brand-icon">🛒</div>
            <div class="brand-title">黑科大购物商城</div>
            </div>
        <div class="form-side">
    <div class="register-container">
        <h1 class="register-title">用户注册</h1>

        <div class="error-message" id="errorMsg"></div>
        <div class="success-message" id="successMsg"></div>

        <form id="registerForm">
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">用户名 *</label>
                    <input type="text" class="form-input" name="username" id="username" placeholder="请输入用户名" required>
                </div>
                <div class="form-group">
                    <label class="form-label">密码 *</label>
                    <input type="password" class="form-input" name="password" id="password" placeholder="至少6位" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">确认密码 *</label>
                    <input type="password" class="form-input" id="confirmPassword" placeholder="再次输入密码" required>
                </div>
                <div class="form-group">
                    <label class="form-label">真实姓名</label>
                    <input type="text" class="form-input" name="realName" id="realName" placeholder="选填">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">手机号</label>
                    <input type="tel" class="form-input" name="phone" id="phone" placeholder="选填">
                </div>
                <div class="form-group">
                    <label class="form-label">邮箱</label>
                    <input type="email" class="form-input" name="email" id="email" placeholder="选填">
                </div>
            </div>

            <div class="agreement-group">
                <input type="checkbox" id="agreement" name="agreement" checked>
                <label for="agreement">我已阅读并同意<a href="#" onclick="alert('用户协议：本系统为购物系统，请遵守相关法律法规。'); return false;">《用户协议》</a></label>
            </div>

            <button type="submit" class="register-btn">注册</button>
        </form>

        <div class="links">
            <a href="${ctx}/pages/login.jsp">已有账号？立即登录</a>
            <span style="color:#ccc;">|</span>
            <a href="${ctx}/index.jsp">返回首页</a>
        </div>
    </div>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';

        document.getElementById('registerForm').onsubmit = async function(e) {
            e.preventDefault();

            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            var errorMsg = document.getElementById('errorMsg');
            var successMsg = document.getElementById('successMsg');
            var submitBtn = this.querySelector('.register-btn');

            errorMsg.style.display = 'none';
            successMsg.style.display = 'none';

            if (!password || !confirmPassword) {
                errorMsg.textContent = '请填写密码和确认密码';
                errorMsg.style.display = 'block';
                return;
            }

            if (password !== confirmPassword) {
                errorMsg.textContent = '两次输入的密码不一致';
                errorMsg.style.display = 'block';
                return;
            }

            if (password.length < 6) {
                errorMsg.textContent = '密码长度不能少于6位';
                errorMsg.style.display = 'block';
                return;
            }

            if (!document.getElementById('agreement').checked) {
                errorMsg.textContent = '请先阅读并同意《用户协议》';
                errorMsg.style.display = 'block';
                return;
            }

            submitBtn.disabled = true;
            submitBtn.textContent = '注册中...';

            var formData = new URLSearchParams(new FormData(this));

            try {
                var response = await fetch(ctx + '/api/user/register', {
                    method: 'POST',
                    body: formData
                });

                var result = await response.json();

                if (result.code === 200) {
                    successMsg.textContent = '注册成功，正在跳转首页...';
                    successMsg.style.display = 'block';
                    setTimeout(function() {
                        window.location.href = ctx + '/index.jsp';
                    }, 1000);
                } else {
                    errorMsg.textContent = result.message || '注册失败';
                    errorMsg.style.display = 'block';
                    submitBtn.disabled = false;
                    submitBtn.textContent = '注册';
                }
            } catch (error) {
                errorMsg.textContent = '网络错误，请重试';
                errorMsg.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.textContent = '注册';
            }
        };
    </script>
</body>
</html>