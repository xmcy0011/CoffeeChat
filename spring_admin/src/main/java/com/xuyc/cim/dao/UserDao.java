package com.xuyc.cim.dao;

import com.xuyc.cim.pojo.User;
import java.util.Collection;
import java.util.HashMap;

/**
 * @author xmcy0011@sina.com
 */
public class UserDao {

  private static Integer initUserId = 6;
  private static HashMap<Integer, User> userMap = null;

  static {
    userMap = new HashMap<Integer, User>();
    userMap.put(1, new User(1, 1, "admin", "admin@126.com"));
    userMap.put(2, new User(2, 2, "xmcy0011", "xmcy0011@126.com"));
  }

  /**
   * 增加一个用户
   *
   * @param u: 用户信息
   */
  public void add(User u) {
    if (u.getId() == null) {
      u.setId(initUserId++);
    }

    userMap.put(u.getId(), u);
  }

  public Collection<User> getAllUser() {
    return userMap.values();
  }

  public boolean delete(Integer id) {
    return userMap.remove(id) != null;
  }


}
