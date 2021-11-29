package com.xuyc.cim;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author xmcy0011@sina.com
 */
@SpringBootApplication
@MapperScan("com.xuyc.cim.dao")
public class CimApplication {

  public static void main(String[] args) {
    SpringApplication.run(CimApplication.class, args);
  }

}
