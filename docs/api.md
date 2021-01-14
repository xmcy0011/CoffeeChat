# 用户管理

## 注册

```http
POST http://106.14.172.35:18080/user/register HTTP/1.1
Content-Type:application/json;charset=utf-8
```

PS：1小时用户注册上限100个。

```json
{
  "userName": "CoffeeChat",
  "userNickName":"测试账号",
  "userPwd": "E10ADC3949BA59ABBE56E057F20F883E"
}
```

```json
{
  "error_code": 0,
  "error_msg": "success"
}
```

## 查询昵称

```http
POST http://106.14.172.35:18080/user/nickname/query HTTP/1.1
Content-Type:application/json;charset=utf-8
```

```json
{
  "userId": 12
}
```

```json
{
  "error_code": 0,
  "error_msg": "success"
}
```