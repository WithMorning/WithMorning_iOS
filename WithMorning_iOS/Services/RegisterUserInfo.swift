//
//  RegisterUserInfo.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/17/24.
//

import Foundation
import Combine
import UIKit

class RegisterUserInfo {
    
    static let shared = RegisterUserInfo()
    
//MARK: - 로그인 후 기본적인 유저디폴트 값
    
    @Published var loginState: LoginStatus? = nil
//    @Published var userVibrate : Bool? = false
//    @Published var profileImage : UIImage? = nil
//    @Published var nickName : String? = ""
//    @Published var userName : String? = ""
//    @Published var userEmail : String? = ""
//    @Published var userId: String? = ""

    
    private init() {}
}
