import 'dart:io';

class ImClient {
  void login(var userId, var nickName, var userToken, var ip, var port) {
    var socket = RawSocket.connect(ip, port, timeout: Duration(seconds: 5));
    socket.then((value) {});
  }
}
