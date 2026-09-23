package com.student.dao;

import com.student.entity.User;

public interface UserDAO {
    
    int insert(User user);
    
    int update(User user);
    
    int delete(Integer id);
    
    User findById(Integer id);
    
    User findByUsername(String username);
    
    User findByPhoneAndEmail(String phone, String email);
    
    User login(String username, String password);
    
    int updatePassword(Integer userId, String newPassword);

    String queryPasswordById(Integer userId);
}