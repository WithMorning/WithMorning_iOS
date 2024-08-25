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

// MARK: - Mainpage
struct Mainpage: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MainpageResponse?
}

struct MainpageResponse: Codable {
    let 커넥터ID, connectorProfileURL: String
    let groupList: [GroupList]?
    let listSize: Int
    
    enum CodingKeys: String, CodingKey {
        case 커넥터ID = "커넥터 id"
        case connectorProfileURL, groupList, listSize
    }
}

struct GroupList: Codable {
    let groupID: Int
    let name, wakeupTime: String
    let dayOfWeekList: [String]
    let userList: [UserList]?
    let memo: String
    
    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case name, wakeupTime, dayOfWeekList, userList, memo
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
