package com.student.dao;

import com.student.entity.Address;
import java.util.List;

public interface AddressDAO {
    
    int insert(Address address);
    
    int update(Address address);
    
    int delete(Integer id);
    
    Address findById(Integer id);
    
    List<Address> getByUserId(Integer userId);
    
    Address getDefaultAddress(Integer userId);
    
    int setDefaultAddress(Integer userId, Integer addressId);
}
