//
//  CIMHeaderTests.swift
//  CoffchatTests
//
//  Created by fei.xu on 2020/3/16.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
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
        // let data2 = data![Int(kHeaderLen)..<data!.count]
        XCTAssert(header.seqNumber == header2.seqNumber)
        XCTAssert(header.commandId == header2.commandId)
    }

    func testData() {
        let bytes: [UInt8] = [12, 32, 12, 23, 42, 24, 24, 24, 24, 24, 24, 24, 42, 123, 124, 12, 55, 36, 46, 77, 86]
        // 构造data对象
        var data = Data()
        // 模拟追加数据
        data.append(Data(bytes: bytes, count: bytes.count))
        print("old:\(data)")
        
        let start = 5
        
        let item = data[0...12]
        let itemBytes = [UInt8](item)
        
        // 模拟读取了部分数据（在xcode中，鼠标移动到该变量上，可以点击“!”查看)
        let buffer = data.subdata(in: start..<data.count)
        print("subdata:\(data)")
        print("buffer:\(buffer)")
        
        // replace
        data.replaceSubrange(0..<buffer.count, with: buffer)
        print("replace:\(data)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
