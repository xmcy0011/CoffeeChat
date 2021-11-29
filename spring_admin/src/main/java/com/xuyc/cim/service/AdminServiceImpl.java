package com.xuyc.cim.service;

import com.xuyc.cim.dao.AdminMapper;
import com.xuyc.cim.pojo.Admin;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author xmcy0011@sina.com
 * @create 2021/11/29 11:48
 */
@Service
public class AdminServiceImpl implements AdminService {

  @Autowired
  AdminMapper mapper;

  @Override
  public List<Admin> getAllAdmin() {
    return mapper.selectAll();
  }
}
