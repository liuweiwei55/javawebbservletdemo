package com.student.common;

import java.io.Serializable;

/**
 * 统一响应结果类
 * <p>
 * 所有API接口的返回值都使用此类包装，确保前后端数据交互格式统一。
 * 前端通过code判断请求是否成功，通过data获取业务数据。
 * <p>
 * 响应格式示例：
 * <pre>
 *     // 成功响应
 *     {
 *         "code": 200,
 *         "message": "操作成功",
 *         "data": {...},
 *         "total": 0
 *     }
 *
 *     // 失败响应
 *     {
 *         "code": 500,
 *         "message": "操作失败",
 *         "data": null,
 *         "total": 0
 *     }
 * </pre>
 *
 * @param <T> 数据类型
 * @author student-management
 */
public class Result<T> implements Serializable {

    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;

    // ==================== 状态码常量 ====================
    /** 成功状态码 */
    public static final int CODE_SUCCESS = 200;
    /** 失败状态码 */
    public static final int CODE_ERROR = 500;
    /** 未认证状态码 */
    public static final int CODE_UNAUTHORIZED = 401;
    /** 参数错误状态码 */
    public static final int CODE_BAD_REQUEST = 400;
    /** 未找到资源状态码 */
    public static final int CODE_NOT_FOUND = 404;

    // ==================== 属性 ====================

    /** 状态码（200=成功，其他=失败） */
    private int code;

    /** 提示信息 */
    private String message;

    /** 响应数据（泛型，可以是任意类型） */
    private T data;

    /** 总记录数（用于分页查询） */
    private long total;

    // ==================== 构造方法 ====================

    /**
     * 私有无参构造（防止外部直接创建，强制使用静态工厂方法）
     */
    private Result() {
    }

    /**
     * 私有全参构造
     */
    private Result(int code, String message, T data, long total) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.total = total;
    }

    // ==================== 静态工厂方法 ====================

    /**
     * 返回成功结果（无数据）
     * <p>
     * 使用场景：增删改操作成功后返回
     *
     * @return Result对象
     */
    public static <T> Result<T> success() {
        return new Result<>(CODE_SUCCESS, "操作成功", null, 0);
    }

    /**
     * 返回成功结果（带数据）
     * <p>
     * 使用场景：查询操作成功后返回数据
     *
     * @param data 响应数据
     * @return Result对象
     */
    public static <T> Result<T> success(T data) {
        return new Result<>(CODE_SUCCESS, "操作成功", data, 0);
    }

    /**
     * 返回成功结果（带数据和总记录数）
     * <p>
     * 使用场景：分页查询成功后返回数据和总条数
     *
     * @param data  响应数据（列表）
     * @param total 总记录数
     * @return Result对象
     */
    public static <T> Result<T> success(T data, long total) {
        return new Result<>(CODE_SUCCESS, "操作成功", data, total);
    }

    /**
     * 返回成功结果（自定义消息和数据）
     *
     * @param message 提示信息
     * @param data    响应数据
     * @return Result对象
     */
    public static <T> Result<T> success(String message, T data) {
        return new Result<>(CODE_SUCCESS, message, data, 0);
    }

    /**
     * 返回失败结果（默认消息）
     *
     * @return Result对象
     */
    public static <T> Result<T> error() {
        return new Result<>(CODE_ERROR, "操作失败", null, 0);
    }

    /**
     * 返回失败结果（自定义消息）
     *
     * @param message 错误提示信息
     * @return Result对象
     */
    public static <T> Result<T> error(String message) {
        return new Result<>(CODE_ERROR, message, null, 0);
    }

    /**
     * 返回失败结果（自定义状态码和消息）
     *
     * @param code    状态码
     * @param message 错误提示信息
     * @return Result对象
     */
    public static <T> Result<T> error(int code, String message) {
        return new Result<>(code, message, null, 0);
    }

    /**
     * 返回未认证结果
     * <p>
     * 使用场景：用户未登录或登录已过期
     *
     * @return Result对象
     */
    public static <T> Result<T> unauthorized() {
        return new Result<>(CODE_UNAUTHORIZED, "未登录或登录已过期，请重新登录", null, 0);
    }

    /**
     * 返回参数错误结果
     *
     * @param message 错误提示信息
     * @return Result对象
     */
    public static <T> Result<T> badRequest(String message) {
        return new Result<>(CODE_BAD_REQUEST, message, null, 0);
    }

    // ==================== Getter/Setter ====================

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    // ==================== 便捷方法 ====================

    /**
     * 判断请求是否成功
     *
     * @return true表示成功（code == 200）
     */
    public boolean isSuccess() {
        return this.code == CODE_SUCCESS;
    }

    @Override
    public String toString() {
        return "Result{" +
                "code=" + code +
                ", message='" + message + '\'' +
                ", data=" + data +
                ", total=" + total +
                '}';
    }
}