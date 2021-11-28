package com.xuyc.cim.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 部门表
 *
 * @author xuyc
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Department {
  private Integer id;
  private String name;
}
