//
//  CIMClient.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/10.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import CocoaAsyncSocket
import Foundation

// IM结果回调
typealias IMResultCallback<T> = (_ res: T) -> Void

protocol CIMClientProtocol {
    /// 登录
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - nick: 昵称
    ///   - userToken: 认证口令
    ///   - serverIp: 服务器IP
    ///   - port: 服务器端口
    ///   - callback: 登录结果回调
    func auth(userId: Int64, nick: String, userToken: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>?)
}

// IM连接
// 负责与服务端通信
class CIMClient: NSObject, GCDAsyncSocketDelegate, CIMClientProtocol {
    var tcpClient: GCDAsyncSocket?
    var ip: String = "10.0.106.117"
    var port: UInt16 = 8000
    
    override init() {
        super.init()
        print("CIMClient init")
        tcpClient = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    deinit {
        tcpClient?.delegate = nil
        tcpClient?.delegateQueue = nil
    }
    
    func connect(ip: String, port: UInt16) {
        self.ip = ip
        self.port = port
        
        if tcpClient!.isConnected {
            tcpClient?.disconnect()
        }
        
        print("CIMClient connect to \(ip):\(port)")
        do {
            try tcpClient?.connect(toHost: ip, onPort: port)
        } catch {
            print("connect error:\(error)")
        }
    }
    
    // 2、主界面UI显示数据
//        DispatchQueue.main.async {
//            let showStr: NSMutableString = NSMutableString()
//            showStr.append(self.msgView.text)
//            showStr.append(readClientDataString! as String)
//            showStr.append("\r\n")
//            self.msgView.text = showStr as String
//        }
    
    // 3、处理请求，返回数据给客户端OK
//        let serviceStr: NSMutableString = NSMutableString()
//        serviceStr.append("OK")
//        serviceStr.append("\r\n")
//        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
    
    // 4、每次读完数据后，都要调用一次监听数据的方法
//        clientSocket.readData(withTimeout: -1, tag: 0)
}

// MARK: GCDAsyncSocketDelegate

extension CIMClient {
//    func sendRequest(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    // connect
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("successful connected to \(host):\(port)")
    }
    
    // receive data
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("socket receive data,len=\(data.count)")
    }
    
    // disconnect
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket disconnected,error:\(String(describing: err))")
    }
}

// MARK: CIMClientProtocol

extension CIMClient {
    func auth(userId: Int64, nick: String, userToken: String, serverIp: String, port: UInt16, callback: IMResultCallback<CIM_Login_CIMAuthTokenRsp>?) {
        
    }
}
