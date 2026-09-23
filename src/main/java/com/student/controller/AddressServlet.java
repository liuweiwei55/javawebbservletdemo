package com.student.controller;

import com.student.entity.Address;
import com.student.service.AddressService;
import com.student.service.impl.AddressServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/address/*")
public class AddressServlet extends BaseServlet {

    private final AddressService addressService = new AddressServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || !"/list".equals(path)) {
            sendErrorResponse(response, 404, "请求的资源不存在");
            return;
        }

        listAddresses(request, response);
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
                addAddress(request, response);
                break;
            case "/update":
                updateAddress(request, response);
                break;
            case "/delete":
                deleteAddress(request, response);
                break;
            case "/default":
                setDefaultAddress(request, response);
                break;
            default:
                sendErrorResponse(response, 404, "请求的资源不存在");
        }
    }

    private void listAddresses(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            List<Address> addresses = addressService.getAddressesByUserId(userId);

            sendSuccessResponse(response, "获取成功", addresses);
        } catch (Exception e) {
            sendErrorResponse(response, 500, "获取地址列表失败: " + e.getMessage());
        }
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            String receiverName = request.getParameter("receiverName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String detail = request.getParameter("detail");
            String postalCode = request.getParameter("postalCode");
            Integer isDefault = getIntegerParameter(request, "isDefault");

            if (receiverName == null || phone == null || province == null ||
                city == null || district == null || detail == null) {
                sendErrorResponse(response, 400, "地址信息不完整");
                return;
            }

            Address address = new Address();
            address.setUserId(userId);
            address.setReceiverName(receiverName);
            address.setPhone(phone);
            address.setProvince(province);
            address.setCity(city);
            address.setDistrict(district);
            address.setDetail(detail);
            address.setPostalCode(postalCode != null ? postalCode : "");
            address.setIsDefault(isDefault != null ? isDefault : 0);

            Address result = addressService.addAddress(address);

            if (result != null) {
                sendSuccessResponse(response, "添加成功", result);
            } else {
                sendErrorResponse(response, 500, "添加失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "添加地址失败: " + e.getMessage());
        }
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer addressId = getIntegerParameter(request, "addressId");

            if (addressId == null) {
                sendErrorResponse(response, 400, "地址ID不能为空");
                return;
            }

            Address existAddress = addressService.getAddressById(addressId);
            if (existAddress == null) {
                sendErrorResponse(response, 404, "地址不存在");
                return;
            }

            if (!existAddress.getUserId().equals(userId)) {
                sendErrorResponse(response, 403, "无权修改该地址");
                return;
            }

            String receiverName = request.getParameter("receiverName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String detail = request.getParameter("detail");
            String postalCode = request.getParameter("postalCode");

            if (receiverName == null || phone == null || detail == null) {
                sendErrorResponse(response, 400, "地址信息不完整");
                return;
            }

            existAddress.setReceiverName(receiverName);
            existAddress.setPhone(phone);
            existAddress.setProvince(province != null ? province : existAddress.getProvince());
            existAddress.setCity(city != null ? city : existAddress.getCity());
            existAddress.setDistrict(district != null ? district : existAddress.getDistrict());
            existAddress.setDetail(detail);
            existAddress.setPostalCode(postalCode != null ? postalCode : existAddress.getPostalCode());

            boolean result = addressService.updateAddress(existAddress);

            if (result) {
                sendSuccessResponse(response, "更新成功", null);
            } else {
                sendErrorResponse(response, 500, "更新失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "更新地址失败: " + e.getMessage());
        }
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer addressId = getIntegerParameter(request, "addressId");

            if (addressId == null) {
                sendErrorResponse(response, 400, "地址ID不能为空");
                return;
            }

            Address existAddress = addressService.getAddressById(addressId);
            if (existAddress == null) {
                sendErrorResponse(response, 404, "地址不存在");
                return;
            }

            if (!existAddress.getUserId().equals(userId)) {
                sendErrorResponse(response, 403, "无权删除该地址");
                return;
            }

            boolean result = addressService.deleteAddress(addressId);

            if (result) {
                sendSuccessResponse(response, "删除成功", null);
            } else {
                sendErrorResponse(response, 500, "删除失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "删除地址失败: " + e.getMessage());
        }
    }

    private void setDefaultAddress(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                sendErrorResponse(response, 401, "请先登录");
                return;
            }

            Integer addressId = getIntegerParameter(request, "addressId");

            if (addressId == null) {
                sendErrorResponse(response, 400, "地址ID不能为空");
                return;
            }

            Address existAddress = addressService.getAddressById(addressId);
            if (existAddress == null) {
                sendErrorResponse(response, 404, "地址不存在");
                return;
            }

            if (!existAddress.getUserId().equals(userId)) {
                sendErrorResponse(response, 403, "无权操作该地址");
                return;
            }

            boolean result = addressService.setDefaultAddress(userId, addressId);

            if (result) {
                sendSuccessResponse(response, "设置默认地址成功", null);
            } else {
                sendErrorResponse(response, 500, "设置默认地址失败");
            }
        } catch (Exception e) {
            sendErrorResponse(response, 500, "设置默认地址失败: " + e.getMessage());
        }
    }
}