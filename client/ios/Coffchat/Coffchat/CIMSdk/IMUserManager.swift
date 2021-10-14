//
//  IMUserManager.swift
//  Coffchat
//
//  Created by fei.xu on 2021/1/15.
//  Copyright © 2021 Coffeechat Inc. All rights reserved.
//

import Alamofire
import CryptoSwift
import Foundation
import SwiftyJSON

struct HttpUserRegisterReq: Encodable {
    var userName: String
    var userNickName: String
    var userPwd: String
}

struct HttpResult {
    var errorCode: Int
    var errorMsg: String
}

class IMUserManager {
    // let kHost: String = "10.0.107.244:18080"
    var host: String = "127.0.0.1:18080"
    let kUrlRegisterUser: String = "user/register"

    func setHttpHost(addr: String) {
        self.host = addr + ":18080"
    }
    
    func registerUser(userName: String, userPwd: String, userNickName: String, cb: IMResultCallback<HttpResult>?) {
        // md5
        let pwdMd5 = userPwd.md5()
        let req = HttpUserRegisterReq(userName: userName, userNickName: userNickName, userPwd: pwdMd5)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
        ]

        AF.request("http://" + self.host + "/" + kUrlRegisterUser,
                   method: .post,
                   parameters: req,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
            debugPrint("Response: \(response)")
            var errorCode = 0
            var errorMsg = "unknown"
            do {
                let json = try JSON(data: response.data!)
                errorCode = json["error_code"].intValue
                errorMsg = json["error_msg"].stringValue
            } catch {
                IMLog.error(item: "connect error:\(error)")
            }

            if cb != nil {
                let result = HttpResult(errorCode: errorCode, errorMsg: errorMsg)
                cb!(result)
            }
        }
    }
}
