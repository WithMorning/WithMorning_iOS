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
    
//MARK: - 로그인 후
    @Published var loginState: LoginStatus? = nil
    @Published var nickName : String? = ""
    @Published var profileImage : UIImage? = nil
    @Published var privateNumber : Bool = false

    private init() {}
}

//1.set
//UserDefaults.standard.set(userName, forKey: "name")
//2. get
//UserDefaults.standard.string(forKey: "name")
//3. remove
//UserDefaults.standard.removeObject(forKey: "name")
