package com.student.service;

import com.student.entity.Address;
import java.util.List;

public interface AddressService {

    Address addAddress(Address address);

    boolean updateAddress(Address address);

    boolean deleteAddress(Integer id);

    Address getAddressById(Integer id);

    List<Address> getAddressesByUserId(Integer userId);

    Address getDefaultAddress(Integer userId);

    boolean setDefaultAddress(Integer userId, Integer addressId);
}
