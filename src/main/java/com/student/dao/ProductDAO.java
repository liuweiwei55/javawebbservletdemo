package com.student.dao;

import com.student.entity.Product;
import java.util.List;

public interface ProductDAO {
    
    int insert(Product product);
    
    int update(Product product);
    
    int delete(Integer id);
    
    Product findById(Integer id);
    
    List<Product> findAll(int pageNum, int pageSize);
    
    long count();
    
    List<Product> getByCategoryId(Integer categoryId);
    
    List<Product> search(String keyword);
    
    List<Product> getHotProducts(int limit);
    
    List<Product> getNewProducts(int limit);
    
    int updateStock(Integer productId, Integer quantity);
    
    int restoreStock(Integer productId, Integer quantity);
    
    int incrementSalesCount(Integer productId, Integer quantity);
    
    int incrementViewCount(Integer productId);
}
