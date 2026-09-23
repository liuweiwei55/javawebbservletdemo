package com.student.service;

import com.student.entity.Category;
import java.util.List;

public interface CategoryService {

    Category getCategoryById(Integer id);

    List<Category> getTopCategories();

    List<Category> getSubCategories(Integer parentId);

    List<Category> getAllCategories();

    boolean addCategory(Category category);

    boolean updateCategory(Category category);

    boolean deleteCategory(Integer id);
}
