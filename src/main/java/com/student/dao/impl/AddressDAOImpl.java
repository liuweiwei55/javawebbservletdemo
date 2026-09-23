package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.AddressDAO;
import com.student.entity.Address;
import com.student.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class AddressDAOImpl extends BaseDAO<Address> implements AddressDAO {
    private static final Logger logger = LoggerFactory.getLogger(AddressDAOImpl.class);

    @Override
    protected Class<Address> getEntityClass() {
        return Address.class;
    }

    @Override
    public int insert(Address address) {
        return super.insert(address);
    }

    @Override
    public int update(Address address) {
        return super.update(address);
    }

    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }

    @Override
    public Address findById(Integer id) {
        return super.findById(id);
    }

    @Override
    public List<Address> getByUserId(Integer userId) {
        String sql = "SELECT * FROM `t_address` WHERE user_id = ? ORDER BY create_time DESC";
        return executeQueryForList(sql, userId);
    }

    @Override
    public Address getDefaultAddress(Integer userId) {
        String sql = "SELECT * FROM `t_address` WHERE user_id = ? AND is_default = 1";
        return executeQueryForObject(sql, userId);
    }

    @Override
    public int setDefaultAddress(Integer userId, Integer addressId) {
        String sql1 = "UPDATE `t_address` SET is_default = 0 WHERE user_id = ?";
        String sql2 = "UPDATE `t_address` SET is_default = 1 WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int rows;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setInt(1, userId);
            pstmt1.executeUpdate();

            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setInt(1, addressId);
            rows = pstmt2.executeUpdate();

            conn.commit();
            return rows;
        } catch (Exception e) {
            logger.error("设置默认地址事务异常", e);
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                logger.error("事务回滚失败", ex);
            }
            throw new RuntimeException("设置默认地址失败", e);
        } finally {
            DBUtil.close(null, pstmt1, null);
            DBUtil.close(null, pstmt2, conn);
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    logger.error("重置自动提交失败", e);
                }
            }
        }
    }
}