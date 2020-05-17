//
//  IMConversationManagerTests.swift
//  CoffchatTests
//
//  Created by fei.xu on 2020/3/22.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class IMConversationManagerTests: XCTestCase {
    // 测试获取会话列表
    func testGetAllRecentSessions() {
        let ex = expectation(description: "")
        _ = IMManager.singleton.loginManager.login(userId: 1008, nick: "1008", userToken: "12345", serverIp: "192.168.31.174", port: 8000) { rsp in
            XCTAssert(rsp.resultCode == .kCimErrSuccsse)

            IMManager.singleton.conversationManager.queryAllRecentSessions(callback: { rspSession in
                XCTAssert(rspSession.contactSessionList.count > 0)
                ex.fulfill()
            }, timeout: {
                print("timeout")
            })
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
