package com.student.util;

import com.alibaba.druid.pool.DruidDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DBUtil {
    private static final Logger logger = LoggerFactory.getLogger(DBUtil.class);
    private static final DruidDataSource dataSource;

    static {
        Properties props = new Properties();
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new RuntimeException("找不到db.properties配置文件");
            }
            props.load(in);
        } catch (Exception e) {
            logger.error("加载数据库配置文件失败", e);
            throw new RuntimeException("加载数据库配置文件失败", e);
        }

        dataSource = new DruidDataSource();
        dataSource.setDriverClassName(props.getProperty("jdbc.driver"));
        dataSource.setUrl(props.getProperty("jdbc.url"));
        dataSource.setUsername(props.getProperty("jdbc.username"));
        dataSource.setPassword(props.getProperty("jdbc.password"));

        // 连接池配置
        dataSource.setInitialSize(Integer.parseInt(props.getProperty("druid.initialSize", "5")));
        dataSource.setMinIdle(Integer.parseInt(props.getProperty("druid.minIdle", "5")));
        dataSource.setMaxActive(Integer.parseInt(props.getProperty("druid.maxActive", "20")));
        dataSource.setMaxWait(Long.parseLong(props.getProperty("druid.maxWait", "60000")));

        // 连接检测
        dataSource.setValidationQuery(props.getProperty("druid.validationQuery", "SELECT 1"));
        dataSource.setTestWhileIdle(Boolean.parseBoolean(props.getProperty("druid.testWhileIdle", "true")));
        dataSource.setTimeBetweenEvictionRunsMillis(
                Long.parseLong(props.getProperty("druid.timeBetweenEvictionRunsMillis", "60000")));
        dataSource.setMinEvictableIdleTimeMillis(
                Long.parseLong(props.getProperty("druid.minEvictableIdleTimeMillis", "300000")));

        logger.info("数据库连接池初始化完成");
    }

    // 获取连接
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // 开启事务
    public static void beginTransaction(Connection conn) throws SQLException {
        if (conn != null) conn.setAutoCommit(false);
    }

    // 提交事务
    public static void commit(Connection conn) throws SQLException {
        if (conn != null) conn.commit();
    }

    // 回滚事务
    public static void rollback(Connection conn) throws SQLException {
        if (conn != null) conn.rollback();
    }

    // Service层单独关闭连接
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException e) {
            logger.error("关闭连接失败", e);
        }
    }

    // DAO层关闭ResultSet、Statement、Connection
    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { logger.error("关闭ResultSet失败", e); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { logger.error("关闭Statement失败", e); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { logger.error("关闭Connection失败", e); }
    }
}