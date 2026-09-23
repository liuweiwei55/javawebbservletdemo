package com.student.controller;

import com.student.entity.User;
import com.student.service.UserService;
import com.student.service.impl.UserServiceImpl;
import com.student.util.DBUtil;
import com.student.util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@WebServlet("/api/user/*")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class UserServlet extends BaseServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            sendErrorResponse(response, 400, "无效的请求路径");
            return;
        }

        switch (path) {
            case "/info":
            case "/detail":
                getUserInfo(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            sendErrorResponse(response, 400, "无效的请求路径");
            return;
        }

        switch (path) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            case "/forgotPassword":
                forgotPassword(request, response);
                break;
            case "/password":
            case "/changePassword":
                updatePassword(request, response);
                break;
            case "/info":
            case "/update":
                updateUserInfo(request, response);
                break;
            case "/uploadAvatar":
                uploadAvatar(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String roleParam = request.getParameter("role");
            String rememberMe = request.getParameter("rememberMe");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                sendErrorResponse(response, 400, "用户名和密码不能为空");
                return;
            }

            User user = userService.login(username.trim(), password);

            if (user != null) {
                if (user.getStatus() == 0) {
                    sendErrorResponse(response, 403, "账号已被禁用");
                    return;
                }

                if (roleParam != null && !roleParam.isEmpty()) {
                    int selectedRole = Integer.parseInt(roleParam);
                    if (user.getRole() != selectedRole) {
                        sendErrorResponse(response, 403, "角色选择错误");
                        return;
                    }
                }

                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                if (user.getAvatar() != null && !user.getAvatar().trim().isEmpty()) {
                    session.setAttribute("avatar", user.getAvatar());
                }

                // 处理上次登录时间
                try (Connection conn = DBUtil.getConnection()) {
                    try (PreparedStatement ps = conn.prepareStatement("SELECT last_login_time FROM t_user WHERE id = ?")) {
                        ps.setInt(1, user.getId());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                Timestamp lastLogin = rs.getTimestamp("last_login_time");
                                if (lastLogin != null) {
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
                                    session.setAttribute("lastLoginTime", sdf.format(lastLogin));
                                }
                            }
                        }
                    }
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE t_user SET last_login_time = NOW() WHERE id = ?")) {
                        ps.setInt(1, user.getId());
                        ps.executeUpdate();
                    }
                } catch (SQLException e) {
                    // 忽略 last_login_time 相关错误（可能字段不存在）
                }

                if (rememberMe != null && !rememberMe.isEmpty() && !"0".equals(rememberMe)) {
                    int days = Integer.parseInt(rememberMe);
                    long expireTime = System.currentTimeMillis() + days * 24L * 60 * 60 * 1000;

                    Cookie userIdCookie = new Cookie("autoLoginUserId", String.valueOf(user.getId()));
                    Cookie expireCookie = new Cookie("autoLoginExpire", String.valueOf(expireTime));

                    userIdCookie.setMaxAge(days * 24 * 60 * 60);
                    expireCookie.setMaxAge(days * 24 * 60 * 60);
                    userIdCookie.setPath("/");
                    expireCookie.setPath("/");

                    response.addCookie(userIdCookie);
                    response.addCookie(expireCookie);
                }

                user.setPassword(null);
                sendSuccessResponse(response, "登录成功", user);
            } else {
                sendErrorResponse(response, 401, "用户名或密码错误");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "登录失败: " + e.getMessage());
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String realName = request.getParameter("realName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String agreement = request.getParameter("agreement");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                sendErrorResponse(response, 400, "用户名和密码不能为空");
                return;
            }

            if (agreement == null || !"on".equals(agreement)) {
                sendErrorResponse(response, 400, "请先阅读并同意《用户协议》");
                return;
            }

            User existUser = userService.getUserByUsername(username.trim());
            if (existUser != null) {
                sendErrorResponse(response, 400, "用户名已存在");
                return;
            }

            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(MD5Util.encrypt(password));
            user.setRealName(realName);
            user.setPhone(phone);
            user.setEmail(email);
            user.setRole(0);
            user.setStatus(1);

            boolean result = userService.register(user);

            if (result) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());

                user.setPassword(null);
                sendSuccessResponse(response, "注册成功", user);
            } else {
                sendErrorResponse(response, 500, "注册失败");
            }
        } catch (Exception e) {
            // 数据库唯一约束冲突等SQL异常
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                sendErrorResponse(response, 400, "用户名已存在");
                return;
            }
            sendErrorResponse(response, 500, "注册失败: " + e.getMessage());
        }
    }

    private void getUserInfo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            User user = userService.getUserById(userId);

            if (user != null) {
                user.setPassword(null);
                sendSuccessResponse(response, "获取成功", user);
            } else {
                sendErrorResponse(response, 404, "用户不存在");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取用户信息失败: " + e.getMessage());
        }
    }

    private void updateUserInfo(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            String username = request.getParameter("username");
            String realName = request.getParameter("realName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String avatar = request.getParameter("avatar");

            User user = userService.getUserById(userId);
            if (user == null) {
                sendErrorResponse(response, 404, "用户不存在");
                return;
            }

            if (username != null && !username.trim().isEmpty()) {
                user.setUsername(username.trim());
                session.setAttribute("username", username.trim());
            }
            if (realName != null) user.setRealName(realName);
            if (phone != null) user.setPhone(phone);
            if (email != null) user.setEmail(email);
            if (avatar != null) {
                user.setAvatar(avatar);
                session.setAttribute("avatar", avatar);
            }

            boolean result = userService.updateUserInfo(user);

            if (result) {
                sendSuccessResponse(response, "更新成功", null);
            } else {
                sendErrorResponse(response, 500, "更新失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "更新用户信息失败: " + e.getMessage());
        }
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");

            if (oldPassword == null || oldPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {
                sendErrorResponse(response, 400, "密码不能为空");
                return;
            }

            if (oldPassword.equals(newPassword)) {
                sendErrorResponse(response, 400, "新密码不能与旧密码相同");
                return;
            }

            boolean result = userService.updatePassword(userId, oldPassword, newPassword);

            if (result) {
                sendSuccessResponse(response, "修改密码成功", null);
            } else {
                sendErrorResponse(response, 400, "原密码错误或修改失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "修改密码失败: " + e.getMessage());
        }
    }

    private void uploadAvatar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Part avatarPart = request.getPart("avatar");
            if (avatarPart == null || avatarPart.getSize() == 0) {
                sendErrorResponse(response, 400, "请选择图片文件");
                return;
            }

            String originalName = avatarPart.getSubmittedFileName();
            String ext = "";
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf("."));
            }
            String fileName = System.currentTimeMillis() + ext;
            
            byte[] fileBytes = avatarPart.getInputStream().readAllBytes();

            String uploadPath = request.getServletContext().getRealPath("/images/avatars");
            if (uploadPath == null) {
                uploadPath = System.getProperty("java.io.tmpdir") + File.separator + "avatars";
            }
            new File(uploadPath).mkdirs();
            java.nio.file.Files.write(java.nio.file.Paths.get(uploadPath, fileName), fileBytes);

            String projectRoot = System.getProperty("user.dir");
            String srcPath = projectRoot + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images" + File.separator + "avatars";
            new File(srcPath).mkdirs();
            java.nio.file.Files.write(java.nio.file.Paths.get(srcPath, fileName), fileBytes);

            User user = userService.getUserById(userId);
            user.setAvatar(fileName);
            boolean updated = userService.updateUserInfo(user);

            if (!updated) {
                sendErrorResponse(response, 500, "头像信息保存失败");
                return;
            }

            session.setAttribute("avatar", fileName);

            sendSuccessResponse(response, "头像上传成功", fileName);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "头像上传失败: " + e.getMessage());
        }
    }

    private String getFileName(Part part) {
        String header = part.getHeader("Content-Disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 2, token.length() - 1);
            }
        }
        return "unknown";
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Cookie userIdCookie = new Cookie("autoLoginUserId", "");
            Cookie expireCookie = new Cookie("autoLoginExpire", "");
            userIdCookie.setMaxAge(0);
            expireCookie.setMaxAge(0);
            userIdCookie.setPath("/");
            expireCookie.setPath("/");
            response.addCookie(userIdCookie);
            response.addCookie(expireCookie);

            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            sendSuccessResponse(response, "退出成功", null);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "退出失败: " + e.getMessage());
        }
    }

    private void forgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String realName = request.getParameter("realName");
            String newPassword = request.getParameter("newPassword");

            if (phone == null || phone.trim().isEmpty()) {
                sendErrorResponse(response, 400, "手机号不能为空");
                return;
            }
            if (email == null || email.trim().isEmpty()) {
                sendErrorResponse(response, 400, "邮箱不能为空");
                return;
            }
            if (realName == null || realName.trim().isEmpty()) {
                sendErrorResponse(response, 400, "真实姓名不能为空");
                return;
            }
            if (newPassword == null || newPassword.trim().isEmpty()) {
                sendErrorResponse(response, 400, "新密码不能为空");
                return;
            }
            if (newPassword.length() < 6) {
                sendErrorResponse(response, 400, "密码长度至少6位");
                return;
            }

            boolean result = userService.resetPasswordByPhoneAndEmail(phone.trim(), email.trim(), realName.trim(), newPassword);
            if (result) {
                sendSuccessResponse(response, "密码重置成功，请重新登录", null);
            } else {
                sendErrorResponse(response, 400, "身份验证失败：手机号、邮箱或真实姓名不匹配");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "密码重置失败: " + e.getMessage());
        }
    }
}