//
//  CIMRequest.swift
//  Coffchat
//
//  Created by fei.xu on 2020/3/16.
//  Copyright © 2020 Coffeechat Inc. All rights reserved.
//

import Foundation

/// 请求的响应结果
typealias IMResponseCallback = (_ header: IMHeader, _ data: Data) -> Void
/// 请求的响应超时了
typealias IMResponseTimeoutCallback = () -> Void

/// 一个业务请求，通常会有响应，通过callback接收
class IMRequest {
    public var header: IMHeader
    //public var callback: IMResponseCallback?
    public var seq: UInt16 { return header.seqNumber }
    public var timeoutCallback: IMResponseTimeoutCallback?

    // 请求发送时间
    public var createTimestamp: Int32

    init(header: IMHeader, /*callback: IMResponseCallback?,*/ timeout: IMResponseTimeoutCallback?) {
        self.header = header
        //self.callback = callback
        timeoutCallback = timeout
        createTimestamp = Int32(NSDate.now.timeIntervalSince1970)
        // self.seq = seq
    }
}
