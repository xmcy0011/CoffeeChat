# HTTP REST API

## 创建用户

```http
POST http://ip:port/user/register HTTP/1.1
Content-Type:application/json; charset=utf-8
```

请求：
```json
{
    "user_id": 1003,
    "user_nick_name":"小姐姐美腻",
    "user_token":"12345"
}
```

响应：
```json
{
    "error_code": 0,
    "error_msg":"success",
}
```

## 查询用户昵称

```http
GET http://ip:port/user/nickname/query HTTP/1.1
```

请求：
```json
{
    "user_id": 1003
}
```

响应：
```json
{
    "error_code": 0,
    "error_msg":"success",
    "nick_name":"小姐姐美腻"
}
```
