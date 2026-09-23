package com.student.service.impl;

import com.student.dao.CategoryDAO;
import com.student.dao.impl.CategoryDAOImpl;
import com.student.entity.Category;
import com.student.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class CategoryServiceImpl implements CategoryService {

    private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();

    @Override
    public Category getCategoryById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("分类ID不能为空");
        }
        return categoryDAO.findById(id);
    }

    @Override
    public List<Category> getTopCategories() {
        return categoryDAO.getTopCategories();
    }

    @Override
    public List<Category> getSubCategories(Integer parentId) {
        if (parentId == null) {
            throw new IllegalArgumentException("父分类ID不能为空");
        }
        return categoryDAO.getByParentId(parentId);
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    @Override
    public boolean addCategory(Category category) {
        if (category == null) {
            throw new IllegalArgumentException("分类信息不能为空");
        }
        int result = categoryDAO.insert(category);
        logger.info("添加分类: {}, 结果: {}", category.getName(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean updateCategory(Category category) {
        if (category == null || category.getId() == null) {
            throw new IllegalArgumentException("分类信息不完整");
        }
        int result = categoryDAO.update(category);
        logger.info("更新分类: categoryId={}, 结果: {}", category.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteCategory(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("分类ID不能为空");
        }
        int result = categoryDAO.delete(id);
        logger.info("删除分类: categoryId={}, 结果: {}", id, result > 0 ? "成功" : "失败");
        return result > 0;
    }
}
