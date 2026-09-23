package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.UserDAO;
import com.student.entity.User;
import com.student.util.DBUtil;
import com.student.util.MD5Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class UserDAOImpl extends BaseDAO<User> implements UserDAO {

    @Override
    protected Class<User> getEntityClass() {
        return User.class;
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO t_user (username, password, real_name, phone, email, avatar, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRealName());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getEmail());
            pstmt.setString(6, user.getAvatar());
            pstmt.setInt(7, user.getRole() != null ? user.getRole() : 0);
            pstmt.setInt(8, user.getStatus() != null ? user.getStatus() : 1);
            int rows = pstmt.executeUpdate();
            // 回填自增主键
            if (rows > 0) {
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) {
                    user.setId(keys.getInt(1));
                }
            }
            return rows;
        } catch (Exception e) {
            logger.error("插入用户失败", e);
            throw new RuntimeException("插入用户失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    @Override
    public int update(User user) {
        String sql = "UPDATE t_user SET username=?, real_name=?, phone=?, email=?, avatar=?, role=?, status=? " +
                "WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getRealName());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getAvatar());
            pstmt.setInt(6, user.getRole() != null ? user.getRole() : 0);
            pstmt.setInt(7, user.getStatus() != null ? user.getStatus() : 1);
            pstmt.setInt(8, user.getId());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            logger.error("更新用户失败", e);
            throw new RuntimeException("更新用户失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }

    @Override
    public User findById(Integer id) {
        return super.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM t_user WHERE username = ?";
        return executeQueryForObject(sql, username);
    }

    @Override
    public User findByPhoneAndEmail(String phone, String email) {
        String sql = "SELECT * FROM t_user WHERE phone = ? AND email = ?";
        return executeQueryForObject(sql, phone, email);
    }

    @Override
    public User login(String username, String password) {
        String encryptedPassword = MD5Util.encrypt(password);
        String sql = "SELECT * FROM t_user WHERE username = ? AND password = ? AND status = 1";
        User user = executeQueryForObject(sql, username, encryptedPassword);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public int updatePassword(Integer userId, String newPassword) {
        String encryptedPassword = MD5Util.encrypt(newPassword);
        String sql = "UPDATE t_user SET password = ? WHERE id = ?";
        return executeUpdate(sql, encryptedPassword, userId);
    }

    @Override
    public String queryPasswordById(Integer userId) {
        String sql = "SELECT password FROM t_user WHERE id = ?";
        return executeQueryForScalar(sql, userId);
    }
}