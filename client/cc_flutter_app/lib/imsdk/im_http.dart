import 'dart:convert';

import 'package:dio/dio.dart';

const DefaultHttpServerPort = 18080;
const DefaultRegisterUserAPI = "/user/register";
const DefaultQueryUserAPI = "/user/nickname/query";

// 通用结果
class HttpResult {
  int errorCode;
  String errorMsg;

  HttpResult(this.errorCode, this.errorMsg);
}

// 查询用户昵称结果
class RegisterUserResult extends HttpResult {
  String nickName;

  RegisterUserResult(int errorCode, String errorMsg, this.nickName) : super(errorCode, errorMsg);
}

class IMHttp {
  /// 单实例
  static final IMHttp singleton = IMHttp._internal();

  var serverIp;

  factory IMHttp() {
    return singleton;
  }

  IMHttp._internal();

  void setServerIp(String ip) {
    serverIp = ip;
  }

  /// 注册新用户
  /// ip：IM服务器地址
  Future<HttpResult> httpRegisterUser(int userId, String nickName, String token) async {
    try {
      var dio = Dio();
      dio.options.baseUrl = "http://" + serverIp + ":" + DefaultHttpServerPort.toString();
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 3000;
      dio.options.contentType = Headers.jsonContentType;

      print("http register,url=${dio.options.baseUrl}$DefaultRegisterUserAPI");

      var response = await dio.post(
        DefaultRegisterUserAPI,
        data: {'user_id': userId, 'user_nick_name': nickName, 'user_token': token},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        return new HttpResult(data['error_code'], data['error_msg'].toString());
      }
    } catch (ex) {
      return new HttpResult(-1, "注册失败：" + ex.toString());
    }
    return new HttpResult(-1, "注册失败，未知错误");
  }

  /// 查询用户昵称
  Future<RegisterUserResult> httpQueryUserNickName(int userId, String nickName, String token) async {
    try {
      var dio = Dio();
      dio.options.baseUrl = "http://" + serverIp + ":" + DefaultHttpServerPort.toString();
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 3000;

      print("http register,url=${dio.options.baseUrl}$DefaultQueryUserAPI");

      var response = await dio.get(DefaultRegisterUserAPI, queryParameters: {
        "user_id": userId,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        return new RegisterUserResult(data['error_code'], data['error_msg'].toString(), data['nick_name'].toString());
      }
    } catch (ex) {
      return new RegisterUserResult(-1, "注册失败：" + ex.toString(), "");
    }
    return new RegisterUserResult(-1, "注册失败，未知错误", "");
  }
}
