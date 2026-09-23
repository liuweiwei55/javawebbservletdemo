package com.student.service.impl;

import com.student.dao.CommentDAO;
import com.student.dao.UserDAO;
import com.student.dao.impl.CommentDAOImpl;
import com.student.dao.impl.UserDAOImpl;
import com.student.entity.User;
import com.student.service.UserService;
import com.student.util.MD5Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
    private final UserDAO userDAO = new UserDAOImpl();
    private final CommentDAO commentDAO = new CommentDAOImpl();

    @Override
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }

        User user = userDAO.login(username, password);
        if (user != null) {
            logger.info("用户登录成功: {}", username);
        } else {
            logger.warn("用户登录失败: {}", username);
        }
        return user;
    }

    @Override
    public boolean register(User user) {
        if (user == null) {
            throw new IllegalArgumentException("用户信息不能为空");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }

        int result = userDAO.insert(user);
        logger.info("用户注册: {}, 结果: {}", user.getUsername(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public User getUserById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        User user = userDAO.findById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        User user = userDAO.findByUsername(username);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public User getUserByPhoneAndEmail(String phone, String email) {
        if (phone == null || phone.trim().isEmpty()) {
            throw new IllegalArgumentException("手机号不能为空");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("邮箱不能为空");
        }
        User user = userDAO.findByPhoneAndEmail(phone.trim(), email.trim());
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public boolean verifyUserByPhoneAndEmail(String phone, String email, String realName) {
        User user = getUserByPhoneAndEmail(phone, email);
        if (user == null) {
            logger.warn("验证用户失败: 手机号和邮箱未匹配到用户");
            return false;
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            logger.warn("验证用户失败: 用户已被禁用, userId={}", user.getId());
            return false;
        }
        if (realName == null || realName.trim().isEmpty()) {
            logger.warn("验证用户失败: 真实姓名为空");
            return false;
        }
        boolean matched = realName.trim().equals(user.getRealName());
        logger.info("验证用户: userId={}, 结果: {}", user.getId(), matched ? "成功" : "失败");
        return matched;
    }

    @Override
    public boolean resetPasswordByPhoneAndEmail(String phone, String email, String realName, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("密码长度至少6位");
        }
        if (!verifyUserByPhoneAndEmail(phone, email, realName)) {
            logger.warn("重置密码失败: 身份验证未通过");
            return false;
        }
        User user = getUserByPhoneAndEmail(phone, email);
        if (user == null) {
            return false;
        }
        int result = userDAO.updatePassword(user.getId(), newPassword);
        logger.info("通过手机号+邮箱重置密码: userId={}, 结果: {}", user.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updatePassword(Integer userId, String oldPassword, String newPassword) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("原密码不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }
        if (oldPassword.equals(newPassword)) {
            throw new IllegalArgumentException("新密码不能与旧密码相同");
        }

        String storedPwd = ((UserDAOImpl)userDAO).queryPasswordById(userId);
        if (storedPwd == null || storedPwd.isEmpty()) {
            logger.error("修改密码失败: userId={}, 数据库中密码为空", userId);
            return false;
        }

        String encryptedOldPassword = MD5Util.encrypt(oldPassword);
        if (!storedPwd.equals(encryptedOldPassword)) {
            logger.warn("修改密码失败: userId={}, 旧密码不匹配, storedHash={}, inputHash={}",
                    userId, storedPwd.substring(0, Math.min(6, storedPwd.length())),
                    encryptedOldPassword.substring(0, Math.min(6, encryptedOldPassword.length())));
            return false;
        }

        int result = userDAO.updatePassword(userId, newPassword);
        logger.info("修改密码: userId={}, 结果: {}", userId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updateUserInfo(User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("用户信息不完整");
        }
        int result = userDAO.update(user);
        logger.info("更新用户信息: userId={}, 结果: {}", user.getId(), result > 0 ? "成功" : "失败");
        
        if (result > 0 && user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            try {
                int commentUpdated = commentDAO.updateUsernameByUserId(user.getId(), user.getUsername());
                logger.info("更新评论表用户名: userId={}, 评论数={}", user.getId(), commentUpdated);
            } catch (Exception e) {
                logger.error("同步更新评论表用户名失败: userId={}", user.getId(), e);
            }
        }
        return result > 0;
    }

    @Override
    public boolean resetPassword(Integer userId, String newPassword) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("密码长度至少6位");
        }
        int result = userDAO.updatePassword(userId, newPassword);
        logger.info("重置密码: userId={}, 结果: {}", userId, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteUser(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        int result = userDAO.delete(id);
        logger.info("删除用户: userId={}, 结果: {}", id, result > 0 ? "成功" : "失败");
        return result > 0;
    }
}