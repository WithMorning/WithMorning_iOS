//
//  Constants.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

// MARK: - Mypage
struct Mypage: Codable {
    let isSuccess: Bool?
    let code: Int
    let message: String
    let result: MypageResponse?
}

struct MypageResponse: Codable {
    let userID: Int
    let imageURL, nickname: String
    let bedtime: Int?
    let dayOfWeekList: [String]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL, nickname, bedtime, dayOfWeekList
    }
}

// MARK: - Mainpage
struct Mainpage: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MainpageResponse?
}

struct MainpageResponse: Codable {
    let connectorProfileURL: String
    let groupList: [GroupList]?
    let listSize: Int
}

struct GroupList: Codable {
    let groupID: Int
    let name, wakeupTime: String
    let wakeUpDayOfWeekList: [String]
    let userList: [UserList]?
    let memo: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case name, wakeupTime, wakeUpDayOfWeekList, userList, memo
    }
}

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
