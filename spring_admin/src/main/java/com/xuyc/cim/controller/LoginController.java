package com.xuyc.cim.controller;

import javax.servlet.http.HttpSession;
import javax.websocket.server.PathParam;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author xmcy0011@sina.com
 */
@Controller
public class LoginController {

  @RequestMapping("/login")
  public String login(
      @RequestParam("email") String userName,
      @RequestParam("password") String pwd,
      Model model,
      HttpSession session) {

    System.out.println("login ,email:" + userName + ",pwd:" + pwd);

    if ("admin@126.com".equals(userName) && "123456".equals(pwd)) {
      session.setAttribute("loginUser", userName);
      return "redirect:/home.html";
    }

    model.addAttribute("msg", "用户名或密码错误！");
    return "index";
  }
}
