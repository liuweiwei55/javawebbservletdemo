package com.student.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(filterName = "corsFilter", urlPatterns = "/*")
public class CORSFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(CORSFilter.class);

    private static final String ALLOWED_ORIGINS = "*";

    private static final String ALLOWED_METHODS = "GET, POST, PUT, DELETE, OPTIONS";

    private static final String ALLOWED_HEADERS = "Content-Type, Authorization, X-Requested-With, Accept, Origin";

    private static final String MAX_AGE = "3600";

    private static final String ALLOW_CREDENTIALS = "true";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("CORS跨域过滤器初始化完成");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String origin = httpRequest.getHeader("Origin");

        if (origin != null && !origin.isEmpty()) {
            httpResponse.setHeader("Access-Control-Allow-Origin", origin);
        } else {
            httpResponse.setHeader("Access-Control-Allow-Origin", ALLOWED_ORIGINS);
        }

        httpResponse.setHeader("Access-Control-Allow-Credentials", ALLOW_CREDENTIALS);

        httpResponse.setHeader("Access-Control-Allow-Methods", ALLOWED_METHODS);

        httpResponse.setHeader("Access-Control-Allow-Headers", ALLOWED_HEADERS);

        httpResponse.setHeader("Access-Control-Max-Age", MAX_AGE);

        httpResponse.setHeader("Access-Control-Expose-Headers", "Content-Disposition, Content-Type");

        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            logger.debug("CORS过滤器 - 处理OPTIONS预检请求, Origin: {}", origin);
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        logger.info("CORS跨域过滤器已销毁");
    }
}
