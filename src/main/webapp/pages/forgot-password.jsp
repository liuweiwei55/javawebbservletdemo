<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("ctx", ctx);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户找回密码 - 购物系统</title>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex; justify-content: center; align-items: center;
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
            top: 10%; left: 15%;
            width: 100px; height: 100px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        .brand-side::after {
            content: '';
            position: absolute;
            bottom: 15%; right: 10%;
            width: 70px; height: 70px;
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
            width: 70px; height: 70px;
            background: rgba(255,255,255,0.2);
            border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 36px;
            margin-bottom: 22px;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255,255,255,0.3);
            position: relative; z-index: 1;
        }
        .brand-title { font-size: 26px; font-weight: 800; letter-spacing: 2px; margin-bottom: 10px; position: relative; z-index: 1; }
        .brand-subtitle { font-size: 13px; opacity: 0.85; line-height: 1.6; letter-spacing: 1px; position: relative; z-index: 1; }

        .form-side { width: 55%; padding: 40px; background: #fff; min-height: 500px; display: flex; flex-direction: column; }
        .reset-container { background: transparent; padding: 0; border-radius: 0; box-shadow: none; width: 100%; max-width: none; flex: 1; }
        .reset-title { text-align: center; font-size: 26px; color: #333; margin-bottom: 8px; }
        .reset-subtitle { text-align: center; font-size: 13px; color: #999; margin-bottom: 24px; }
        .step-indicator { display: flex; justify-content: center; margin-bottom: 20px; gap: 8px; align-items: center; }
        .step-item { display: flex; align-items: center; gap: 6px; font-size: 13px; color: #999; }
        .step-dot { width: 24px; height: 24px; border-radius: 50%; background: #f0f0f0; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; color: #999; }
        .step-item.active .step-dot { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .step-item.active { color: #667eea; font-weight: 600; }
        .step-line { flex: 0 0 30px; height: 2px; background: #e0e0e0; }

        .form-group { margin-bottom: 16px; }
        .form-label { display: block; margin-bottom: 8px; color: #666; font-size: 14px; }
        .form-input { width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 8px; font-size: 16px; transition: border-color 0.3s; }
        .form-input:focus { outline: none; border-color: #667eea; }
        .form-input.error { border-color: #ff4d4f; }

        .reset-btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 8px; font-size: 18px; font-weight: 600; cursor: pointer; transition: transform 0.3s; margin-top: 4px; }
        .reset-btn:hover { transform: translateY(-2px); }
        .reset-btn:disabled { opacity: 0.7; cursor: not-allowed; transform: none; }
        .btn-secondary { background: #fff; color: #666; border: 2px solid #ddd; margin-top: 10px; }
        .btn-secondary:hover { transform: translateY(-2px); border-color: #667eea; color: #667eea; background: #f8f8f8; }

        .error-message { background: #fee; color: #c33; padding: 10px; border-radius: 5px; margin-bottom: 20px; display: none; font-size: 14px; }
        .info-box { background: #e6f4ff; color: #1677ff; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 13px; border-left: 3px solid #1677ff; }

        .links { margin-top: 20px; text-align: center; }
        .links a { color: #667eea; text-decoration: none; margin: 0 10px; font-size: 14px; }
        .links a:hover { text-decoration: underline; }

        .success-icon { font-size: 64px; text-align: center; margin-bottom: 16px; }
    </style>
</head>
<body>
    <div class="main-wrapper">
        <div class="brand-side">
            <div class="brand-icon">🔐</div>
            <div class="brand-title">忘记密码</div>
            <div class="brand-subtitle">安全验证<br>快速找回您的账户</div>
        </div>
        <div class="form-side">
            <div class="reset-container">
                <div id="step1View">
                    <h1 class="reset-title">身份验证</h1>
                    <p class="reset-subtitle">请输入您的注册信息进行身份验证</p>
                    <div class="step-indicator">
                        <div class="step-item active"><div class="step-dot">1</div><span>验证身份</span></div>
                        <div class="step-line"></div>
                        <div class="step-item"><div class="step-dot">2</div><span>设置新密码</span></div>
                    </div>
                    <div class="info-box">💡 请填写注册时使用的手机号、邮箱和真实姓名</div>
                    <div class="error-message" id="errorMsg1"></div>
                    <form onsubmit="event.preventDefault(); goToStep2();">
                        <div class="form-group">
                            <label class="form-label">注册手机号</label>
                            <input type="text" class="form-input" id="phone" placeholder="请输入注册手机号" required maxlength="11">
                        </div>
                        <div class="form-group">
                            <label class="form-label">注册邮箱</label>
                            <input type="email" class="form-input" id="email" placeholder="请输入注册邮箱" required maxlength="50">
                        </div>
                        <div class="form-group">
                            <label class="form-label">真实姓名</label>
                            <input type="text" class="form-input" id="realName" placeholder="请输入注册时的真实姓名" required maxlength="20">
                        </div>
                        <button type="submit" class="reset-btn" id="verifyBtn">下一步</button>
                    </form>
                    <div class="links">
                        <a href="${ctx}/pages/login.jsp">返回登录</a> / <a href="${ctx}/pages/register.jsp">注册新账号</a>
                    </div>
                </div>

                <div id="step2View" style="display:none;">
                    <h1 class="reset-title">设置新密码</h1>
                    <p class="reset-subtitle">请设置您的新密码</p>
                    <div class="step-indicator">
                        <div class="step-item active"><div class="step-dot">✓</div><span>验证身份</span></div>
                        <div class="step-line" style="background: linear-gradient(90deg, #667eea, #667eea);"></div>
                        <div class="step-item active"><div class="step-dot">2</div><span>设置新密码</span></div>
                    </div>
                    <div class="error-message" id="errorMsg2"></div>
                    <form onsubmit="event.preventDefault(); doResetPassword();">
                        <div class="form-group">
                            <label class="form-label">新密码</label>
                            <input type="password" class="form-input" id="newPassword" placeholder="请输入新密码（至少6位）" required maxlength="30">
                        </div>
                        <div class="form-group">
                            <label class="form-label">确认新密码</label>
                            <input type="password" class="form-input" id="confirmPassword" placeholder="请再次输入新密码" required maxlength="30">
                        </div>
                        <button type="submit" class="reset-btn" id="resetBtn">确认重置</button>
                    </form>
                    <button class="reset-btn btn-secondary" onclick="goBack()" style="margin-top: 10px;">返回上一步</button>
                    <div class="links">
                        <a href="${ctx}/pages/login.jsp">返回登录</a>
                    </div>
                </div>

                <div id="successView" style="display:none; text-align:center;">
                    <div class="success-icon">✅</div>
                    <h1 class="reset-title">密码重置成功</h1>
                    <p class="reset-subtitle">您的密码已成功重置<br>即将跳转到登录页面...</p>
                    <button class="reset-btn" onclick="goLogin()">立即前往登录</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var ctx = '${ctx}';
        var verifiedPhone = '';
        var verifiedEmail = '';
        var verifiedRealName = '';

        function showError(msgId, text) {
            var el = document.getElementById(msgId);
            el.textContent = text;
            el.style.display = 'block';
        }

        function hideError(msgId) {
            document.getElementById(msgId).style.display = 'none';
        }

        function goToStep2() {
            var phone = document.getElementById('phone').value.trim();
            var email = document.getElementById('email').value.trim();
            var realName = document.getElementById('realName').value.trim();

            hideError('errorMsg1');

            if (!phone) { showError('errorMsg1', '请输入手机号'); return; }
            if (!/^1\d{10}$/.test(phone)) { showError('errorMsg1', '手机号格式不正确'); return; }
            if (!email) { showError('errorMsg1', '请输入邮箱'); return; }
            if (!/^[\w.-]+@[\w.-]+\.\w+$/.test(email)) { showError('errorMsg1', '邮箱格式不正确'); return; }
            if (!realName) { showError('errorMsg1', '请输入真实姓名'); return; }

            verifiedPhone = phone;
            verifiedEmail = email;
            verifiedRealName = realName;

            document.getElementById('step1View').style.display = 'none';
            document.getElementById('step2View').style.display = 'block';
            document.getElementById('newPassword').focus();
        }

        function doResetPassword() {
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = document.getElementById('confirmPassword').value;

            hideError('errorMsg2');

            if (!newPassword || newPassword.length < 6) { showError('errorMsg2', '密码长度至少6位'); return; }
            if (newPassword !== confirmPassword) { showError('errorMsg2', '两次输入的密码不一致'); return; }

            var btn = document.getElementById('resetBtn');
            btn.disabled = true; btn.textContent = '处理中...';

            var params = new URLSearchParams();
            params.append('phone', verifiedPhone);
            params.append('email', verifiedEmail);
            params.append('realName', verifiedRealName);
            params.append('newPassword', newPassword);

            fetch(ctx + '/api/user/forgotPassword', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            }).then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) {
                    document.getElementById('step2View').style.display = 'none';
                    document.getElementById('successView').style.display = 'block';
                    setTimeout(goLogin, 2500);
                } else {
                    showError('errorMsg2', res.message || '密码重置失败');
                    btn.disabled = false; btn.textContent = '确认重置';
                }
            }).catch(function() {
                showError('errorMsg2', '网络错误，请重试');
                btn.disabled = false; btn.textContent = '确认重置';
            });
        }

        function goBack() {
            document.getElementById('step2View').style.display = 'none';
            document.getElementById('step1View').style.display = 'block';
        }

        function goLogin() {
            window.location.href = ctx + '/pages/login.jsp';
        }
    </script>
</body>
</html>