package com.student.filter;

import com.student.common.Result;
import com.student.entity.User;
import com.student.service.UserService;
import com.student.service.impl.UserServiceImpl;
import com.student.util.DBUtil;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebFilter(
    filterName = "authFilter",
    urlPatterns = "/*",
    initParams = {
        @WebInitParam(
            name = "excludePaths",
            value = "/api/user/login,/api/user/register,/api/user/logout,/api/user/forgotPassword,/api/product/list,/api/product/detail,/api/category/list,/api/admin/findByPhoneOrEmail,/api/admin/resetPasswordByVerification,/pages/admin-login.jsp,/pages/admin-reset-password.jsp,/pages/forgot-password.jsp"
        )
    }
)
public class AuthFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(AuthFilter.class);
    private static final String USER_SESSION_KEY = "userId";
    private static final String AUTO_LOGIN_USER_ID = "autoLoginUserId";
    private static final String AUTO_LOGIN_EXPIRE = "autoLoginExpire";

    private List<String> excludePathList;
    private Gson gson;
    private final UserService userService = new UserServiceImpl();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String excludePaths = filterConfig.getInitParameter("excludePaths");
        if (excludePaths != null && !excludePaths.trim().isEmpty()) {
            this.excludePathList = Arrays.asList(excludePaths.split(","));
        } else {
            this.excludePathList = List.of();
        }
        this.gson = new Gson();
        logger.info("登录认证过滤器初始化完成 - 排除路径: {}", this.excludePathList);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        logger.debug("认证过滤器 - 请求路径: {}", path);

        // 1. 放行排除路径（API白名单等）
        if (isExcludePath(path)) {
            logger.debug("认证过滤器 - 路径 {} 在排除列表中，放行", path);
            chain.doFilter(request, response);
            return;
        }

        // 2. 放行静态资源（CSS/JS/图片/字体等）
        if (isStaticResource(path)) {
            logger.debug("认证过滤器 - 静态资源请求，放行: {}", path);
            chain.doFilter(request, response);
            return;
        }

        // 3. 检查用户登录状态
        HttpSession session = httpRequest.getSession(false);
        Object loginUser = (session != null) ? session.getAttribute(USER_SESSION_KEY) : null;

        if (loginUser == null) {
            loginUser = tryAutoLogin(httpRequest, httpResponse);
        }

        if (loginUser != null) {
            logger.debug("认证过滤器 - 用户已登录，放行");
            // 管理员登录后访问首页，自动重定向到管理后台
            HttpSession sess = httpRequest.getSession(false);
            if (sess != null) {
                Object roleObj = sess.getAttribute("role");
                if (roleObj != null && (Integer) roleObj == 1) {
                    if (path.equals("/") || path.equals("/index.jsp") || path.equals("/index.html")) {
                        logger.info("认证过滤器 - 管理员访问首页，重定向到管理后台");
                        httpResponse.sendRedirect(contextPath + "/pages/admin.jsp");
                        return;
                    }
                }
            }
            chain.doFilter(request, response);
        } else {
            logger.warn("认证过滤器 - 用户未登录，拒绝访问: {}", path);
            // 4. 针对未登录用户的请求进行处理
            if (path.startsWith("/api/")) {
                // API请求返回未授权JSON
                sendUnauthorizedResponse(httpResponse);
            } else if (isPublicPage(path)) {
                // 公开页面（如登录页、注册页、错误页）直接放行
                chain.doFilter(request, response);
            } else {
                // 其他页面重定向到登录页，管理页面定向到管理员登录页
                String loginPage = path.startsWith("/pages/admin") ? "/pages/admin-login.jsp" : "/pages/login.jsp";
                httpResponse.sendRedirect(contextPath + loginPage);
            }
        }
    }

    /**
     * 判断是否为静态资源
     */
    private boolean isStaticResource(String path) {
        return path.startsWith("/images/") ||
               path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/static/") ||
               path.endsWith(".css") ||
               path.endsWith(".js") ||
               path.endsWith(".jpg") ||
               path.endsWith(".png") ||
               path.endsWith(".gif") ||
               path.endsWith(".ico") ||
               path.endsWith(".svg") ||
               path.endsWith(".woff") ||
               path.endsWith(".woff2") ||
               path.endsWith(".ttf") ||
               path.endsWith(".eot");
    }

    private Object tryAutoLogin(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }

        String userId = null;
        String expireTime = null;

        for (Cookie cookie : cookies) {
            if (AUTO_LOGIN_USER_ID.equals(cookie.getName())) {
                userId = cookie.getValue();
            }
            if (AUTO_LOGIN_EXPIRE.equals(cookie.getName())) {
                expireTime = cookie.getValue();
            }
        }

        if (userId == null || expireTime == null) {
            return null;
        }

        try {
            long expire = Long.parseLong(expireTime);
            if (System.currentTimeMillis() > expire) {
                clearAutoLoginCookie(response);
                return null;
            }

            User user = userService.getUserById(Integer.valueOf(userId));
            if (user != null && user.getStatus() == 1) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                if (user.getAvatar() != null && !user.getAvatar().trim().isEmpty()) {
                    session.setAttribute("avatar", user.getAvatar());
                }
                
                // 将上次登录时间放入session供页面显示，然后更新本次登录时间
                if (user.getLastLoginTime() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
                    session.setAttribute("lastLoginTime", sdf.format(user.getLastLoginTime()));
                }
                
                try (Connection conn = DBUtil.getConnection()) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "UPDATE t_user SET last_login_time = NOW() WHERE id = ?")) {
                        ps.setInt(1, user.getId());
                        ps.executeUpdate();
                    }
                } catch (Exception e) {
                    logger.warn("更新自动登录时间失败，忽略", e);
                }
                
                return user.getId();
            }
            return null;
        } catch (Exception e) {
            logger.error("自动登录失败", e);
            return null;
        }
    }

    private void clearAutoLoginCookie(HttpServletResponse response) {
        Cookie userIdCookie = new Cookie(AUTO_LOGIN_USER_ID, "");
        Cookie expireCookie = new Cookie(AUTO_LOGIN_EXPIRE, "");
        userIdCookie.setMaxAge(0);
        expireCookie.setMaxAge(0);
        userIdCookie.setPath("/");
        expireCookie.setPath("/");
        response.addCookie(userIdCookie);
        response.addCookie(expireCookie);
    }

    private boolean isExcludePath(String path) {
        for (String excludePath : excludePathList) {
            if (excludePath.endsWith("/")) {
                if (path.startsWith(excludePath) || path.equals(excludePath.substring(0, excludePath.length() - 1))) {
                    return true;
                }
            } else {
                if (path.equals(excludePath)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 检查是否为公开页面（不需要登录即可访问）
     */
    private boolean isPublicPage(String path) {
        return path.equals("/") ||
               path.equals("/index.jsp") ||
               path.startsWith("/pages/login") ||
               path.startsWith("/pages/register") ||
               path.startsWith("/pages/forgot-password") ||
               path.startsWith("/pages/product-") ||
               path.startsWith("/pages/admin-login") ||
               path.startsWith("/pages/admin-reset-password") ||
               path.startsWith("/pages/error/"); // 放行错误页面，防止未登录时访问错误页被重定向
    }

    private void sendUnauthorizedResponse(HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        Result<?> result = Result.unauthorized();
        try (PrintWriter writer = response.getWriter()) {
            writer.write(gson.toJson(result));
            writer.flush();
        }
    }

    @Override
    public void destroy() {
        logger.info("登录认证过滤器已销毁");
    }
}