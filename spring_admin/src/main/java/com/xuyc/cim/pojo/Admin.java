package com.xuyc.cim.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 管理员表
 *
 * @author xmcy0011@sina.com
 * @create 2021/11/29 11:28
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Admin {

  private long id;
  private String userName;
  private String userPwdSalt;
  private String userPwdHash;
  private String userNickName;
  private String userToken;
  private String userAttach;
  private long created;
  private long updated;

}
