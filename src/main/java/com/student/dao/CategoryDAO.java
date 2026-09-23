package com.student.dao;

import com.student.entity.Category;
import java.util.List;

public interface CategoryDAO {
    
    int insert(Category category);
    
    int update(Category category);
    
    int delete(Integer id);
    
    Category findById(Integer id);
    
    List<Category> findAll();
    
    List<Category> getByParentId(Integer parentId);
    
    List<Category> getTopCategories();
}
