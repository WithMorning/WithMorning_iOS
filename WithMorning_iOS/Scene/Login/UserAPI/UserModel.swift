//
//  UserModel.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/5/24.
//

import Foundation
import Alamofire

//MARK: - 휴대폰인증
struct SMSnumRequest: Codable {
    let phone: String
}

struct SMSnumResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 인증코드 입력
struct SMScodeResquest: Codable {
    let phone, code: String
}

struct SMScodeResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}


