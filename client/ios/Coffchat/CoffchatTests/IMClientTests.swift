//
//  CIMClientTests.swift
//  CoffchatTests
//
//  Created by fei.xu on 2020/3/16.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class IMClientTests: XCTestCase,IMClientDelegateStatus{
    var testConnectEx:XCTestExpectation?
    var client:IMClient?
    // 执行其他测试之前需要先连接服务器
//    override func setUp() {
//        let client = IMClient()
//        client.connect(ip: "10.0.106.117", port:8000)
//        sleep(2)
//        XCTAssert(client.isConnected!)
//    }

    func testConnect() {
        testConnectEx = expectation(description: "")
        client = IMClient()
        client?.register(key: "IMClientTests", delegateStatus: self)
        _ = client?.connect(ip: "192.168.31.174", port: 8000)

        // 异步方法的单元测试写法
        waitForExpectations(timeout: 3, handler: nil)
    }
}

// MARK: IMClientDelegate

extension IMClientTests{
    func onConnected(_ host: String, port: UInt16) {
        IMLog.debug(item: "recv onConnected")
        testConnectEx?.fulfill()
    }
    
    func onDisconnect(_ err: Error?) {
        
    }
}
