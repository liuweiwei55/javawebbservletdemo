package com.student.service;

import com.student.entity.User;

public interface UserService {

    User login(String username, String password);

    boolean register(User user);

    User getUserById(Integer id);

    User getUserByUsername(String username);

    User getUserByPhoneAndEmail(String phone, String email);

    boolean verifyUserByPhoneAndEmail(String phone, String email, String realName);

    boolean updatePassword(Integer userId, String oldPassword, String newPassword);

    boolean resetPasswordByPhoneAndEmail(String phone, String email, String realName, String newPassword);

    boolean resetPassword(Integer userId, String newPassword);

    boolean updateUserInfo(User user);

    boolean deleteUser(Integer id);
}