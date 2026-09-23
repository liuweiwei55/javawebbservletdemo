package com.student.service.impl;

import com.student.dao.AddressDAO;
import com.student.dao.impl.AddressDAOImpl;
import com.student.entity.Address;
import com.student.service.AddressService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class AddressServiceImpl implements AddressService {

    private static final Logger logger = LoggerFactory.getLogger(AddressServiceImpl.class);
    private final AddressDAO addressDAO = new AddressDAOImpl();

    @Override
    public Address addAddress(Address address) {
        if (address == null || address.getUserId() == null) {
            throw new IllegalArgumentException("地址信息不完整");
        }

        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            // 用户要求设为默认地址，先取消该用户其他默认地址
            List<Address> addresses = addressDAO.getByUserId(address.getUserId());
            for (Address addr : addresses) {
                if (addr.getIsDefault() != null && addr.getIsDefault() == 1) {
                    addr.setIsDefault(0);
                    addressDAO.update(addr);
                }
            }
        } else {
            List<Address> addresses = addressDAO.getByUserId(address.getUserId());
            if (addresses.isEmpty()) {
                address.setIsDefault(1);
            } else {
                address.setIsDefault(0);
            }
        }

        addressDAO.insert(address);
        logger.info("添加地址: userId={}, addressId={}", address.getUserId(), address.getId());
        return address;
    }

    @Override
    public boolean updateAddress(Address address) {
        if (address == null || address.getId() == null) {
            throw new IllegalArgumentException("地址信息不完整");
        }
        int result = addressDAO.update(address);
        logger.info("更新地址: addressId={}, 结果: {}", address.getId(), result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public boolean deleteAddress(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("地址ID不能为空");
        }
        int result = addressDAO.delete(id);
        logger.info("删除地址: addressId={}, 结果: {}", id, result > 0 ? "成功" : "失败");
        return result > 0;
    }

    @Override
    public Address getAddressById(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("地址ID不能为空");
        }
        return addressDAO.findById(id);
    }

    @Override
    public List<Address> getAddressesByUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return addressDAO.getByUserId(userId);
    }

    @Override
    public Address getDefaultAddress(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return addressDAO.getDefaultAddress(userId);
    }

    @Override
    public boolean setDefaultAddress(Integer userId, Integer addressId) {
        if (userId == null || addressId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        int result = addressDAO.setDefaultAddress(userId, addressId);
        logger.info("设置默认地址: userId={}, addressId={}, 结果: {}", userId, addressId, result > 0 ? "成功" : "失败");
        return result > 0;
    }
}
