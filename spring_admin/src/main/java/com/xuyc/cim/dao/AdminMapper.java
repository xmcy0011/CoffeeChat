package com.xuyc.cim.dao;

import com.xuyc.cim.pojo.Admin;
import java.util.List;
import org.springframework.stereotype.Repository;

/**
 * @author xmcy0011@sina.com
 * @create 2021/11/29 11:12
 */
@Repository
public interface AdminMapper {

  List<Admin> selectAll();
}
