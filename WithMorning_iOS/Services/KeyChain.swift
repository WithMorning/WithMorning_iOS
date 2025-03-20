//
//  KeyChain.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/17/24.
//

import Foundation
import Security

class KeyChain {
    
    //MARK: - create
    class func create(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,   // 저장할 Account
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any   // 저장할 Token
        ]
        SecItemDelete(query)    // Keychain은 Key값에 중복이 생기면, 저장할 수 없기 때문에 먼저 Delete해줌
        let status = SecItemAdd(query, nil)
        assert(status == noErr,"토큰 저장 실패")
    }
    
    //MARK: - read
    class func read(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne       // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            print("키체인 로딩 실패, status code = \(status)")
            return nil
        }
    }
    
    //MARK: - delete
    class func delete(key: String) {
        // Keychain 쿼리 정의
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        // 해당 키가 존재하는지 확인
        let queryCopy = query
        var result: AnyObject?
        
        let status = SecItemCopyMatching(queryCopy, &result)
        
        // Keychain에 해당 항목이 존재할 경우에만 삭제
        if status == errSecSuccess {
            let deleteStatus = SecItemDelete(query)
            assert(deleteStatus == noErr, "값을 지울 수 없습니다., status code = \(deleteStatus)")
        } else {
            print("해당 항목이 Keychain에 존재하지 않습니다. status code = \(status)")
        }
    }
}
