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

//MARK: - 프로필 등록

struct profileRequest: Encodable {
    let request: Requestprofile
    let imageData: URL?
}

struct Requestprofile: Codable {
    let nickname: String
    let fcmToken: String
}


//struct ProfileRequest: Codable {
//    let nickname: String
//    let fcmToken: String
//    
//    enum CodingKeys: String, CodingKey {
//        case nickname
//        case fcmToken
//    }
//}

//프로필 등록 리스폰
struct profileResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

