package com.xuyc.cim.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author xmcy0011@sina.com
 */
@Configuration
public class MvcConfig implements WebMvcConfigurer {

  /**
   * 映射资源
   */
  @Override
  public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/").setViewName("index");
    registry.addViewController("/index.html").setViewName("index");
    registry.addViewController("/home.html").setViewName("home");
  }

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new LoginHandlerInterceptor())
        .addPathPatterns("/**")
        // 登录页、默认、login Controller、静态资源都不拦截
        .excludePathPatterns(
            "/index.html", "/",
            "/login",
            "/static/**",
            "/assets/**");
  }
}
