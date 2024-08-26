//
//  AuthInterceptor.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/22/24.
//

import Foundation
import Alamofire

class AuthInterceptor : RequestInterceptor{
    
    //MARK: - Authorization를 header에 넣어줄 수 있습니다.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        guard let accessToken = KeyChain.read(key:"accessToken") else {
            print("⚠️ adapt - KeyChain에서 엑세스 토큰을 찾을 수 없습니다")
            return
        }
        print("🔑 adapt - 요청에 엑세스 토큰 추가: \(accessToken)")
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    //MARK: - accessToken이 만료되었을때 refreshToken 통해 accessToken재발급
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            print("❌ retry - HTTP 응답을 가져올 수 없습니다")
            return
        }
        print("📊 retry - 응답 상태 코드: \(response.statusCode)")
        
        //MARK: - 재발급 시도
        if response.statusCode == 9104 {
            print("🚨 retry - 엑세스 토큰 만료. 갱신 시도 중...")
            guard let refreshToken = KeyChain.read(key: "refreshToken") else {
                print("⚠️ retry - KeyChain에서 리프레시 토큰을 찾을 수 없습니다")
                return
            }
            print("🔄 retry - 사용 중인 리프레시 토큰: \(refreshToken)")
            
            AF.request(LoginRouter.getNewAccessToken(refreshToken: refreshToken))
                .validate(statusCode: 200..<300)
                .responseDecodable(of: getTokenResponse.self) { response in
                    switch response.result {
                    case .failure(let error):
                        print("❌ retry - 토큰 갱신 실패: \(error.localizedDescription)")
                        completion(.doNotRetry)
                        
                    case .success(let data):
                        guard let tokens = data.result else {
                            print("⚠️ retry - 응답에 토큰이 없습니다")
                            return
                        }
                        
                        if let newAccessToken = tokens.accessToken {
                            print("✅ retry - 새 엑세스 토큰 수신: \(newAccessToken)")
                            KeyChain.create(key: "accessToken", token: newAccessToken)
                        }
                        
                        print("🔄 retry - 새 토큰으로 요청 재시도")
                        completion(.retry)
                    }
                }
        } else {
            print("ℹ️ retry - 토큰 갱신이 필요하지 않습니다")
            completion(.doNotRetry)
        }
        print("📌 현재 KeyChain의 엑세스 토큰: \(KeyChain.read(key: "accessToken") ?? "없음")")
        print("📌 현재 KeyChain의 리프레시 토큰: \(KeyChain.read(key: "refreshToken") ?? "없음")")
    }
}


