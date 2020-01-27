import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter_app/imsdk/core/dao/user_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/model/model.dart';
import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';

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
  int userId;

  RegisterUserResult(int errorCode, String errorMsg, this.userId, this.nickName) : super(errorCode, errorMsg);
}

class IMUser {
  /// 单实例
  static final IMUser singleton = IMUser._internal();

  var serverIp;

  factory IMUser() {
    return singleton;
  }

  IMUser._internal();

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
  /// 如果本地有，则从本地加载。否则，从服务端拉取
  /// [return] RegisterUserResult
  Future<dynamic> queryUserNickName(Int64 userId, bool forceUpdate) async {
    var userDb = new UserDbProvider();
    var user = await userDb.get(userId.toInt());
    if (user != null && user.nickName != "" && !forceUpdate) {
      return new RegisterUserResult(0, "", userId.toInt(), user.nickName);
    }

    // 从服务端拉取
    var completer = new Completer();
    var dio = Dio();
    dio.options.baseUrl = "http://" + serverIp + ":" + DefaultHttpServerPort.toString();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;

    print("http query,url=${dio.options.baseUrl}$DefaultQueryUserAPI");
    dio.get(DefaultQueryUserAPI, queryParameters: {"user_id": userId}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        completer.complete(new RegisterUserResult(
            data['error_code'], data['error_msg'].toString(), userId.toInt(), data['nick_name'].toString()));

        // 更新本地缓存
        if (data['error_code'] == 0) {
          UserModel user2 = new UserModel();
          user2.userId = userId.toInt();
          user2.nickName = data['nick_name'].toString();
          user2.avatarURL = "";
          user2.avatarPath = "";
          user2.attachInfo = "";
          if (user != null) {
            userDb.updateNickName(userId.toInt(), user2.nickName);
          } else {
            userDb.insert(userId.toInt(), user2);
          }
        }
      } else {
        completer.complete(
            new RegisterUserResult(-1, "http status code " + response.statusCode.toString(), userId.toInt(), ""));
      }
    }).catchError((e) {
      completer.complete(new RegisterUserResult(-1, e.toString(), userId.toInt(), ""));
    });
    return completer.future;
  }
}
