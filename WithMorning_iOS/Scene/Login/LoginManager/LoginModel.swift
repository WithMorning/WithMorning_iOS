//
//  LoginModel.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/16/24.
//

import Foundation


enum LoginStatus {
    case login //로그인
    case logout//로그아웃
    case guest //게스트모드
}
//MARK: - 애플로그인

struct AppleloginRequest: Codable {
    let code: String
}

struct AppleloginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: AppleLoginData?
}

struct AppleLoginData: Codable {
    let accessToken: String
}

struct AppleloginFailResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}