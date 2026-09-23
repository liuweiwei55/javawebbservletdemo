package com.student.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 字符编码过滤器
 * <p>
 * 统一设置请求和响应的字符编码为UTF-8，解决中文乱码问题。
 * <p>
 * 功能说明：
 * 1. 设置请求的字符编码为UTF-8（解决POST请求参数乱码）
 * 2. 设置响应的Content-Type字符编码为UTF-8（解决响应输出乱码）
 * 3. 支持通过web.xml配置初始化参数
 * <p>
 * web.xml配置示例：
 * <pre>
 *     &lt;filter&gt;
 *         &lt;filter-name&gt;encodingFilter&lt;/filter-name&gt;
 *         &lt;filter-class&gt;com.student.filter.EncodingFilter&lt;/filter-class&gt;
 *         &lt;init-param&gt;
 *             &lt;param-name&gt;encoding&lt;/param-name&gt;
 *             &lt;param-value&gt;UTF-8&lt;/param-value&gt;
 *         &lt;/init-param&gt;
 *     &lt;/filter&gt;
 * </pre>
 *
 * @author student-management
 */
@WebFilter(
    filterName = "encodingFilter",
    urlPatterns = "/*",
    initParams = {
        @WebInitParam(name = "encoding", value = "UTF-8"),
        @WebInitParam(name = "forceEncoding", value = "true")
    }
)
public class EncodingFilter implements Filter {

    /** 日志记录器 */
    private static final Logger logger = LoggerFactory.getLogger(EncodingFilter.class);

    /** 默认字符编码 */
    private static final String DEFAULT_ENCODING = "UTF-8";

    /** 字符编码 */
    private String encoding;

    /** 是否强制设置响应编码 */
    private boolean forceEncoding;

    /**
     * 过滤器初始化
     * <p>
     * 从web.xml中读取初始化参数：
     * - encoding：字符编码（默认UTF-8）
     * - forceEncoding：是否强制设置响应编码（默认true）
     */
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 读取编码参数，如果未配置则使用默认值UTF-8
        this.encoding = filterConfig.getInitParameter("encoding");
        if (this.encoding == null || this.encoding.trim().isEmpty()) {
            this.encoding = DEFAULT_ENCODING;
        }

        // 读取是否强制设置响应编码参数
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        this.forceEncoding = "true".equalsIgnoreCase(forceEncodingParam);

        logger.info("字符编码过滤器初始化完成 - encoding: {}, forceEncoding: {}",
                this.encoding, this.forceEncoding);
    }

    /**
     * 执行过滤逻辑
     * <p>
     * 对每个请求设置字符编码：
     * 1. 设置request的字符编码（解决POST参数乱码）
     * 2. 如果forceEncoding为true，设置response的Content-Type编码
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        // 如果请求未设置字符编码，或者编码与目标编码不一致，则设置
        if (request.getCharacterEncoding() == null
                || !request.getCharacterEncoding().equalsIgnoreCase(this.encoding)) {
            request.setCharacterEncoding(this.encoding);
        }

        // 如果强制设置响应编码
        if (this.forceEncoding) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setCharacterEncoding(this.encoding);
            // 设置响应的Content-Type头
            httpResponse.setContentType("text/html;charset=" + this.encoding);
        }

        // 继续执行后续过滤器或Servlet
        chain.doFilter(request, response);
    }

    /**
     * 过滤器销毁
     * <p>
     * 释放资源（本过滤器无需释放特殊资源）
     */
    @Override
    public void destroy() {
        logger.info("字符编码过滤器已销毁");
    }
}