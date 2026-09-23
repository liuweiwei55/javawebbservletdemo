package com.student.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.student.service.*;
import com.student.service.impl.*;
import com.student.util.DBUtil;
import com.student.util.MD5Util;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.lang.reflect.Modifier;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

@WebServlet("/api/admin/*")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class AdminServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AdminServlet.class);
    private static final Gson gson = new GsonBuilder().excludeFieldsWithModifiers(Modifier.STATIC).create();

    private final ProductService productService = new ProductServiceImpl();
    private final CategoryService categoryService = new CategoryServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();
    private final UserService userService = new UserServiceImpl();
    private final CommentService commentService = new CommentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        // 密码重置接口不需要登录
        if ("/findByPhoneOrEmail".equals(path)) {
            findByPhoneOrEmail(req, resp);
            return;
        }
        HttpSession session = req.getSession();
        if (session.getAttribute("role") == null || !"1".equals(String.valueOf(session.getAttribute("role")))) {
            sendJson(resp, 403, "无权限访问");
            return;
        }
        try {
            if ("/dashboard".equals(path)) dashboard(req, resp);
            else if ("/product/list".equals(path)) productList(req, resp);
            else if ("/stock/list".equals(path)) stockList(req, resp);
            else if ("/stock/logs".equals(path)) stockLogs(req, resp);
            else if ("/comment/list".equals(path)) commentList(req, resp);
            else if ("/user/list".equals(path)) userList(req, resp);
            else if ("/user/detail".equals(path)) userDetail(req, resp);
            else if ("/order/list".equals(path)) orderList(req, resp);
            else if ("/stats/overview".equals(path)) statsOverview(req, resp);
            else if ("/stats/daily".equals(path)) statsDaily(req, resp);
            else if ("/stats/monthly".equals(path)) statsMonthly(req, resp);
            else if ("/stats/topProducts".equals(path)) statsTopProducts(req, resp);
            else if ("/stats/userStats".equals(path)) statsUserStats(req, resp);
            else if ("/stats/todayDetail".equals(path)) statsTodayDetail(req, resp);
            else if ("/stats/weekDetail".equals(path)) statsWeekDetail(req, resp);
            else if ("/stats/monthDetail".equals(path)) statsMonthDetail(req, resp);
            else if ("/stats/newUsers".equals(path)) statsNewUsers(req, resp);
            else if ("/stats/totalDetail".equals(path)) statsTotalDetail(req, resp);
            else if ("/stats/daySalesDetail".equals(path)) statsDaySalesDetail(req, resp);
            else if ("/stats/monthSalesDetail".equals(path)) statsMonthSalesDetail(req, resp);
            else if ("/logs/list".equals(path)) logsList(req, resp);
            else if ("/category/delete".equals(path)) categoryDelete(req, resp);
            else if ("/product/delete".equals(path)) productDelete(req, resp);
            else if ("/comment/delete".equals(path)) commentDelete(req, resp);
            else if ("/comment/restore".equals(path)) commentRestore(req, resp);
            else if ("/comment/reply/delete".equals(path)) commentReplyDelete(req, resp);
            else if ("/user/export".equals(path)) userExport(req, resp);
            else sendJson(resp, 404, "接口不存在");
        } catch (Exception e) {
            logger.error("Admin GET error", e);
            sendJson(resp, 500, "服务器错误: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        // 密码重置接口不需要登录
        if ("/resetPasswordByVerification".equals(path)) {
            resetPasswordByVerification(req, resp);
            return;
        }
        HttpSession session = req.getSession();
        if (session.getAttribute("role") == null || !"1".equals(String.valueOf(session.getAttribute("role")))) {
            sendJson(resp, 403, "无权限访问");
            return;
        }
        try {
            if ("/category/save".equals(path)) categorySave(req, resp);
            else if ("/product/save".equals(path)) productSave(req, resp);
            else if ("/product/status".equals(path)) productStatus(req, resp);
            else if ("/product/batchStatus".equals(path)) productBatchStatus(req, resp);
            else if ("/stock/adjust".equals(path)) stockAdjust(req, resp);
            else if ("/comment/reply".equals(path)) commentReply(req, resp);
            else if ("/user/resetPassword".equals(path)) userResetPassword(req, resp);
            else if ("/user/update".equals(path)) userUpdate(req, resp);
            else if ("/user/add".equals(path)) userAdd(req, resp);
            else if ("/user/delete".equals(path)) userDelete(req, resp);
            else if ("/order/ship".equals(path)) orderShip(req, resp);
            else if ("/order/refund".equals(path)) orderRefund(req, resp);
            else if ("/order/remark".equals(path)) orderRemark(req, resp);
            else if ("/user/address/add".equals(path)) userAddressAdd(req, resp);
            else if ("/user/address/update".equals(path)) userAddressUpdate(req, resp);
            else if ("/user/address/delete".equals(path)) userAddressDelete(req, resp);
            else if ("/user/address/default".equals(path)) userAddressDefault(req, resp);
            else if ("/user/address/detail".equals(path)) userAddressDetail(req, resp);
            else sendJson(resp, 404, "接口不存在");
        } catch (Exception e) {
            logger.error("Admin POST error", e);
            sendJson(resp, 500, "服务器错误: " + e.getMessage());
        }
    }

    // ==================== 控制台 ====================
    private void dashboard(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            // 商品总数
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_product WHERE status=1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.addProperty("totalProducts", rs.getInt(1));
            }
            // 总订单数
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_order");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.addProperty("totalOrders", rs.getInt(1));
            }
            // 总销售额
            try (PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.addProperty("totalSales", rs.getDouble(1));
            }
            // 用户总数
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_user WHERE status=1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) data.addProperty("totalUsers", rs.getInt(1));
            }
            // 最近7天销售
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DATE(create_time) as dt, COALESCE(SUM(actual_amount),0) as amt FROM t_order WHERE create_time >= DATE_SUB(CURDATE(),INTERVAL 7 DAY) AND status IN(1,2,3) GROUP BY dt ORDER BY dt");
                 ResultSet rs = ps.executeQuery()) {
                List<JsonObject> list = new ArrayList<>();
                while (rs.next()) {
                    JsonObject o = new JsonObject();
                    o.addProperty("date", rs.getString("dt"));
                    o.addProperty("amount", rs.getDouble("amt"));
                    list.add(o);
                }
                data.add("recentSales", gson.toJsonTree(list));
            }
            // 热销商品TOP5
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT name, sales_count FROM t_product WHERE status=1 ORDER BY sales_count DESC LIMIT 5");
                 ResultSet rs = ps.executeQuery()) {
                List<JsonObject> list = new ArrayList<>();
                while (rs.next()) {
                    JsonObject o = new JsonObject();
                    o.addProperty("name", rs.getString("name"));
                    o.addProperty("salesCount", rs.getInt("sales_count"));
                    list.add(o);
                }
                data.add("hotProducts", gson.toJsonTree(list));
            }
            // 库存预警
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT name, stock FROM t_product WHERE stock <= 10 AND status=1 LIMIT 10");
                 ResultSet rs = ps.executeQuery()) {
                List<JsonObject> list = new ArrayList<>();
                while (rs.next()) {
                    JsonObject o = new JsonObject();
                    o.addProperty("name", rs.getString("name"));
                    o.addProperty("stock", rs.getInt("stock"));
                    list.add(o);
                }
                data.add("stockAlerts", gson.toJsonTree(list));
            }
        } catch (SQLException e) {
            logger.error("Dashboard error", e);
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    // ==================== 分类管理 ====================
    private void categorySave(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        if (name == null || name.trim().isEmpty()) { sendJson(resp, 400, "分类名称不能为空"); return; }
        try (Connection conn = DBUtil.getConnection()) {
            if (idStr != null && !idStr.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE t_category SET name=? WHERE id=?")) {
                    ps.setString(1, name);
                    ps.setInt(2, Integer.parseInt(idStr));
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO t_category (name) VALUES (?)")) {
                    ps.setString(1, name);
                    ps.executeUpdate();
                }
            }
            sendJson(resp, 200, "保存成功");
            logOperation(req, "分类管理", (idStr != null ? "编辑" : "新增") + "分类: " + name);
        } catch (SQLException e) {
            sendJson(resp, 500, "保存失败: " + e.getMessage());
        }
    }
    private void categoryDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM t_category WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "删除成功");
            logOperation(req, "分类管理", "删除分类ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "删除失败: " + e.getMessage());
        }
    }

    // ==================== 商品管理 ====================
    private void productList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("pageSize"), 10);
        String keyword = req.getParameter("keyword");
        String categoryId = req.getParameter("categoryId");
        String status = req.getParameter("status");
        StringBuilder sql = new StringBuilder("SELECT p.*, c.name as category_name FROM t_product p LEFT JOIN t_category c ON p.category_id=c.id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword + "%");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND p.category_id=?");
            params.add(Integer.parseInt(categoryId));
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND p.status=?");
            params.add(Integer.parseInt(status));
        }
        String countSql = "SELECT COUNT(*) " + sql.substring(sql.indexOf("FROM"));
        sql.append(" ORDER BY p.id DESC LIMIT ?,?");
        try (Connection conn = DBUtil.getConnection()) {
            int total = 0;
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getInt(1); }
            }
            List<Map<String, Object>> list = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
                ps.setInt(params.size() + 1, (page - 1) * pageSize);
                ps.setInt(params.size() + 2, pageSize);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new LinkedHashMap<>();
                        map.put("id", rs.getInt("id"));
                        map.put("name", rs.getString("name"));
                        map.put("categoryId", rs.getInt("category_id"));
                        map.put("categoryName", rs.getString("category_name"));
                        map.put("price", rs.getBigDecimal("price"));
                        map.put("originalPrice", rs.getBigDecimal("original_price"));
                        map.put("stock", rs.getInt("stock"));
                        map.put("salesCount", rs.getInt("sales_count"));
                        map.put("image", rs.getString("image"));
                        map.put("status", rs.getInt("status"));
                        map.put("isHot", rs.getInt("is_hot"));
                        map.put("isNew", rs.getInt("is_new"));
                        list.add(map);
                    }
                }
            }
            JsonObject result = new JsonObject();
            result.addProperty("total", total);
            result.add("list", gson.toJsonTree(list));
            sendJson(resp, 200, "success", result);
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
        }
    }

    private void productSave(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String categoryId = req.getParameter("categoryId");
        String priceStr = req.getParameter("price");
        String stockStr = req.getParameter("stock");
        String description = req.getParameter("description");
        String statusStr = req.getParameter("status");
        String isHotStr = req.getParameter("isHot");
        String isNewStr = req.getParameter("isNew");
        String discountRate = req.getParameter("discountRate");

        BigDecimal price = new BigDecimal(priceStr != null ? priceStr : "0");
        BigDecimal originalPrice = price;
        if (discountRate != null && !discountRate.isEmpty()) {
            BigDecimal rate = new BigDecimal(discountRate);
            price = price.multiply(rate).setScale(2, BigDecimal.ROUND_HALF_UP);
        }

        // 处理图片上传
        String imagePath = null;
        try {
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + getFileName(imagePart);
                String uploadPath = req.getServletContext().getRealPath("/images/products");
                new File(uploadPath).mkdirs();
                byte[] fileBytes = imagePart.getInputStream().readAllBytes();
                java.nio.file.Files.write(java.nio.file.Paths.get(uploadPath, fileName), fileBytes);
                String projectRoot = System.getProperty("user.dir");
                String srcPath = projectRoot + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images" + File.separator + "products";
                new File(srcPath).mkdirs();
                java.nio.file.Files.write(java.nio.file.Paths.get(srcPath, fileName), fileBytes);
                imagePath = fileName;
            }
        } catch (Exception e) {
            logger.warn("Image upload failed: " + e.getMessage());
        }

        try (Connection conn = DBUtil.getConnection()) {
            if (idStr != null && !idStr.isEmpty()) {
                // 编辑商品：如果新价格更低，原价变为旧价格
                BigDecimal oldPrice = null;
                try (PreparedStatement ps = conn.prepareStatement("SELECT price FROM t_product WHERE id=?")) {
                    ps.setInt(1, Integer.parseInt(idStr));
                    try (ResultSet rs = ps.executeQuery()) { if (rs.next()) oldPrice = rs.getBigDecimal("price"); }
                }
                if (oldPrice != null && price.compareTo(oldPrice) < 0) {
                    originalPrice = oldPrice;
                } else if (oldPrice != null) {
                    originalPrice = price;
                }

                StringBuilder upd = new StringBuilder("UPDATE t_product SET name=?, category_id=?, price=?, original_price=?, stock=?, description=?, status=?, is_hot=?, is_new=?");
                if (imagePath != null) upd.append(", image=?");
                upd.append(" WHERE id=?");
                try (PreparedStatement ps = conn.prepareStatement(upd.toString())) {
                    ps.setString(1, name);
                    ps.setInt(2, Integer.parseInt(categoryId));
                    ps.setBigDecimal(3, price);
                    ps.setBigDecimal(4, originalPrice);
                    ps.setInt(5, Integer.parseInt(stockStr));
                    ps.setString(6, description);
                    ps.setInt(7, Integer.parseInt(statusStr != null ? statusStr : "1"));
                    ps.setInt(8, Integer.parseInt(isHotStr != null && "1".equals(isHotStr) ? "1" : "0"));
                    ps.setInt(9, Integer.parseInt(isNewStr != null && "1".equals(isNewStr) ? "1" : "0"));
                    int idx = 10;
                    if (imagePath != null) ps.setString(idx++, imagePath);
                    ps.setInt(idx, Integer.parseInt(idStr));
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO t_product (category_id, name, description, price, original_price, stock, sales_count, image, images, status, is_hot, is_new, view_count) VALUES (?,?,?,?,?,?,0,?,?,?,?,?,0)")) {
                    ps.setInt(1, Integer.parseInt(categoryId));
                    ps.setString(2, name);
                    ps.setString(3, description != null ? description : "");
                    ps.setBigDecimal(4, price);
                    ps.setBigDecimal(5, originalPrice);
                    ps.setInt(6, Integer.parseInt(stockStr));
                    ps.setString(7, imagePath);
                    ps.setString(8, imagePath != null ? "[\"" + imagePath + "\"]" : "[]");
                    ps.setInt(9, Integer.parseInt(statusStr != null ? statusStr : "1"));
                    ps.setInt(10, Integer.parseInt(isHotStr != null && "1".equals(isHotStr) ? "1" : "0"));
                    ps.setInt(11, Integer.parseInt(isNewStr != null && "1".equals(isNewStr) ? "1" : "0"));
                    ps.executeUpdate();
                }
            }
            sendJson(resp, 200, "保存成功");
            logOperation(req, "商品管理", (idStr != null ? "编辑" : "新增") + "商品: " + name);
        } catch (SQLException e) {
            sendJson(resp, 500, "保存失败: " + e.getMessage());
        }
    }

    private void productStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String status = req.getParameter("status");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_product SET status=? WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(status));
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "操作成功");
            logOperation(req, "商品管理", (status.equals("1") ? "上架" : "下架") + "商品ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "操作失败: " + e.getMessage());
        }
    }

    private void productBatchStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ids = req.getParameter("ids");
        String status = req.getParameter("status");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE t_product SET status=? WHERE id IN (" + ids + ")")) {
                ps.setInt(1, Integer.parseInt(status));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "批量操作成功");
            logOperation(req, "商品管理", "批量" + (status.equals("1") ? "上架" : "下架") + "商品: " + ids);
        } catch (SQLException e) {
            sendJson(resp, 500, "操作失败: " + e.getMessage());
        }
    }

    private void productDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM t_product WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "删除成功");
            logOperation(req, "商品管理", "删除商品ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "删除失败: " + e.getMessage());
        }
    }

    // ==================== 库存管理 ====================
    private void stockList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String alert = req.getParameter("alert");
        StringBuilder sql = new StringBuilder("SELECT id, name, stock, sales_count FROM t_product WHERE status=1");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND name LIKE '%").append(escapeSqlLike(keyword)).append("%'");
        if ("warning".equals(alert)) sql.append(" AND stock <= 10");
        else if ("normal".equals(alert)) sql.append(" AND stock > 10");
        sql.append(" ORDER BY stock ASC");
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("stock", rs.getInt("stock"));
                map.put("salesCount", rs.getInt("sales_count"));
                list.add(map);
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败，请重试");
            return;
        }
        sendJson(resp, 200, "success", list);
    }

    private void stockAdjust(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String adminName = (String) req.getSession().getAttribute("username");
        String id = req.getParameter("id");
        String qty = req.getParameter("quantity");
        String reason = req.getParameter("reason");
        int quantity = Integer.parseInt(qty);
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement("UPDATE t_product SET stock = stock + ? WHERE id=? AND stock + ? >= 0")) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, Integer.parseInt(id));
                    ps.setInt(3, quantity);
                    int rows = ps.executeUpdate();
                    if (rows == 0) { sendJson(resp, 400, "库存不足，无法扣减"); conn.rollback(); return; }
                }
                try {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO t_stock_log (product_id, quantity, reason, admin_name, create_time) VALUES (?,?,?,?,NOW())")) {
                        ps.setInt(1, Integer.parseInt(id));
                        ps.setInt(2, quantity);
                        ps.setString(3, reason != null ? reason : "手动调整");
                        ps.setString(4, adminName != null ? adminName : "系统");
                        ps.executeUpdate();
                    }
                } catch (SQLException e2) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO t_stock_log (product_id, quantity, reason, create_time) VALUES (?,?,?,NOW())")) {
                        ps.setInt(1, Integer.parseInt(id));
                        ps.setInt(2, quantity);
                        ps.setString(3, reason != null ? reason : "手动调整");
                        ps.executeUpdate();
                    }
                }
                conn.commit();
                sendJson(resp, 200, "调整成功");
                logOperation(req, "库存管理", "调整库存 商品ID: " + id + " 数量: " + quantity + " 原因: " + reason);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "调整失败: " + e.getMessage());
        }
    }

    private void stockLogs(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT sl.*, p.name as product_name FROM t_stock_log sl LEFT JOIN t_product p ON sl.product_id=p.id ORDER BY sl.create_time DESC LIMIT 50");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("productName", rs.getString("product_name"));
                try { map.put("adminName", rs.getString("admin_name")); } catch (SQLException e) { map.put("adminName", null); }
                map.put("quantity", rs.getInt("quantity"));
                map.put("reason", rs.getString("reason"));
                map.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                list.add(map);
            }
        } catch (SQLException e) {
            logger.warn("Stock logs: " + e.getMessage());
        }
        sendJson(resp, 200, "success", list);
    }

    // ==================== 评论管理 ====================
    private void commentList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String productId = req.getParameter("productId");
        StringBuilder sql = new StringBuilder("SELECT c.*, u.username AS user_username, u.avatar, u.id as user_id, p.name as product_name FROM t_comment c LEFT JOIN t_user u ON c.user_id=u.id LEFT JOIN t_product p ON c.product_id=p.id WHERE 1=1");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND u.username LIKE '%").append(escapeSqlLike(keyword)).append("%'");
        if (productId != null && !productId.isEmpty()) {
            int pid = parseInt(productId, -1);
            if (pid > 0) sql.append(" AND c.product_id=").append(pid);
        }
        sql.append(" ORDER BY c.create_time DESC LIMIT 50");
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("id", rs.getInt("id"));
                String userUsername = rs.getString("user_username");
                if (userUsername != null && !userUsername.trim().isEmpty()) {
                    map.put("username", userUsername);
                } else {
                    map.put("username", rs.getString("username"));
                }
                map.put("avatar", rs.getString("avatar"));
                map.put("userId", rs.getInt("user_id"));
                map.put("productName", rs.getString("product_name"));
                map.put("productId", rs.getInt("product_id"));
                map.put("content", rs.getString("content"));
                map.put("rating", rs.getInt("rating"));
                int oid = rs.getInt("order_id");
                map.put("orderId", rs.wasNull() ? null : oid);
                map.put("status", rs.getInt("status"));
                map.put("replyContent", rs.getString("reply_content"));
                map.put("likeCount", rs.getInt("like_count"));
                map.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                list.add(map);
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败，请重试");
            return;
        }
        sendJson(resp, 200, "success", list);
    }

    private void commentReply(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String commentId = req.getParameter("commentId");
        String replyContent = req.getParameter("replyContent");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_comment SET reply_content=?, reply_time=NOW(), update_time=NOW() WHERE id=?")) {
                ps.setString(1, replyContent);
                ps.setInt(2, Integer.parseInt(commentId));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "回复成功");
            logOperation(req, "评论管理", "回复评论ID: " + commentId);
        } catch (SQLException e) {
            sendJson(resp, 500, "回复失败: " + e.getMessage());
        }
    }

    private void commentDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_comment SET status=-1 WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "删除成功");
            logOperation(req, "评论管理", "删除评论ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "删除失败: " + e.getMessage());
        }
    }

    private void commentRestore(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_comment SET status=1 WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "恢复成功");
        } catch (SQLException e) {
            sendJson(resp, 500, "恢复失败: " + e.getMessage());
        }
    }

    private void commentReplyDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_comment SET reply_content=NULL, reply_time=NULL, update_time=NOW() WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "回复已删除");
            logOperation(req, "评论管理", "删除回复评论ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "删除回复失败: " + e.getMessage());
        }
    }

    // ==================== 用户管理 ====================
    private void userList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("pageSize"), 10);
        String keyword = req.getParameter("keyword");
        String roleFilter = req.getParameter("role");
        StringBuilder where = new StringBuilder("WHERE 1=1");
        if (keyword != null && !keyword.isEmpty()) where.append(" AND username LIKE '%").append(escapeSqlLike(keyword)).append("%'");
        if (roleFilter != null && !roleFilter.isEmpty()) {
            try { int rVal = Integer.parseInt(roleFilter.trim()); where.append(" AND role=").append(rVal); } catch (Exception e) {}
        }
        try (Connection conn = DBUtil.getConnection()) {
            int total = 0;
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_user " + where);
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getInt(1); }
            List<Map<String, Object>> list = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT u.*, (SELECT COUNT(*) FROM t_order o WHERE o.user_id=u.id) as order_count, (SELECT COALESCE(SUM(like_count), 0) FROM t_comment c WHERE c.user_id=u.id) as like_count FROM t_user u " + where + " ORDER BY u.id ASC LIMIT ?,?")) {
                ps.setInt(1, (page - 1) * pageSize);
                ps.setInt(2, pageSize);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new LinkedHashMap<>();
                        map.put("id", rs.getInt("id"));
                        map.put("username", rs.getString("username"));
                        map.put("realName", rs.getString("real_name"));
                        map.put("phone", rs.getString("phone"));
                        map.put("email", rs.getString("email"));
                        map.put("avatar", rs.getString("avatar"));
                        map.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 10) : "");
                        map.put("orderCount", rs.getInt("order_count"));
                        map.put("likeCount", rs.getInt("like_count"));
                        map.put("role", rs.getInt("role"));
                        list.add(map);
                    }
                }
            }
            JsonObject result = new JsonObject();
            result.addProperty("total", total);
            result.add("list", gson.toJsonTree(list));
            sendJson(resp, 200, "success", result);
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
        }
    }

    private void userDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM t_user WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        data.addProperty("id", rs.getInt("id"));
                        data.addProperty("username", rs.getString("username"));
                        data.addProperty("password", rs.getString("password"));
                        data.addProperty("realName", rs.getString("real_name"));
                        data.addProperty("phone", rs.getString("phone"));
                        data.addProperty("email", rs.getString("email"));
                        data.addProperty("avatar", rs.getString("avatar"));
                        data.addProperty("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                        data.addProperty("role", rs.getInt("role"));
                    }
                }
            }
            // 地址
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM t_address WHERE user_id=? ORDER BY is_default DESC")) {
                ps.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = ps.executeQuery()) {
                    List<Map<String, Object>> addrs = new ArrayList<>();
                    while (rs.next()) {
                        Map<String, Object> a = new LinkedHashMap<>();
                        a.put("id", rs.getInt("id"));
                        a.put("receiverName", rs.getString("receiver_name"));
                        a.put("receiverPhone", rs.getString("phone"));
                        a.put("province", rs.getString("province"));
                        a.put("city", rs.getString("city"));
                        a.put("district", rs.getString("district"));
                        a.put("address", rs.getString("detail"));
                        a.put("isDefault", rs.getInt("is_default"));
                        addrs.add(a);
                    }
                    data.add("addresses", gson.toJsonTree(addrs));
                }
            }
            // 最近订单
            try (PreparedStatement ps = conn.prepareStatement("SELECT id, order_no, actual_amount, status, create_time, payment_time FROM t_order WHERE user_id=? ORDER BY create_time DESC LIMIT 20")) {
                ps.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = ps.executeQuery()) {
                    List<Map<String, Object>> orders = new ArrayList<>();
                    while (rs.next()) {
                        Map<String, Object> o = new LinkedHashMap<>();
                        o.put("id", rs.getInt("id"));
                        o.put("orderNo", rs.getString("order_no"));
                        o.put("actualAmount", rs.getBigDecimal("actual_amount") != null ? rs.getBigDecimal("actual_amount").doubleValue() : 0);
                        o.put("status", rs.getInt("status"));
                        Timestamp createTs = rs.getTimestamp("create_time");
                        if (createTs != null) {
                            o.put("createTime", createTs.toString());
                        }
                        Timestamp payTs = rs.getTimestamp("payment_time");
                        if (payTs != null) {
                            o.put("paymentTime", payTs.toString());
                        }
                        orders.add(o);
                    }
                    data.add("recentOrders", gson.toJsonTree(orders));
                }
            }
            // 获取最近订单的商品
            if (data.has("recentOrders") && data.getAsJsonArray("recentOrders").size() > 0) {
                StringBuilder ids = new StringBuilder();
                JsonArray ordersArr = data.getAsJsonArray("recentOrders");
                for (int i = 0; i < ordersArr.size(); i++) {
                    if (i > 0) ids.append(",");
                    ids.append(ordersArr.get(i).getAsJsonObject().get("id").getAsInt());
                }
                try (PreparedStatement ps = conn.prepareStatement("SELECT order_id, product_name, quantity, price FROM t_order_item WHERE order_id IN (" + ids + ")")) {
                    try (ResultSet rs = ps.executeQuery()) {
                        Map<Integer, List<JsonObject>> itemMap = new HashMap<>();
                        while (rs.next()) {
                            int oid = rs.getInt("order_id");
                            JsonObject item = new JsonObject();
                            item.addProperty("productName", rs.getString("product_name"));
                            item.addProperty("quantity", rs.getInt("quantity"));
                            item.addProperty("price", rs.getBigDecimal("price") != null ? rs.getBigDecimal("price").doubleValue() : 0);
                            itemMap.computeIfAbsent(oid, k -> new ArrayList<>()).add(item);
                        }
                        for (int i = 0; i < ordersArr.size(); i++) {
                            JsonObject orderObj = ordersArr.get(i).getAsJsonObject();
                            int oid = orderObj.get("id").getAsInt();
                            List<JsonObject> items = itemMap.get(oid);
                            if (items != null) {
                                JsonArray itemsArr = new JsonArray();
                                for (JsonObject item : items) itemsArr.add(item);
                                orderObj.add("items", itemsArr);
                            }
                        }
                    }
                }
            }
            // 订单数
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_order WHERE user_id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("orderCount", rs.getInt(1)); }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void userResetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_user SET password=? WHERE id=?")) {
                ps.setString(1, MD5Util.encrypt("111111"));
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "密码已重置为111111");
            logOperation(req, "用户管理", "重置用户密码 ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "重置失败: " + e.getMessage());
        }
    }

    private void userUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String realName = req.getParameter("realName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String roleStr = req.getParameter("role");
        Integer roleVal = null;
        if (roleStr != null && !roleStr.trim().isEmpty()) {
            try { roleVal = Integer.parseInt(roleStr.trim()); } catch (Exception e) { roleVal = null; }
        }
        try (Connection conn = DBUtil.getConnection()) {
            if (password != null && !password.trim().isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE t_user SET username=?, password=?, real_name=?, phone=?, email=?" + (roleVal != null ? ", role=?" : "") + ", update_time=NOW() WHERE id=?")) {
                    int idx = 1;
                    ps.setString(idx++, username);
                    ps.setString(idx++, MD5Util.encrypt(password.trim()));
                    ps.setString(idx++, realName);
                    ps.setString(idx++, phone);
                    ps.setString(idx++, email);
                    if (roleVal != null) ps.setInt(idx++, roleVal);
                    ps.setInt(idx++, Integer.parseInt(id));
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE t_user SET username=?, real_name=?, phone=?, email=?" + (roleVal != null ? ", role=?" : "") + ", update_time=NOW() WHERE id=?")) {
                    int idx = 1;
                    ps.setString(idx++, username);
                    ps.setString(idx++, realName);
                    ps.setString(idx++, phone);
                    ps.setString(idx++, email);
                    if (roleVal != null) ps.setInt(idx++, roleVal);
                    ps.setInt(idx++, Integer.parseInt(id));
                    ps.executeUpdate();
                }
            }
            sendJson(resp, 200, "用户信息更新成功");
            logOperation(req, "用户管理", "更新用户信息 ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "更新失败: " + e.getMessage());
        }
    }

    private void userAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String realName = req.getParameter("realName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String roleStr = req.getParameter("role");
        Integer roleVal = 0;
        if (roleStr != null && !roleStr.trim().isEmpty()) {
            try { roleVal = Integer.parseInt(roleStr.trim()); } catch (Exception e) { roleVal = 0; }
        }
        if (username == null || username.trim().isEmpty()) {
            sendJson(resp, 400, "用户名不能为空");
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            sendJson(resp, 400, "密码不能为空");
            return;
        }
        if (realName == null || realName.trim().isEmpty()) {
            sendJson(resp, 400, "真实姓名不能为空");
            return;
        }
        if (phone == null || phone.trim().isEmpty()) {
            sendJson(resp, 400, "手机号不能为空");
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            sendJson(resp, 400, "邮箱不能为空");
            return;
        }
        try (Connection conn = DBUtil.getConnection()) {
            // 检查用户名是否已存在
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_user WHERE username=?")) {
                ps.setString(1, username.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        sendJson(resp, 400, "用户名已存在");
                        return;
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO t_user (username, password, real_name, phone, email, role, status, create_time, update_time) VALUES (?,?,?,?,?,?,1,NOW(),NOW())")) {
                ps.setString(1, username.trim());
                ps.setString(2, MD5Util.encrypt(password.trim()));
                ps.setString(3, realName.trim());
                ps.setString(4, phone.trim());
                ps.setString(5, email.trim());
                ps.setInt(6, roleVal);
                ps.executeUpdate();
            }
            sendJson(resp, 200, "用户添加成功");
            logOperation(req, "用户管理", "添加用户: " + username);
        } catch (SQLException e) {
            sendJson(resp, 500, "添加失败: " + e.getMessage());
        }
    }

    private void userDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM t_user WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "用户删除成功");
            logOperation(req, "用户管理", "删除用户 ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "删除失败: " + e.getMessage());
        }
    }

    private void userExport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment;filename=users.csv");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        out.write('\uFEFF');
        out.println("ID,用户名,真实姓名,手机号,邮箱,注册时间,订单数");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT u.*, (SELECT COUNT(*) FROM t_order o WHERE o.user_id=u.id) as order_count FROM t_user u ORDER BY u.id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.println(rs.getInt("id") + "," + escapeCsv(rs.getString("username")) + "," + escapeCsv(rs.getString("real_name")) + "," + escapeCsv(rs.getString("phone")) + "," + escapeCsv(rs.getString("email")) + "," + rs.getTimestamp("create_time") + "," + rs.getInt("order_count"));
            }
        } catch (SQLException e) {
            logger.error("Export error", e);
        }
    }
    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    // ==================== 订单管理 ====================
    private void orderList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("pageSize"), 10);
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo = req.getParameter("dateTo");
        StringBuilder where = new StringBuilder("WHERE 1=1");
        if (keyword != null && !keyword.isEmpty()) {
            String safeKw = escapeSqlLike(keyword);
            where.append(" AND (o.order_no LIKE '%").append(safeKw).append("%' OR u.username LIKE '%").append(safeKw).append("%')");
        }
        if (status != null && !status.isEmpty()) {
            int statusInt = parseInt(status, -1);
            if (statusInt == 7) {
                where.append(" AND o.status=0 AND UNIX_TIMESTAMP(o.create_time) < UNIX_TIMESTAMP(NOW()) - 20 * 60");
            } else if (statusInt == 0) {
                where.append(" AND o.status=0 AND UNIX_TIMESTAMP(o.create_time) >= UNIX_TIMESTAMP(NOW()) - 20 * 60");
            } else if (statusInt >= 1 && statusInt <= 6) {
                where.append(" AND o.status=").append(statusInt);
            }
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            if (dateFrom.matches("\\d{4}-\\d{2}-\\d{2}")) {
                where.append(" AND o.create_time >= '").append(dateFrom).append("'");
            }
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            if (dateTo.matches("\\d{4}-\\d{2}-\\d{2}")) {
                where.append(" AND o.create_time <= '").append(dateTo).append(" 23:59:59'");
            }
        }
        try (Connection conn = DBUtil.getConnection()) {
            int total = 0;
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_order o LEFT JOIN t_user u ON o.user_id=u.id " + where);
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getInt(1); }
            List<Map<String, Object>> list = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT o.*, u.username FROM t_order o LEFT JOIN t_user u ON o.user_id=u.id " + where + " ORDER BY o.create_time DESC LIMIT ?,?")) {
                ps.setInt(1, (page - 1) * pageSize);
                ps.setInt(2, pageSize);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new LinkedHashMap<>();
                        map.put("id", rs.getInt("id"));
                        map.put("orderNo", rs.getString("order_no"));
                        map.put("username", rs.getString("username"));
                        map.put("totalAmount", rs.getBigDecimal("total_amount"));
                        map.put("actualAmount", rs.getBigDecimal("actual_amount"));
                        map.put("status", rs.getInt("status"));
                        map.put("paymentMethod", rs.getInt("payment_method"));
                        map.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                        map.put("remark", rs.getString("remark"));
                        map.put("adminRemark", rs.getString("admin_remark"));
                        list.add(map);
                    }
                }
            }
            JsonObject result = new JsonObject();
            result.addProperty("total", total);
            result.add("list", gson.toJsonTree(list));
            sendJson(resp, 200, "success", result);
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败，请重试");
        }
    }

    private void orderShip(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String deliveryCompany = req.getParameter("deliveryCompany");
        String deliveryNo = req.getParameter("deliveryNo");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE t_order SET status=2, delivery_company=?, delivery_no=?, delivery_time=NOW(), update_time=NOW() WHERE id=?")) {
                ps.setString(1, deliveryCompany);
                ps.setString(2, deliveryNo);
                ps.setInt(3, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "发货成功");
            logOperation(req, "订单管理", "发货 订单ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "发货失败: " + e.getMessage());
        }
    }

    private void orderRefund(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE t_order SET status=6, refund_complete_time=NOW(), update_time=NOW() WHERE id=?")) {
                ps.setInt(1, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "退款成功");
            logOperation(req, "订单管理", "退款 订单ID: " + id);
        } catch (SQLException e) {
            sendJson(resp, 500, "退款失败: " + e.getMessage());
        }
    }

    private void orderRemark(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String remark = req.getParameter("remark");
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_order SET admin_remark=?, update_time=NOW() WHERE id=?")) {
                ps.setString(1, remark);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }
            sendJson(resp, 200, "备注成功");
        } catch (SQLException e) {
            sendJson(resp, 500, "备注失败: " + e.getMessage());
        }
    }

    // ==================== 用户地址管理 ====================
    private void userAddressAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = req.getParameter("userId");
        String receiverName = req.getParameter("receiverName");
        String phone = req.getParameter("phone");
        if (phone == null || phone.isEmpty()) phone = req.getParameter("receiverPhone");
        String province = req.getParameter("province");
        String city = req.getParameter("city");
        String district = req.getParameter("district");
        String detail = req.getParameter("detail");
        if (detail == null || detail.isEmpty()) detail = req.getParameter("address");
        String postalCode = req.getParameter("postalCode");
        String isDefaultStr = req.getParameter("isDefault");

        if (userIdStr == null || userIdStr.isEmpty()) {
            sendJson(resp, 400, "用户ID不能为空");
            return;
        }
        if (receiverName == null || receiverName.trim().isEmpty() || phone == null || phone.trim().isEmpty()
                || detail == null || detail.trim().isEmpty()) {
            sendJson(resp, 400, "收货人、电话、详细地址不能为空");
            return;
        }

        int userId = Integer.parseInt(userIdStr);
        int isDefault = (isDefaultStr != null && "1".equals(isDefaultStr)) ? 1 : 0;
        try (Connection conn = DBUtil.getConnection()) {
            if (isDefault == 1) {
                try (PreparedStatement ps = conn.prepareStatement("UPDATE t_address SET is_default=0 WHERE user_id=?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO t_address (user_id, receiver_name, phone, province, city, district, detail, postal_code, is_default, create_time) VALUES (?,?,?,?,?,?,?,?,?,NOW())",
                    java.sql.PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setString(2, receiverName.trim());
                ps.setString(3, phone.trim());
                ps.setString(4, province != null ? province.trim() : "");
                ps.setString(5, city != null ? city.trim() : "");
                ps.setString(6, district != null ? district.trim() : "");
                ps.setString(7, detail.trim());
                ps.setString(8, postalCode != null ? postalCode.trim() : "");
                ps.setInt(9, isDefault);
                ps.executeUpdate();
            }
            sendJson(resp, 200, "添加成功");
            logOperation(req, "用户管理", "为用户ID:" + userId + " 添加收货地址");
        } catch (SQLException e) {
            sendJson(resp, 500, "添加失败: " + e.getMessage());
        }
    }

    private void userAddressUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String addressIdStr = req.getParameter("addressId");
        String receiverName = req.getParameter("receiverName");
        String phone = req.getParameter("phone");
        if (phone == null || phone.isEmpty()) phone = req.getParameter("receiverPhone");
        String province = req.getParameter("province");
        String city = req.getParameter("city");
        String district = req.getParameter("district");
        String detail = req.getParameter("detail");
        if (detail == null || detail.isEmpty()) detail = req.getParameter("address");
        String postalCode = req.getParameter("postalCode");
        String isDefaultStr = req.getParameter("isDefault");

        if (addressIdStr == null || addressIdStr.isEmpty()) {
            sendJson(resp, 400, "地址ID不能为空");
            return;
        }
        int addressId = Integer.parseInt(addressIdStr);
        int isDefault = (isDefaultStr != null && "1".equals(isDefaultStr)) ? 1 : 0;
        try (Connection conn = DBUtil.getConnection()) {
            // 如果设为默认，先清除其他默认
            if (isDefault == 1) {
                int userIdOfAddr = 0;
                try (PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM t_address WHERE id=?")) {
                    ps.setInt(1, addressId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) userIdOfAddr = rs.getInt("user_id");
                    }
                }
                if (userIdOfAddr > 0) {
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE t_address SET is_default=0 WHERE user_id=? AND id<>?")) {
                        ps.setInt(1, userIdOfAddr);
                        ps.setInt(2, addressId);
                        ps.executeUpdate();
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE t_address SET receiver_name=?, phone=?, province=?, city=?, district=?, detail=?, postal_code=?, is_default=? WHERE id=?")) {
                ps.setString(1, receiverName != null ? receiverName.trim() : "");
                ps.setString(2, phone != null ? phone.trim() : "");
                ps.setString(3, province != null ? province.trim() : "");
                ps.setString(4, city != null ? city.trim() : "");
                ps.setString(5, district != null ? district.trim() : "");
                ps.setString(6, detail != null ? detail.trim() : "");
                ps.setString(7, postalCode != null ? postalCode.trim() : "");
                ps.setInt(8, isDefault);
                ps.setInt(9, addressId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    sendJson(resp, 200, "更新成功");
                    logOperation(req, "用户管理", "更新收货地址ID:" + addressId);
                } else {
                    sendJson(resp, 404, "地址不存在");
                }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "更新失败: " + e.getMessage());
        }
    }

    private void userAddressDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String addressIdStr = req.getParameter("addressId");
        if (addressIdStr == null || addressIdStr.isEmpty()) {
            sendJson(resp, 400, "地址ID不能为空");
            return;
        }
        int addressId = Integer.parseInt(addressIdStr);
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM t_address WHERE id=?")) {
                ps.setInt(1, addressId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    sendJson(resp, 200, "删除成功");
                    logOperation(req, "用户管理", "删除收货地址ID:" + addressId);
                } else {
                    sendJson(resp, 404, "地址不存在");
                }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "删除失败: " + e.getMessage());
        }
    }

    private void userAddressDefault(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = req.getParameter("userId");
        String addressIdStr = req.getParameter("addressId");
        if (userIdStr == null || userIdStr.isEmpty() || addressIdStr == null || addressIdStr.isEmpty()) {
            sendJson(resp, 400, "用户ID和地址ID不能为空");
            return;
        }
        int userId = Integer.parseInt(userIdStr);
        int addressId = Integer.parseInt(addressIdStr);
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_address SET is_default=0 WHERE user_id=? AND id<>?")) {
                ps.setInt(1, userId);
                ps.setInt(2, addressId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("UPDATE t_address SET is_default=1 WHERE id=? AND user_id=?")) {
                ps.setInt(1, addressId);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    sendJson(resp, 200, "设置默认地址成功");
                    logOperation(req, "用户管理", "为用户ID:" + userId + " 设置默认地址ID:" + addressId);
                } else {
                    sendJson(resp, 404, "地址不存在");
                }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "设置默认地址失败: " + e.getMessage());
        }
    }

    private void userAddressDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String addressIdStr = req.getParameter("addressId");
        if (addressIdStr == null || addressIdStr.isEmpty()) {
            sendJson(resp, 400, "地址ID不能为空");
            return;
        }
        int addressId = Integer.parseInt(addressIdStr);
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, user_id, receiver_name, phone, province, city, district, detail, postal_code, is_default FROM t_address WHERE id=?")) {
                ps.setInt(1, addressId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        JsonObject o = new JsonObject();
                        o.addProperty("id", rs.getInt("id"));
                        o.addProperty("userId", rs.getInt("user_id"));
                        o.addProperty("receiverName", rs.getString("receiver_name"));
                        o.addProperty("receiverPhone", rs.getString("phone"));
                        o.addProperty("province", rs.getString("province"));
                        o.addProperty("city", rs.getString("city"));
                        o.addProperty("district", rs.getString("district"));
                        o.addProperty("address", rs.getString("detail"));
                        o.addProperty("detail", rs.getString("detail"));
                        o.addProperty("postalCode", rs.getString("postal_code"));
                        o.addProperty("isDefault", rs.getInt("is_default") == 1);
                        sendJson(resp, 200, "成功", o);
                    } else {
                        sendJson(resp, 404, "地址不存在");
                    }
                }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "查询失败: " + e.getMessage());
        }
    }

    // ==================== 数据统计 ====================
    private void statsOverview(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE(create_time)=CURDATE() AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("todaySales", rs.getDouble(1)); }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE YEARWEEK(create_time)=YEARWEEK(CURDATE()) AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("weekSales", rs.getDouble(1)); }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m') AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("monthSales", rs.getDouble(1)); }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_user WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("newUsers", rs.getInt(1)); }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsDaily(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<JsonObject> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT DATE(create_time) as dt, COALESCE(SUM(actual_amount),0) as amt FROM t_order WHERE create_time >= DATE_SUB(CURDATE(),INTERVAL 30 DAY) AND status IN(1,2,3) GROUP BY dt ORDER BY dt");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JsonObject o = new JsonObject();
                o.addProperty("date", rs.getString("dt"));
                o.addProperty("amount", rs.getDouble("amt"));
                list.add(o);
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", list);
    }

    private void statsMonthly(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<JsonObject> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT DATE_FORMAT(create_time,'%Y-%m') as mt, COALESCE(SUM(actual_amount),0) as amt FROM t_order WHERE status IN(1,2,3) GROUP BY mt ORDER BY mt DESC LIMIT 12");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JsonObject o = new JsonObject();
                o.addProperty("month", rs.getString("mt"));
                o.addProperty("amount", rs.getDouble("amt"));
                list.add(o);
            }
            // 反转顺序
            Collections.reverse(list);
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", list);
    }

    private void statsTopProducts(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<JsonObject> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT name, sales_count FROM t_product WHERE status=1 ORDER BY sales_count DESC LIMIT 10");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JsonObject o = new JsonObject();
                o.addProperty("name", rs.getString("name"));
                o.addProperty("salesCount", rs.getInt("sales_count"));
                list.add(o);
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", list);
    }

    private void statsUserStats(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM t_user WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("newUsers", rs.getInt(1)); }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(DISTINCT user_id) FROM t_order WHERE create_time >= DATE_SUB(CURDATE(),INTERVAL 30 DAY)");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("activeUsers", rs.getInt(1)); }
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ROUND(COUNT(*)*1.0/(SELECT COUNT(DISTINCT user_id) FROM t_order WHERE status IN(1,2,3)),2) FROM t_order WHERE user_id IN (SELECT user_id FROM t_order WHERE status IN(1,2,3) GROUP BY user_id HAVING COUNT(*)>1) AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) { if (rs.next()) data.addProperty("repurchaseRate", rs.getDouble(1)); }
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsTodayDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE(create_time)=CURDATE() AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble(1);
            }
            data.addProperty("totalSales", total);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE DATE(o.create_time)=CURDATE() AND o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("productName", rs.getString("product_name"));
                    item.put("quantity", rs.getInt("qty"));
                    item.put("amount", rs.getDouble("amt"));
                    items.add(item);
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsWeekDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE YEARWEEK(create_time)=YEARWEEK(CURDATE()) AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble(1);
            }
            data.addProperty("totalSales", total);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE YEARWEEK(o.create_time)=YEARWEEK(CURDATE()) AND o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("productName", rs.getString("product_name"));
                    item.put("quantity", rs.getInt("qty"));
                    item.put("amount", rs.getDouble("amt"));
                    items.add(item);
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsMonthDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m') AND status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble(1);
            }
            data.addProperty("totalSales", total);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE DATE_FORMAT(o.create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m') AND o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("productName", rs.getString("product_name"));
                    item.put("quantity", rs.getInt("qty"));
                    item.put("amount", rs.getDouble("amt"));
                    items.add(item);
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsNewUsers(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            int total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM t_user WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m')");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getInt(1);
            }
            data.addProperty("total", total);
            List<Map<String, Object>> users = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id, username, phone, email, create_time FROM t_user WHERE DATE_FORMAT(create_time,'%Y-%m')=DATE_FORMAT(CURDATE(),'%Y-%m') ORDER BY create_time DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> user = new LinkedHashMap<>();
                    user.put("id", rs.getInt("id"));
                    user.put("username", rs.getString("username"));
                    user.put("phone", rs.getString("phone"));
                    user.put("email", rs.getString("email"));
                    user.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                    users.add(user);
                }
            }
            data.add("users", gson.toJsonTree(users));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsTotalDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE status IN(1,2,3)");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble(1);
            }
            data.addProperty("totalSales", total);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("productName", rs.getString("product_name"));
                    item.put("quantity", rs.getInt("qty"));
                    item.put("amount", rs.getDouble("amt"));
                    items.add(item);
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsDaySalesDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String date = req.getParameter("date");
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE(create_time)=? AND status IN(1,2,3)")) {
                ps.setString(1, date);
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getDouble(1); }
            }
            data.addProperty("totalSales", total);
            data.addProperty("date", date);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE DATE(o.create_time)=? AND o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC")) {
                ps.setString(1, date);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("productName", rs.getString("product_name"));
                        item.put("quantity", rs.getInt("qty"));
                        item.put("amount", rs.getDouble("amt"));
                        items.add(item);
                    }
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    private void statsMonthSalesDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String month = req.getParameter("month");
        JsonObject data = new JsonObject();
        try (Connection conn = DBUtil.getConnection()) {
            double total = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COALESCE(SUM(actual_amount),0) FROM t_order WHERE DATE_FORMAT(create_time,'%Y-%m')=? AND status IN(1,2,3)")) {
                ps.setString(1, month);
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getDouble(1); }
            }
            data.addProperty("totalSales", total);
            data.addProperty("month", month);
            List<Map<String, Object>> items = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT oi.product_name, SUM(oi.quantity) as qty, SUM(oi.quantity * oi.price) as amt FROM t_order_item oi INNER JOIN t_order o ON oi.order_id=o.id WHERE DATE_FORMAT(o.create_time,'%Y-%m')=? AND o.status IN(1,2,3) GROUP BY oi.product_name ORDER BY amt DESC")) {
                ps.setString(1, month);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("productName", rs.getString("product_name"));
                        item.put("quantity", rs.getInt("qty"));
                        item.put("amount", rs.getDouble("amt"));
                        items.add(item);
                    }
                }
            }
            data.add("items", gson.toJsonTree(items));
        } catch (SQLException e) {
            sendJson(resp, 500, "加载失败: " + e.getMessage());
            return;
        }
        sendJson(resp, 200, "success", data);
    }

    // ==================== 日志管理 ====================
    private void logsList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo = req.getParameter("dateTo");
        StringBuilder where = new StringBuilder("WHERE 1=1");
        if (keyword != null && !keyword.isEmpty()) where.append(" AND content LIKE '%").append(escapeSqlLike(keyword)).append("%'");
        if (dateFrom != null && !dateFrom.isEmpty()) {
            if (dateFrom.matches("\\d{4}-\\d{2}-\\d{2}")) where.append(" AND create_time >= '").append(dateFrom).append("'");
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            if (dateTo.matches("\\d{4}-\\d{2}-\\d{2}")) where.append(" AND create_time <= '").append(dateTo).append(" 23:59:59'");
        }
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM t_admin_log " + where + " ORDER BY create_time DESC LIMIT 100");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("adminName", rs.getString("admin_name"));
                map.put("type", rs.getString("type"));
                map.put("content", rs.getString("content"));
                map.put("createTime", rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toString().substring(0, 19) : "");
                list.add(map);
            }
        } catch (SQLException e) {
            logger.warn("Logs: " + e.getMessage());
        }
        sendJson(resp, 200, "success", list);
    }

    // ==================== 忘记密码找回 ====================
    private void findByPhoneOrEmail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        phone = (phone != null) ? phone.trim() : "";
        email = (email != null) ? email.trim() : "";
        List<Object> params = new ArrayList<>();
        String sql = "SELECT id, username, real_name, phone, email FROM t_user WHERE role=1 AND status=1 ";
        if (!phone.isEmpty()) {
            sql += " AND phone = ?";
            params.add(phone);
        }
        if (!email.isEmpty()) {
            sql += " AND email = ?";
            params.add(email);
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, (String) params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    JsonObject data = new JsonObject();
                    data.addProperty("id", rs.getInt("id"));
                    data.addProperty("username", rs.getString("username"));
                    data.addProperty("realName", rs.getString("real_name"));
                    sendJson(resp, 200, "找到管理员账号", data);
                } else {
                    sendJson(resp, 404, "未找到该管理员账号，请确认手机号/邮箱是否正确且账号已激活");
                }
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "查询失败: " + e.getMessage());
        }
    }

    private void resetPasswordByVerification(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = req.getParameter("userId");
        String newPassword = req.getParameter("newPassword");
        if (userIdStr == null || userIdStr.isEmpty() || newPassword == null || newPassword.length() < 6) {
            sendJson(resp, 400, "参数错误");
            return;
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE t_user SET password=? WHERE id=? AND role=1 AND status=1")) {
            ps.setString(1, MD5Util.encrypt(newPassword));
            ps.setInt(2, Integer.parseInt(userIdStr));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                sendJson(resp, 200, "密码重置成功");
            } else {
                sendJson(resp, 404, "管理员账号不存在");
            }
        } catch (SQLException e) {
            sendJson(resp, 500, "重置失败: " + e.getMessage());
        }
    }

    // ==================== 工具方法 ====================
    private void logOperation(HttpServletRequest req, String type, String content) {
        try {
            HttpSession session = req.getSession();
            String adminName = (String) session.getAttribute("username");
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO t_admin_log (admin_name, type, content, create_time) VALUES (?,?,?,NOW())")) {
                ps.setString(1, adminName);
                ps.setString(2, type);
                ps.setString(3, content);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            logger.warn("Log operation failed: " + e.getMessage());
        }
    }

    private void sendJson(HttpServletResponse resp, int code, String message) throws IOException {
        sendJson(resp, code, message, null);
    }

    private void sendJson(HttpServletResponse resp, int code, String message, Object data) throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("code", code);
        json.addProperty("message", message);
        if (data != null) json.add("data", gson.toJsonTree(data));
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().print(gson.toJson(json));
    }

    private int parseInt(String s, int def) {
        if (s == null || s.isEmpty()) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return def; }
    }

    /**
     * 安全转义 SQL LIKE 搜索关键字，防止 SQL 注入和语法错误。
     * 将单引号转义为两个单引号，并转义 LIKE 特殊字符。
     */
    private String escapeSqlLike(String keyword) {
        if (keyword == null || keyword.isEmpty()) return "";
        String safe = keyword.replace("'", "''");
        safe = safe.replace("\\", "\\\\");
        safe = safe.replace("%", "\\%");
        safe = safe.replace("_", "\\_");
        return safe;
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
}
