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

final class AppleLoginManager : NSObject {
    
    let registerUserInfo = RegisterUserInfo.shared
    static let shared = AppleLoginManager()
    
    //MARK: - ID토큰이 명시적으로 부여되었는지 확인
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
            
            //            guard let nonce = currentNonce else
            guard currentNonce != nil else {
                fatalError(" - Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print(#fileID, #function, #line," - Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print(#fileID, #function, #line," - Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let codeString = String(data: authorizationCode, encoding: .utf8) {
                print(#fileID, #function, #line, "- codeString🔥: \(codeString)")
                
                let loginRequestTokenData = AppleloginRequest(code: idTokenString)
                
                //                let loginRequestTokenData = AppleloginRequest(code: idTokenString, authorizationCode: codeString) 코드 두개를 보낼 생각
                
                //MARK: - 로그인 요청
                AF.request(LoginRouter.AppleLogin(data: loginRequestTokenData))
                    .responseDecodable(of: AppleloginResponse.self) { (response: DataResponse<AppleloginResponse, AFError> ) in
                        switch response.result {
                        case .failure(let error):
                            print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                        case .success(let data):
                            if let dataResult = data.result {
//                                #warning("UserDeault에 userID 저장 후 userID로 토큰 저장")
                                KeyChain.create(key: "accessToken", token: dataResult.accessToken)
                                KeyChain.create(key: "refreshToken", token: dataResult.refreshToken)
                            }
                            
                            self.registerUserInfo.loginState = .login
                            print("🔥KeyChain에 저장된 accessToken : ", KeyChain.read(key: "accessToken") ?? "")
                            print("🔥KeyChain에 저장된 refreshToken : ",KeyChain.read(key: "refreshToken") ?? "")
                        }
                        
                    }
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("로그인 실패 - \(error.localizedDescription)")
    }
}
