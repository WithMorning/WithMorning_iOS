//
//  LoginModel.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/16/24.
//

import Foundation

enum LoginStatus {
    case logout//로그아웃
    case login //로그인
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
    let refreshToken: String
}

struct AppleloginFailResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 리프레쉬로 엑세스 재발급
struct getToken: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: getTokenResponse?
}
struct getTokenResponse: Codable {
    let accessToken: String?
}

//MARK: - 로그아웃
struct deletelogoutRequest: Codable {
    let refreshToken: String
}
struct deletelogoutResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 회원탈퇴
struct deleteaccountResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

