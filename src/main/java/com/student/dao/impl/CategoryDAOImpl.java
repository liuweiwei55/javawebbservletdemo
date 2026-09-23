package com.student.dao.impl;

import com.student.dao.BaseDAO;
import com.student.dao.CategoryDAO;
import com.student.entity.Category;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl extends BaseDAO<Category> implements CategoryDAO {
    private static final Logger logger = LoggerFactory.getLogger(CategoryDAOImpl.class);

    @Override
    protected Class<Category> getEntityClass() {
        return Category.class;
    }

    @Override
    public int insert(Category category) {
        return super.insert(category);
    }

    @Override
    public int update(Category category) {
        return super.update(category);
    }

    @Override
    public int delete(Integer id) {
        return super.delete(id);
    }

    @Override
    public Category findById(Integer id) {
        return super.findById(id);
    }

    @Override
    public List<Category> findAll() {
        return super.findAll();
    }

    @Override
    public List<Category> getByParentId(Integer parentId) {
        return new ArrayList<>();
    }

    @Override
    public List<Category> getTopCategories() {
        String sql = "SELECT * FROM `t_category` ORDER BY id ASC";
        return executeQueryForList(sql);
    }
}