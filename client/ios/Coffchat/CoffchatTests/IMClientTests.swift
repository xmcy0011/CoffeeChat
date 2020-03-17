//
//  CIMClientTests.swift
//  CoffchatTests
//
//  Created by xuyingchun on 2020/3/16.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class IMClientTests: XCTestCase {
    // 执行其他测试之前需要先连接服务器
//    override func setUp() {
//        let client = IMClient()
//        client.connect(ip: "10.0.106.117", port:8000)
//        sleep(2)
//        XCTAssert(client.isConnected!)
//    }

    func testConnect() {
        let client = IMClient()
        _ = client.connect(ip: "10.0.106.117", port: 8000, callback: nil)

        sleep(3)
        XCTAssert(client.isConnected!)
    }

    func testAuth() {
        let ex = expectation(description: "")
        
        let client = IMClient()
        _ = client.auth(userId: 1008, nick: "赵丽", userToken: "12345", serverIp: "10.0.106.117", port: 8000) { rsp in
            XCTAssert(rsp.resultCode == CIM_Def_CIMErrorCode.kCimErrSuccsse)
            
            // 完成异步的单元测试，waitForExpectations的timeout不会出发，测试通过
            ex.fulfill()
        }

        // 异步方法的单元测试写法
       waitForExpectations(timeout: 15, handler: nil)
    }
}
