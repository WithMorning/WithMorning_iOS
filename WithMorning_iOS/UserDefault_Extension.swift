//
//  UserDefault_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/11/24.
//

import Foundation
import UIKit

extension UserDefaults {
    
    //private Number 등록
    static func setPrivateNumber(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "privateNumber")
    }
    
    //private Number 가져오기
    static func getPrivateNumber() -> Bool {
        return UserDefaults.standard.bool(forKey: "privateNumber")
    }
    
    //userstate 설정
    static func setUserState(_ state: String) {
        return UserDefaults.standard.set(state, forKey: "userState")
    }
    
    //userstate 가져오기
    static func getUserState() -> String? {
        return UserDefaults.standard.string(forKey: "userState")
    }
    
    // Float 타입 데이터를 불러올 때 기본값을 제공하는 메서드
    func float(forKey key: String, default defaultValue: Float) -> Float {
        return self.object(forKey: key) as? Float ?? defaultValue
    }
    
    // Bool 타입 데이터를 불러올 때 기본값을 제공하는 메서드
    func bool(forKey key: String, default defaultValue: Bool) -> Bool {
        return self.object(forKey: key) as? Bool ?? defaultValue
    }
}
