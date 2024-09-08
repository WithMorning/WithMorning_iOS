//
//  Model.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

// MARK: - 메인페이지
struct Mainpage: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MainpageResponse?
}

struct MainpageResponse: Codable {
    let connectorProfileURL: String?
    let groupList: [GroupList]?
    let listSize: Int
}

    // MARK: - GroupList
struct GroupList: Codable {
    let groupID: Int
    let name, wakeupTime: String
    let dayOfWeekList: [String]?
    let userList: [UserList]?
    let memo: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case name, wakeupTime, dayOfWeekList, userList, memo
    }
}

    // MARK: - UserList
struct UserList: Codable {
    let userID: Int
    let imageURL, nickname: String
    let isWakeup, isDisturbBanMode: Bool
    let phone: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL, nickname, isWakeup, isDisturbBanMode, phone
    }
}

// MARK: - 마이페이지
struct Mypage: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MypageResponse?
}

struct MypageResponse: Codable {
    let userID: Int
    let imageURL, nickname, bedtime: String
    let isAllowBedTimeAlarm: Bool
    let dayOfWeekList: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL, nickname, bedtime, isAllowBedTimeAlarm, dayOfWeekList
    }
}

//MARK: - 그룹 생성 request
struct MakeGroupMaindata: Codable {
    let name, wakeupTime: String
    let dayOfWeekList: [String]
    let isAgree: Bool
    let memo: String
}

//MARK: - 그룹 생성
struct Makegroup: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MakegroupResponse?
}

struct MakegroupResponse: Codable {
    let groupID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case createdAt
    }
}
//MARK: - 그룹삭제
struct Deletegroup: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 초대코드로 방 입장 request
struct JoingroupMaindata: Codable {
    let participationCode: String
    let isAgree: Bool
}

//MARK: - 초대코드로 방 입장
struct Joingroup: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: JoingroupResponse?
}

struct JoingroupResponse: Codable {
    let groupID: Int
    let joinUserNickname, joinAt: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case joinUserNickname, joinAt
    }
}

//MARK: - 취침알림 시간 및 요일 설정
struct BedtimeMaindata: Codable { //request
    let bedTime: String
    let bedDayOfWeekList: [String]
    let isAllowBedTimeAlarm: Bool
}

struct Bedtime: Codable { //response
    let isSuccess: Bool
    let code: Int
    let message: String
}
