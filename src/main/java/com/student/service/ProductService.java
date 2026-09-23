package com.student.service;

import com.student.entity.Product;
import java.util.List;

public interface ProductService {

    Product getProductById(Integer id);

    List<Product> getProductsByCategory(Integer categoryId);

    List<Product> getProductsByCategoryId(Integer categoryId);

    List<Product> searchProducts(String keyword);

    List<Product> getHotProducts(int limit);

    List<Product> getNewProducts(int limit);

    List<Product> getAllProducts(int pageNum, int pageSize);

    long getTotalCount();

    boolean addProduct(Product product);

    boolean updateProduct(Product product);

    boolean deleteProduct(Integer id);

    boolean updateStock(Integer productId, Integer quantity);

    boolean reduceStock(Integer productId, Integer quantity);
}
