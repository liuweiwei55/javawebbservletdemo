package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.ProductDAO;
import com.student.entity.Product;
import com.student.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl extends BaseDAO<Product> implements ProductDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProductDAOImpl.class);

    @Override
    protected Class<Product> getEntityClass() {
        return Product.class;
    }

    @Override
    public int insert(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("商品信息不能为空");
        }
        try {
            String sql = "INSERT INTO `t_product`(category_id,name,description,price,original_price,stock,sales_count,image,images,status,is_hot,is_new,view_count) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setBigDecimal(4, product.getPrice());
            pstmt.setBigDecimal(5, product.getOriginalPrice());
            pstmt.setInt(6, product.getStock());
            pstmt.setInt(7, product.getSalesCount());
            pstmt.setString(8, product.getImage());
            pstmt.setString(9, product.getImages());
            pstmt.setInt(10, product.getStatus());
            pstmt.setInt(11, product.getIsHot());
            pstmt.setInt(12, product.getIsNew());
            pstmt.setInt(13, product.getViewCount());
            int res = pstmt.executeUpdate();
            DBUtil.close(null, pstmt, conn);
            return res;
        } catch (SQLException e) {
            logger.error("新增商品失败", e);
            return 0;
        }
    }

    @Override
    public int update(Product product) {
        if (product == null || product.getId() == null) {
            throw new IllegalArgumentException("商品信息不完整");
        }
        try {
            String sql = "UPDATE `t_product` SET category_id=?,name=?,description=?,price=?,original_price=?,stock=?,sales_count=?,image=?,images=?,status=?,is_hot=?,is_new=?,view_count=? WHERE id=?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setBigDecimal(4, product.getPrice());
            pstmt.setBigDecimal(5, product.getOriginalPrice());
            pstmt.setInt(6, product.getStock());
            pstmt.setInt(7, product.getSalesCount());
            pstmt.setString(8, product.getImage());
            pstmt.setString(9, product.getImages());
            pstmt.setInt(10, product.getStatus());
            pstmt.setInt(11, product.getIsHot());
            pstmt.setInt(12, product.getIsNew());
            pstmt.setInt(13, product.getViewCount());
            pstmt.setInt(14, product.getId());
            int res = pstmt.executeUpdate();
            DBUtil.close(null, pstmt, conn);
            return res;
        } catch (SQLException e) {
            logger.error("修改商品失败", e);
            return 0;
        }
    }

    @Override
    public int delete(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        try {
            String sql = "DELETE FROM `t_product` WHERE id=?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int res = pstmt.executeUpdate();
            DBUtil.close(null, pstmt, conn);
            return res;
        } catch (SQLException e) {
            logger.error("删除商品失败", e);
            return 0;
        }
    }

    @Override
    public Product findById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        try {
            String sql = "SELECT p.*, c.name AS category_name FROM `t_product` p LEFT JOIN `t_category` c ON p.category_id = c.id WHERE p.id = ?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            Product p = null;
            if (rs.next()) {
                p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                p.setCategoryName(rs.getString("category_name"));
            }
            DBUtil.close(rs, pstmt, conn);
            return p;
        } catch (SQLException e) {
            logger.error("根据ID查询商品失败", e);
            return null;
        }
    }

    @Override
    public List<Product> findAll(int pageNum, int pageSize) {
        if (pageNum < 1) pageNum = 1;
        if (pageSize < 1) pageSize = 10;

        List<Product> list = new ArrayList<>();
        try {
            int offset = (pageNum - 1) * pageSize;
            String sql = "SELECT * FROM `t_product` ORDER BY status DESC, id DESC LIMIT ?,?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                list.add(p);
            }
            DBUtil.close(rs, pstmt, conn);
        } catch (SQLException e) {
            logger.error("分页查询商品失败", e);
        }
        return list;
    }

    @Override
    public long count() {
        try {
            String sql = "SELECT COUNT(*) FROM `t_product`";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            long total = 0;
            if (rs.next()) total = rs.getLong(1);
            DBUtil.close(rs, pstmt, conn);
            return total;
        } catch (SQLException e) {
            logger.error("统计商品总数失败", e);
            return 0;
        }
    }

    @Override
    public List<Product> getByCategoryId(Integer categoryId) {
        if (categoryId == null) {
            throw new IllegalArgumentException("分类ID不能为空");
        }
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM `t_product` WHERE category_id = ? AND status = 1 ORDER BY status DESC, id DESC";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                list.add(p);
            }
            DBUtil.close(rs, pstmt, conn);
        } catch (SQLException e) {
            logger.error("分类查询商品失败", e);
        }
        return list;
    }

    @Override
    public List<Product> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll(1, 10);
        }
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM `t_product` WHERE (name LIKE CONCAT('%', ?, '%') OR description LIKE CONCAT('%', ?, '%')) AND status = 1 ORDER BY status DESC, id DESC";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, keyword);
            pstmt.setString(2, keyword);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                list.add(p);
            }
            DBUtil.close(rs, pstmt, conn);
        } catch (SQLException e) {
            logger.error("搜索商品失败", e);
        }
        return list;
    }

    @Override
    public List<Product> getHotProducts(int limit) {
        if (limit < 1) limit = 6;
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM `t_product` WHERE is_hot = 1 AND status = 1 ORDER BY sales_count DESC LIMIT ?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                list.add(p);
            }
            DBUtil.close(rs, pstmt, conn);
        } catch (SQLException e) {
            logger.error("查询热门商品失败", e);
        }
        return list;
    }

    @Override
    public List<Product> getNewProducts(int limit) {
        if (limit < 1) limit = 6;
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM `t_product` WHERE is_new = 1 AND status = 1 ORDER BY status DESC, id DESC LIMIT ?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setOriginalPrice(rs.getBigDecimal("original_price"));
                p.setStock(rs.getInt("stock"));
                p.setSalesCount(rs.getInt("sales_count"));
                p.setImage(rs.getString("image"));
                p.setImages(rs.getString("images"));
                p.setStatus(rs.getInt("status"));
                p.setIsHot(rs.getInt("is_hot"));
                p.setIsNew(rs.getInt("is_new"));
                p.setViewCount(rs.getInt("view_count"));
                list.add(p);
            }
            DBUtil.close(rs, pstmt, conn);
        } catch (SQLException e) {
            logger.error("查询新品商品失败", e);
        }
        return list;
    }

    @Override
    public int updateStock(Integer productId, Integer quantity) {
        if (productId == null || quantity == null || quantity < 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE `t_product` SET stock = stock - ? WHERE id = ? AND stock >= ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            int res = pstmt.executeUpdate();

            conn.commit();
            return res;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                logger.error("事务回滚失败", ex);
            }
            logger.error("扣减库存失败", e);
            return 0;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    DBUtil.close(null, null, conn);
                }
            } catch (SQLException e) {
                logger.error("恢复事务模式失败", e);
            }
        }
    }

    @Override
    public int restoreStock(Integer productId, Integer quantity) {
        if (productId == null || quantity == null || quantity < 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        String sql = "UPDATE `t_product` SET stock = stock + ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("恢复库存失败", e);
            return 0;
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }

    @Override
    public int incrementSalesCount(Integer productId, Integer quantity) {
        if (productId == null || quantity == null || quantity < 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        try {
            String sql = "UPDATE `t_product` SET sales_count = sales_count + ? WHERE id = ?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            int res = pstmt.executeUpdate();
            DBUtil.close(null, pstmt, conn);
            return res;
        } catch (SQLException e) {
            logger.error("增加销量失败", e);
            return 0;
        }
    }

    @Override
    public int incrementViewCount(Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        try {
            String sql = "UPDATE `t_product` SET view_count = view_count + 1 WHERE id = ?";
            Connection conn = DBUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            int res = pstmt.executeUpdate();
            DBUtil.close(null, pstmt, conn);
            return res;
        } catch (SQLException e) {
            logger.error("增加浏览量失败", e);
            return 0;
        }
    }
}
