//
//  Model.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

struct Mainpage: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MainpageResponse?
}

struct MainpageResponse: Codable {
    let connectorProfileURL: String?
    let connectorNickname: String?
    let groupList: [GroupList]?
    let listSize: Int
}

// MARK: - GroupList
struct GroupList: Codable {
    let groupID: Int
    let isDisturbBanGroup: Bool
    let name, wakeupTime: String
    let dayOfWeekList: [String]?
    let userList: [UserList]?
    let memo: String
    let participationCode: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case isDisturbBanGroup
        case name, wakeupTime, dayOfWeekList, userList, memo
        case participationCode
    }
}

// MARK: - UserList
struct UserList: Codable {
    let userID: Int
    let imageURL: String?
    let nickname: String?
    let isWakeup, isDisturbBanMode: Bool
    let isAgree: Bool
    let phone: String?
    let isHost : Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL, nickname, isWakeup, isDisturbBanMode
        case isAgree, isHost
        case phone
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
    let imageURL: String?
    let nickname: String?
    let bedtime: String?
    let isAllowBedTimeAlarm: Bool?
    let dayOfWeekList: [String]?
    
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
    let joinUserNickname, joinAt: String?

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

//MARK: - 방해금지모드
struct DisturbMaindata: Codable { 
    let isDisturbBanMode: Bool
}

struct DisturbResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 콕 찌르기
struct prickRequest: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
struct prickResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 기상상태로 변경
struct wakeupResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 알람 나가기
struct leavegroupResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

//MARK: - 그룹 수정
struct EditGroupMaindata: Codable {
    let name, wakeupTime: String
    let dayOfWeekList: [String]
    let isAgree: Bool
    let memo: String
}
struct EditgroupResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
//MARK: - 전화번호 공개 수정
struct EditphoneMaindata: Codable {
    let isAgree: Bool
}
struct EditphoneagreeResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

