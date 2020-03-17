//
//  CIMHeaderTests.swift
//  CoffchatTests
//
//  Created by xuyingchun on 2020/3/16.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import XCTest

@testable import Coffchat

class CIMHeaderTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    // 测试协议头的读写
    func testWriteReadHeader() {
        let header = IMHeader()
        header.setCommandId(cmdId: 12)
        header.setSeq(seq: 3)
        header.setMsg(msg: Data(repeating: 4, count: 10))

        let data = header.getBuffer()
        print(data!)

        let header2 = IMHeader()
        XCTAssert(header2.readHeader(data: data!))

        // copy bytes
        //let data2 = data![Int(kHeaderLen)..<data!.count]
        XCTAssert(header.seqNumber == header2.seqNumber)
        XCTAssert(header.commandId == header2.commandId)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
