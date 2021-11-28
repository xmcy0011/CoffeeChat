package com.xuyc.cim.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登录拦截器
 * @author xmcy0011@sina.com
 */
public class LoginHandlerInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {

    System.out.println("preHandle 拦截器被执行！");

    Object user = request.getSession().getAttribute("loginUser");
    if (user == null) {
      request.setAttribute("msg", "请先登录！");
      request.getRequestDispatcher("/index.html").forward(request, response);
      return false;
    }

    return true;
  }
}
