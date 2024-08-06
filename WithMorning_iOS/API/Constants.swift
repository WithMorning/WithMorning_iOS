//
//  Constants.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

//MARK: - dummydata
struct AlarmModel{
   //var cellText : Int
    var isTurn : Bool
    var alarmTitle : String
    var Memo : String
    var memberCount : Int
}

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
    let bedtime: Int
    let dayOfWeekList: [String]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL, nickname, bedtime, dayOfWeekList
    }
}


