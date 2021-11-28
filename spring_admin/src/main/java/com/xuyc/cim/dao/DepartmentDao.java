package com.xuyc.cim.dao;

import com.xuyc.cim.pojo.Department;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * 部门访问
 *
 * @author xmcy0011@sina.com
 */
public class DepartmentDao {

  private static Map<Integer, Department> departmentMap = null;

  static {
    departmentMap = new HashMap<Integer, Department>();
    departmentMap.put(1, new Department(1, "研发部"));
    departmentMap.put(2, new Department(2, "产品部"));
    departmentMap.put(3, new Department(3, "测试部"));
  }

  /**
   * 获取所有部门
   */
  public Collection<Department> getAllDepartment() {
    return departmentMap.values();
  }

  /**
   * 查询部门详情
   *
   * @param id: ID
   */
  public Department getDepartmentById(Integer id) {
    return departmentMap.get(id);
  }

}
