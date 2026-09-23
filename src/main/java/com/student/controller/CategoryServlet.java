package com.student.controller;

import com.student.entity.Category;
import com.student.service.CategoryService;
import com.student.service.impl.CategoryServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/category/*")
public class CategoryServlet extends BaseServlet {

    private final CategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || !"/list".equals(path)) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        listCategories(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            sendErrorResponse(response, 400, "无效的请求路径");
            return;
        }

        switch (path) {
            case "/add":
                addCategory(request, response);
                break;
            case "/update":
                updateCategory(request, response);
                break;
            case "/delete":
                deleteCategory(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer parentId = getIntegerParameter(request, "parentId");

            List<Category> categories;

            if (parentId != null) {
                categories = categoryService.getSubCategories(parentId);
            } else {
                categories = categoryService.getTopCategories();
            }

            sendSuccessResponse(response, "获取成功", categories);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取分类列表失败: " + e.getMessage());
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        Integer parentId = getIntegerParameter(request, "parentId");
        Integer sortOrder = getIntegerParameter(request, "sortOrder");
        String icon = request.getParameter("icon");
        Integer status = getIntegerParameter(request, "status");

        if (name == null || name.trim().isEmpty()) {
            sendErrorResponse(response, 400, "分类名称不能为空");
            return;
        }

        Category category = new Category();
        category.setName(name.trim());
        category.setParentId(parentId != null ? parentId : 0);
        category.setSortOrder(sortOrder != null ? sortOrder : 0);
        category.setIcon(icon != null ? icon : "");
        category.setStatus(status != null ? status : 1);

        boolean result = categoryService.addCategory(category);

        if (result) {
            sendSuccessResponse(response, "添加成功", null);
        } else {
            sendErrorResponse(response, 500, "添加失败");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer id = getIntegerParameter(request, "id");

        if (id == null) {
            sendErrorResponse(response, 400, "分类ID不能为空");
            return;
        }

        Category existCategory = categoryService.getCategoryById(id);
        if (existCategory == null) {
            sendErrorResponse(response, 404, "分类不存在");
            return;
        }

        String name = request.getParameter("name");
        Integer parentId = getIntegerParameter(request, "parentId");
        Integer sortOrder = getIntegerParameter(request, "sortOrder");
        String icon = request.getParameter("icon");
        Integer status = getIntegerParameter(request, "status");

        if (name != null) existCategory.setName(name.trim());
        if (parentId != null) existCategory.setParentId(parentId);
        if (sortOrder != null) existCategory.setSortOrder(sortOrder);
        if (icon != null) existCategory.setIcon(icon);
        if (status != null) existCategory.setStatus(status);

        boolean result = categoryService.updateCategory(existCategory);

        if (result) {
            sendSuccessResponse(response, "更新成功", null);
        } else {
            sendErrorResponse(response, 500, "更新失败");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer id = getIntegerParameter(request, "id");

        if (id == null) {
            sendErrorResponse(response, 400, "分类ID不能为空");
            return;
        }

        boolean result = categoryService.deleteCategory(id);

        if (result) {
            sendSuccessResponse(response, "删除成功", null);
        } else {
            sendErrorResponse(response, 500, "删除失败");
        }
    }
}
