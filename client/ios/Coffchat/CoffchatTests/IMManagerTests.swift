//
//  IMManagerTests.swift
//  CoffchatTests
//
//  Created by xuyingchun on 2020/3/21.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class IMManagerTests: XCTestCase {
    func testAuth() {
        let ex = expectation(description: "")
        _ = IMManager.singleton.auth(userId: 1008, nick: "赵丽", userToken: "12345", serverIp: "192.168.31.174", port: 8000) { rsp in
            XCTAssert(rsp.resultCode == CIM_Def_CIMErrorCode.kCimErrSuccsse)
            
            // 完成异步的单元测试，waitForExpectations的timeout不会出发，测试通过
            ex.fulfill()
        }

        // 异步方法的单元测试写法
       waitForExpectations(timeout: 15, handler: nil)
    }
}
