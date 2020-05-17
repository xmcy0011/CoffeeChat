//
//  IMManagerTests.swift
//  CoffchatTests
//
//  Created by fei.xu on 2020/3/21.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class IMLoginManagerTests: XCTestCase, IMLoginManagerDelegate {
    var loginManager: IMLoginManager?
    var testAuthAndReConnectEx: XCTestExpectation?
    var testAuthAndReConnectSuccessTimes: Int = 0

    func testAuth() {
        let ex = expectation(description: "")
        let manager = IMManager.singleton.loginManager
        _ = manager.register(key: "IMLoginManagerTests", delegate: self)
        _ = manager.login(userId: 1008, nick: "赵丽", userToken: "12345", serverIp: "192.168.31.174", port: 8000) { rsp in
            XCTAssert(rsp.resultCode == CIM_Def_CIMErrorCode.kCimErrSuccsse)

            // 完成异步的单元测试，waitForExpectations的timeout不会出发，测试通过
            ex.fulfill()
        }

        // 异步方法的单元测试写法
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testAuthAndReConnect() {
        testAuthAndReConnectEx = expectation(description: "")
        loginManager = IMManager.singleton.loginManager
        _ = loginManager?.register(key: "IMLoginManagerTests", delegate: self)
        // 先登录
        _ = loginManager?.login(userId: 1008, nick: "赵丽", userToken: "12345", serverIp: "192.168.31.174", port: 8000) { rsp in
            XCTAssert(rsp.resultCode == CIM_Def_CIMErrorCode.kCimErrSuccsse)
        }

        // 异步方法的单元测试写法
        waitForExpectations(timeout: 120, handler: nil)
    }
}

// MARK: IMLoginManagerDelegate

extension IMLoginManagerTests {
    func onLogin(step: IMLoginStep) {
        print("step:\(step)")

        if step == .LoginOK {
            testAuthAndReConnectSuccessTimes += 1
        }

        // 超过成功2次，认为测试通过
        if testAuthAndReConnectSuccessTimes >= 2 {
            testAuthAndReConnectEx?.fulfill()
        }
    }

    func onAutoLoginFailed(code: Error) {}
}
