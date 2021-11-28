package com.xuyc.cim.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 员工
 *
 * @author xmcy0011@sina.com
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

  private Integer id;
  private Integer departmentId;

  private String name;
  private String email;
}
