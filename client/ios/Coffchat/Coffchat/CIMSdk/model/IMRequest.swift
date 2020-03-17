//
//  CIMRequest.swift
//  Coffchat
//
//  Created by xuyingchun on 2020/3/16.
//  Copyright © 2020 Xuyingchun Inc. All rights reserved.
//

import Foundation

/// 请求的响应结果
typealias IMResponseCallback = (_ header: IMHeader, _ data: Data) -> Void

/// 一个业务请求，通常会有响应，通过callback接收
class IMRequest {
    public var header: IMHeader
    public var callback: IMResponseCallback?
    public var seq: UInt16 { return header.seqNumber }

    init(header: IMHeader, callback: IMResponseCallback?) {
        self.header = header
        self.callback = callback
        // self.seq = seq
    }
}
