import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';

/// 序列号生成器 自增生成
class SeqGen {
  static final SeqGen singleton = SeqGen._internal();
  int _seqNumber;

  factory SeqGen() {
    return singleton;
  }

  SeqGen._internal() {
    _seqNumber = 0;
  }

  gen() {
    return ++_seqNumber;
  }
}

/// 协议头长度
const kHeaderLen = 16;
const kDefaultProtocolVersion = 1;

/// 16Byte协议头
class IMHeader {
  int length = 0; // 4 byte，消息体长度
  int version = 0; // 2 byte,default 1
  int flag = 0; // 2byte，保留
  int serviceId = 0; // 2byte，保留
  int commandId = 0; // 2byte，命令号
  int seqNumber = 0; // 2byte，包序号
  int reversed = 0; // 2byte，保留

  GeneratedMessage message;

  IMHeader();

  void setCommandId(int cmdId) {
    this.commandId = cmdId;
  }

  void setMsg(GeneratedMessage msg) {
    this.message = msg;
  }

  /// 设置消息序号，请使用 [SeqGen.singleton.gen()] 生成
  void setSeq(int seqNumber) {
    this.seqNumber = seqNumber;
  }

  static bool isAvailable(List<int> data) {
    if (data.length < kHeaderLen) {
      return false;
    }

    // get total len
    int length = data[0];
    for (int i = 1; i < 4; i++) {
      length = (length << 8) + data[i];
    }

    return length <= data.length;
  }

  /// 从二进制数据中尝试反序列化Header
  /// [data] 二进制数据
  /// [IMHeader] 实例
  bool readHeader(List<int> data) {
    if (data.length < kHeaderLen) {
      return false;
    }

    // get total len
    int len = data[0];
    for (int i = 1; i < 4; i++) {
      len = (len << 8) + data[i];
    }

    if (len < data.length) {
      return false;
    }

    List<int> buffer = new List.from(data, growable: false);
    this.length = len;
    this.version = (buffer[4] << 8) + buffer[5];
    this.flag = (buffer[6] << 8) + buffer[7];
    this.serviceId = (buffer[8] << 8) + buffer[9];
    this.commandId = (buffer[10] << 8) + buffer[11];
    this.seqNumber = (buffer[12] << 8) + buffer[13];
    this.reversed = (buffer[14] << 8) + buffer[15];
    return true;
  }

  List<int> getBuffer() {
    Uint8List bodyData = message.writeToBuffer();

    //this.seqNumber = SeqGen.singleton.gen();
    this.length = kHeaderLen + bodyData.length;
    this.version = kDefaultProtocolVersion;

    Uint8List head = Uint8List(kHeaderLen);
    var headBuff = new ByteData.view(head.buffer);
    headBuff.setInt32(0, length); // 总长度
    headBuff.setInt16(4, version); // 协议版本号
    headBuff.setInt16(6, flag); // 标志位
    headBuff.setInt16(8, serviceId);
    headBuff.setInt16(10, commandId); // 命令号
    headBuff.setInt16(12, seqNumber); // 消息序号
    headBuff.setInt16(14, reversed);
    List<int> buffer = head + bodyData;
    return buffer;
  }
}
