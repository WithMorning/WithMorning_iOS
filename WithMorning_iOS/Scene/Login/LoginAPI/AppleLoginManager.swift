//
//  AppleLoginManager.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/5/24.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Security
import Alamofire
import SwiftJWT

final class AppleLoginManager : NSObject {
    
    let registerUserInfo = RegisterUserInfo.shared
    
    static let shared = AppleLoginManager()
    
    //MARK: - ID 토큰이 명시적으로 부여되었는지 확인
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        //nonce생성
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    //MARK: - nonce를 hash하는 코드
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    //MARK: - 애플 로그인 시작
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        print(#fileID, #function, #line, "- 애플 로그인 시작🍎")
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest() //request만들기
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.performRequests()
        
    }
    
}

extension AppleLoginManager : ASAuthorizationControllerDelegate {
    
    // Apple ID 로그인에 성공한 경우, 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(#fileID, #function, #line, "- 애플 로그인 성공🍎")
            
            guard currentNonce != nil else {
                fatalError(" - Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8),
                  let authorizationCode = appleIDCredential.authorizationCode,
                  let codeString = String(data: authorizationCode, encoding: .utf8) else {
                print("Failed to get required tokens")
                return
            }
            
            let loginRequestTokenData = AppleloginRequest(identityToken: idTokenString, code: codeString) //id토큰, auth토큰 전송할 데이터 셋
            
            print(#fileID, #function, #line, "- codeString🔥: \(codeString)")
            print(#fileID, #function, #line, "- idTokenString🔥: \(idTokenString)")
            
            //MARK: - 로그인 요청
            AF.request(LoginRouter.AppleLogin(data: loginRequestTokenData))
                .responseDecodable(of: AppleloginResponse.self) { (response: DataResponse<AppleloginResponse, AFError> ) in
                    switch response.result {
                    case .failure(let error):
                        print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                    case .success(let data):
                        guard let dataResult = data.result else {
                            if let data = response.data, let str = String(data: data, encoding: .utf8) {
                                print("서버 응답:", str)
                            }
                            return
                        }
                        
                        self.handleLoginSuccess(with: dataResult)
                        
                    }
                }
            
        }
    }
    
    private func handleLoginSuccess(with data: AppleLoginData) {
        KeyChain.create(key: "accessToken", token: data.accessToken)
        KeyChain.create(key: "refreshToken", token: data.refreshToken)
        
        print("🔐 KeyChain에 저장된 accessToken: \(KeyChain.read(key: "accessToken") ?? "")")
        print("🔐 KeyChain에 저장된 refreshToken: \(KeyChain.read(key: "refreshToken") ?? "")")
        
        // 회원탈퇴 상태가 아닐 경우에만 isExistingUser를 true로 설정
        if UserDefaults.getUserState() != "deleteaccount" {
            UserDefaults.standard.set(true, forKey: "isExistingUser")
            UserDefaults.setUserState("login")  // 바로 로그인 상태로 변경
        } else {
            // 회원탈퇴 후 재로그인의 경우
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            UserDefaults.setUserState("register")  // 회원가입 절차로 이동
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("UserStateChanged"), object: nil)
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("로그인 실패 - \(error.localizedDescription)")
    }
    
}

