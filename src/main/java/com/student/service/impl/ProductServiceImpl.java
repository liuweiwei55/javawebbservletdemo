package com.student.service.impl;

import com.student.dao.ProductDAO;
import com.student.dao.impl.ProductDAOImpl;
import com.student.entity.Product;
import com.student.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class ProductServiceImpl implements ProductService {

    private static final Logger logger = LoggerFactory.getLogger(ProductServiceImpl.class);
    private final ProductDAO productDAO = new ProductDAOImpl();

    @Override
    public Product getProductById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        Product product = productDAO.findById(id);
        if (product != null) {
            productDAO.incrementViewCount(id);
        }
        return product;
    }

    @Override
    public List<Product> getProductsByCategory(Integer categoryId) {
        if (categoryId == null) {
            throw new IllegalArgumentException("分类ID不能为空");
        }
        return productDAO.getByCategoryId(categoryId);
    }

    @Override
    public List<Product> getProductsByCategoryId(Integer categoryId) {
        if (categoryId == null) {
            throw new IllegalArgumentException("分类ID不能为空");
        }
        return productDAO.getByCategoryId(categoryId);
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("搜索关键词不能为空");
        }
        return productDAO.search(keyword.trim());
    }

    @Override
    public List<Product> getHotProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productDAO.getHotProducts(limit);
    }

    @Override
    public List<Product> getNewProducts(int limit) {
        if (limit <= 0) {
            limit = 10;
        }
        return productDAO.getNewProducts(limit);
    }

    @Override
    public List<Product> getAllProducts(int pageNum, int pageSize) {
        if (pageNum <= 0) pageNum = 1;
        if (pageSize <= 0) pageSize = 10;
        return productDAO.findAll(pageNum, pageSize);
    }

    @Override
    public long getTotalCount() {
        return productDAO.count();
    }

    @Override
    public boolean addProduct(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("商品信息不能为空");
        }
        int result = productDAO.insert(product);
        logger.info("添加商品: {}, 结果: {}", product.getName(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updateProduct(Product product) {
        if (product == null || product.getId() == null) {
            throw new IllegalArgumentException("商品信息不完整");
        }
        int result = productDAO.update(product);
        logger.info("更新商品: productId={}, 结果: {}", product.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteProduct(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }
        int result = productDAO.delete(id);
        logger.info("删除商品: productId={}, 结果: {}", id, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updateStock(Integer productId, Integer quantity) {
        if (productId == null || quantity == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        int result = productDAO.updateStock(productId, quantity);
        logger.info("更新库存: productId={}, quantity={}, 结果: {}", productId, quantity, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean reduceStock(Integer productId, Integer quantity) {
        if (productId == null || quantity == null || quantity <= 0) {
            throw new IllegalArgumentException("参数不合法");
        }
        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (product.getStock() < quantity) {
            throw new RuntimeException("库存不足");
        }
        int result = productDAO.updateStock(productId, quantity);
        if (result > 0) {
            productDAO.incrementSalesCount(productId, quantity);
        }
        logger.info("扣减库存: productId={}, quantity={}, 结果: {}", productId, quantity, result > 0 ? "成功" : "失败");
        return result > 0;
    }
}