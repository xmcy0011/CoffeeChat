package com.xuyc.cim.controller;

import com.xuyc.cim.dao.AdminMapper;
import com.xuyc.cim.pojo.Admin;
import com.xuyc.cim.service.AdminService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author xmcy0011@sina.com
 * @create 2021/11/29 11:22
 */
@RestController
public class AdminController {

  @Autowired
  AdminService service;

  @RequestMapping("/admin")
  public List<Admin> getAllAdmin() {
    return service.getAllAdmin();
  }
}
