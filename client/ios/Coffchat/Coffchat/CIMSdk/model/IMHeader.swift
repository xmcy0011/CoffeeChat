//
//  IMHeader.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/12.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 协议头长度
let kHeaderLen: UInt32 = 16
let kProtocolVersion: UInt16 = 1

/// 消息头部，自定义协议使用TLV格式
class IMHeader {
    var length: UInt32 = 0 // 4 byte，消息体长度
    var version: UInt16 = 0 // 2 byte,default 1
    var flag: UInt16 = 0 // 2byte，保留
    var serviceId: UInt16 = 0 // 2byte，保留
    var commandId: UInt16 = 0 // 2byte，命令号
    var seqNumber: UInt16 = 0 // 2byte，包序号
    var reversed: UInt16 = 0 // 2byte，保留

    var bodyData: Data? // 消息体

    /// 设置消息ID
    /// - Parameter cmdId: 消息ID
    func setCommandId(cmdId: UInt16) {
        commandId = cmdId
    }

    /// 设置消息体
    /// - Parameter msg: 消息体
    func setMsg(msg: Data) {
        bodyData = msg
    }

    /// 设置消息序号，请使用 [SeqGen.singleton.gen()] 生成
    /// - Parameter seq: 消息序列号
    func setSeq(seq: UInt16) {
        seqNumber = seq
    }

    /// 判断消息体是否完整
    /// - Parameter data: 数据
    class func isAvailable(data: Data) -> Bool {
        if data.count < kHeaderLen {
            return false
        }

        let buffer = [UInt8](data)

        // get total len
        var len: UInt32 = UInt32(buffer[0])
        for i in 0...3 { // 4 Bytes
            len = (len << 8) + UInt32(buffer[i])
        }
        return len <= data.count
    }

    /// 从二进制数据中尝试反序列化Header
    /// - Parameter data: 消息体
    func readHeader(data: Data) -> Bool {
        if data.count < kHeaderLen {
            return false
        }

        let buffer = [UInt8](data)

        // get total len
        // 按big-endian读取
        let len: UInt32 = UInt32(buffer[0]) << 24 + UInt32(buffer[1]) << 16 + UInt32(buffer[2]) << 8 + UInt32(buffer[3])
        if len < data.count {
            return false
        }

// big-endian
//        length(43):
//        - 0 : 0
//        - 1 : 0
//        - 2 : 0
//        - 3 : 43
//
//        version:
//        - 4 : 0
//        - 5 : 1
//
//        flag:
//        - 6 : 0
//        - 7 : 0
//
//        serviceId:
//        - 8 : 0
//        - 9 : 0
//
//        cmdid(257):
//        - 10 : 1
//        - 11 : 1
//
//        seq(3):
//        - 12 : 0
//        - 13 : 3
//
//        reversed:
//        - 14 : 0
//        - 15 : 0

        length = len
        version = UInt16(buffer[4]) << 8 + UInt16(buffer[5]) // big-endian
        flag = UInt16(buffer[6]) << 8 + UInt16(buffer[7])
        serviceId = UInt16(buffer[8]) << 8 + UInt16(buffer[9])
        commandId = UInt16(buffer[10]) << 8 + UInt16(buffer[11])
        seqNumber = UInt16(buffer[12]) << 8 + UInt16(buffer[13])
        reversed = UInt16(buffer[14]) << 8 + UInt16(buffer[15])
        return true
    }

    /// 转成2字节的bytes
    class func uintToBytes(num: UInt16) -> [UInt8] {
        // big-endian
        var bytes = [UInt8]()
        bytes.append(UInt8(num >> 8) )
        bytes.append(UInt8(num & 0xFF))
        // return [UInt8(truncatingIfNeeded: num << 8), UInt8(truncatingIfNeeded: num)]
        return bytes
    }

    /// 转成 4字节的bytes
    class func uintToFourBytes(num: UInt32) -> [UInt8] {
        return [UInt8(truncatingIfNeeded: num << 24), UInt8(truncatingIfNeeded: num << 16), UInt8(truncatingIfNeeded: num << 8), UInt8(truncatingIfNeeded: num)]
    }

    /// 获取消息体
    func getBuffer() -> Data? {
        if bodyData == nil {
            return nil
        }

        // this.seqNumber = SeqGen.singleton.gen();
        length = kHeaderLen + UInt32(bodyData!.count)
        version = kProtocolVersion

        var headerData = Data()
        headerData.append(contentsOf: IMHeader.uintToFourBytes(num: length)) // 总长度
        headerData.append(contentsOf: IMHeader.uintToBytes(num: version)) // 协议版本号
        headerData.append(contentsOf: IMHeader.uintToBytes(num: flag)) // 标志位
        headerData.append(contentsOf: IMHeader.uintToBytes(num: serviceId))
        headerData.append(contentsOf: IMHeader.uintToBytes(num: commandId)) // 命令号
        headerData.append(contentsOf: IMHeader.uintToBytes(num: seqNumber)) // 消息序号
        headerData.append(contentsOf: IMHeader.uintToBytes(num: reversed))

        return headerData + bodyData!
    }
}
