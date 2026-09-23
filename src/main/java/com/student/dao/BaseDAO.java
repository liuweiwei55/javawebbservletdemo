package com.student.dao;

import com.student.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public abstract class BaseDAO<T> {
    protected static final Logger logger = LoggerFactory.getLogger(BaseDAO.class);

    protected abstract Class<T> getEntityClass();

    public T findById(Integer id) {
        String tableName = "`t_" + getEntityClass().getSimpleName().toLowerCase() + "`";
        String sql = "SELECT * FROM " + tableName + " WHERE id = ?";
        return executeQueryForObject(sql, id);
    }

    public int delete(Integer id) {
        String tableName = "`t_" + getEntityClass().getSimpleName().toLowerCase() + "`";
        String sql = "DELETE FROM " + tableName + " WHERE id = ?";
        return executeUpdate(sql, id);
    }

    public List<T> findAll(int pageNum, int pageSize) {
        String tableName = "`t_" + getEntityClass().getSimpleName().toLowerCase() + "`";
        String sql = "SELECT * FROM " + tableName + " ORDER BY id DESC LIMIT ?,?";
        int offset = (pageNum - 1) * pageSize;
        return executeQueryForList(sql, offset, pageSize);
    }

    public List<T> findAll() {
        String tableName = "`t_" + getEntityClass().getSimpleName().toLowerCase() + "`";
        String sql = "SELECT * FROM " + tableName + " ORDER BY id DESC";
        return executeQueryForList(sql);
    }

    public long count() {
        String tableName = "`t_" + getEntityClass().getSimpleName().toLowerCase() + "`";
        String sql = "SELECT COUNT(*) FROM " + tableName;
        return executeQueryForCount(sql);
    }

    public int insert(T entity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class<?> clazz = getEntityClass();
            Field[] fields = clazz.getDeclaredFields();
            List<String> colNames = new ArrayList<>();
            List<String> placeholders = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            for (Field field : fields) {
                field.setAccessible(true);
                String fieldName = field.getName();
                if ("id".equals(fieldName)) continue;
                if (java.lang.reflect.Modifier.isTransient(field.getModifiers())) continue;
                Object value = field.get(entity);
                if (value == null) continue;
                String column = toUnderline(fieldName);
                colNames.add("`" + column + "`");
                placeholders.add("?");
                params.add(value);
            }

            String tableName = "`t_" + clazz.getSimpleName().toLowerCase() + "`";
            String sql = "INSERT INTO " + tableName + " (" + String.join(",", colNames) + ") VALUES (" + String.join(",", placeholders) + ")";

            conn = DBUtil.getConnection();
            System.out.println("=== BaseDAO.insert SQL: " + sql);
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < params.size(); i++) {
                Object value = params.get(i);
                if (value instanceof Date) {
                    value = new Timestamp(((Date) value).getTime());
                }
                pstmt.setObject(i + 1, value);
                System.out.println("  param[" + i + "] = " + value + " (" + (value != null ? value.getClass().getSimpleName() : "null") + ")");
            }
            int rows = pstmt.executeUpdate();

            // 回填自增主键到实体对象
            if (rows > 0) {
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) {
                    Field idField = clazz.getDeclaredField("id");
                    idField.setAccessible(true);
                    idField.set(entity, keys.getInt(1));
                }
            }
            return rows;
        } catch (Exception e) {
            logger.error("通用插入失败", e);
            throw new RuntimeException("通用插入实体失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    public int update(T entity) {
        try {
            Class<?> clazz = getEntityClass();
            Field idField = clazz.getDeclaredField("id");
            idField.setAccessible(true);
            Integer id = (Integer) idField.get(entity);
            if (id == null) {
                throw new RuntimeException("更新实体id不能为空");
            }

            Field[] fields = clazz.getDeclaredFields();
            List<String> setSql = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            for (Field field : fields) {
                field.setAccessible(true);
                String fieldName = field.getName();
                if ("id".equals(fieldName)) continue;
                if (java.lang.reflect.Modifier.isTransient(field.getModifiers())) continue;
                String column = toUnderline(fieldName);
                setSql.add("`" + column + "` = ?");
                params.add(field.get(entity));
            }
            params.add(id);

            String tableName = "`t_" + clazz.getSimpleName().toLowerCase() + "`";
            String sql = "UPDATE " + tableName + " SET " + String.join(",", setSql) + " WHERE id = ?";
            return executeUpdate(sql, params.toArray());
        } catch (Exception e) {
            logger.error("通用更新失败", e);
            throw new RuntimeException("通用更新实体失败", e);
        }
    }

    protected int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, params[i]);
                }
            }
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("执行更新操作失败，sql:{}", sql, e);
            throw new RuntimeException("执行更新操作失败", e);
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    protected T executeQueryForObject(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, params[i]);
                }
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToEntity(rs);
            }
            return null;
        } catch (SQLException e) {
            logger.error("查询单条数据失败，sql:{}", sql, e);
            throw new RuntimeException("查询单条数据失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    protected List<T> executeQueryForList(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, params[i]);
                }
            }
            rs = pstmt.executeQuery();
            List<T> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
            return list;
        } catch (SQLException e) {
            logger.error("查询列表失败，sql:{}", sql, e);
            throw new RuntimeException("查询列表失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    protected long executeQueryForCount(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, params[i]);
                }
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.error("统计总数失败，sql:{}", sql, e);
            throw new RuntimeException("统计总数失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    protected String executeQueryForScalar(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, params[i]);
                }
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
            return null;
        } catch (SQLException e) {
            logger.error("查询标量失败，sql:{}", sql, e);
            throw new RuntimeException("查询标量失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    private T mapResultSetToEntity(ResultSet rs) throws SQLException {
        T entity;
        try {
            entity = getEntityClass().getDeclaredConstructor().newInstance();
        } catch (Exception e) {
            logger.error("实体缺少无参构造，映射失败", e);
            throw new RuntimeException("实体必须提供public无参构造", e);
        }

        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        
        // 调试日志：打印所有列名和值
        if ("t_order".equalsIgnoreCase(metaData.getTableName(1))) {
            logger.info("=== BaseDAO.mapResultSetToEntity - Order表 ===");
        }
        
        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnName(i);
            Object value = rs.getObject(i);
            
            // 调试日志：打印 payment_time 和 refund_reason 字段
            if ("payment_time".equalsIgnoreCase(columnName) || "refund_reason".equalsIgnoreCase(columnName)) {
                logger.info("字段: {}, 值: {}, 类型: {}", columnName, value, value != null ? value.getClass().getName() : "null");
            }
            
            if (value == null) continue;

            String fieldName = toCamelCase(columnName);
            try {
                Field field = getEntityClass().getDeclaredField(fieldName);
                
                // 调试日志：打印 paymentTime 和 refundReason 字段映射
                if ("paymentTime".equals(fieldName) || "refundReason".equals(fieldName)) {
                    logger.info("映射字段: {} -> {}, 字段类型: {}", columnName, fieldName, field.getType().getName());
                }
                
                setFieldValueWithSetter(entity, field, value);
            } catch (NoSuchFieldException ignored) {
                // 调试日志：打印跳过的字段
                if ("payment_time".equalsIgnoreCase(columnName) || "refund_reason".equalsIgnoreCase(columnName)) {
                    logger.warn("字段未找到: {} -> {}", columnName, fieldName);
                }
            } catch (Exception e) {
                logger.warn("字段映射跳过: {} -> 原因: {}", fieldName, e.getMessage());
            }
        }
        return entity;
    }

    private void setFieldValueWithSetter(T entity, Field field, Object value) {
        Class<?> fieldType = field.getType();
        Object convertedValue = convertFieldValue(value, fieldType);

        String fieldName = field.getName();
        String setterName = "set" + Character.toUpperCase(fieldName.charAt(0)) + fieldName.substring(1);
        try {
            Method setter = getEntityClass().getMethod(setterName, fieldType);
            setter.invoke(entity, convertedValue);
            return;
        } catch (NoSuchMethodException ignored) {
        } catch (Exception e) {
            logger.warn("Setter调用失败: {} -> 原因: {}", setterName, e.getMessage());
        }

        try {
            field.setAccessible(true);
            field.set(entity, convertedValue);
        } catch (Exception e) {
            logger.warn("字段设置失败: {} -> 原因: {}", fieldName, e.getMessage());
        }
    }

    private Object convertFieldValue(Object value, Class<?> fieldType) {
        if (fieldType == Integer.class || fieldType == int.class) {
            if (value instanceof Number) {
                return ((Number) value).intValue();
            } else if (value instanceof Boolean) {
                return ((Boolean) value) ? 1 : 0;
            } else {
                return Integer.parseInt(value.toString());
            }
        } else if (fieldType == Long.class || fieldType == long.class) {
            if (value instanceof Number) {
                return ((Number) value).longValue();
            } else {
                return Long.parseLong(value.toString());
            }
        } else if (fieldType == Double.class || fieldType == double.class) {
            if (value instanceof Number) {
                return ((Number) value).doubleValue();
            } else {
                return Double.parseDouble(value.toString());
            }
        } else if (fieldType == Float.class || fieldType == float.class) {
            if (value instanceof Number) {
                return ((Number) value).floatValue();
            } else {
                return Float.parseFloat(value.toString());
            }
        } else if (fieldType == Boolean.class || fieldType == boolean.class) {
            if (value instanceof Number) {
                return ((Number) value).intValue() != 0;
            } else if (value instanceof Boolean) {
                return value;
            } else {
                return Boolean.parseBoolean(value.toString());
            }
        } else if (fieldType == java.util.Date.class) {
            if (value instanceof java.sql.Timestamp) {
                return new java.util.Date(((java.sql.Timestamp) value).getTime());
            } else if (value instanceof java.sql.Date) {
                return new java.util.Date(((java.sql.Date) value).getTime());
            } else if (value instanceof java.time.LocalDateTime) {
                return java.util.Date.from(((java.time.LocalDateTime) value).atZone(java.time.ZoneId.systemDefault()).toInstant());
            } else {
                return value;
            }
        } else if (fieldType == String.class) {
            return value.toString();
        } else {
            return value;
        }
    }

    private String toCamelCase(String name) {
        StringBuilder result = new StringBuilder();
        boolean nextUpper = false;
        for (char c : name.toCharArray()) {
            if (c == '_') {
                nextUpper = true;
            } else if (nextUpper) {
                result.append(Character.toUpperCase(c));
                nextUpper = false;
            } else {
                result.append(c);
            }
        }
        return result.toString();
    }

    private String toUnderline(String name) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < name.length(); i++) {
            char c = name.charAt(i);
            if (Character.isUpperCase(c)) {
                sb.append("_");
                sb.append(Character.toLowerCase(c));
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}