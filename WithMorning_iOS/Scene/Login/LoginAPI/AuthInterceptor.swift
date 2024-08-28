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
        guard let accessToken = (KeyChain.read(key:"accessToken")) else {
            print("⚠️ adapt - KeyChain에서 엑세스 토큰을 찾을 수 없습니다")
            return
        }
        
        print("🔑 adapt - 요청에 엑세스 토큰 추가: \(accessToken)")
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
}

class NewAccessToken {
    
    static let shared = NewAccessToken()
    
    // MARK: - 새 엑세스 토큰 발급
    func newAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeyChain.read(key: "refreshToken") else {
            print("⚠️ 새 엑세스 토큰 발급 실패 - 리프레시 토큰이 없습니다")
            completion(false)
            return
        }
        
        AF.request(LoginRouter.getNewAccessToken(refreshToken: refreshToken), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: getToken.self) { (response: DataResponse<getToken, AFError>) in
                switch response.result {
                case .failure(let error):
                    print("❌ 새 엑세스 토큰 발급 실패 - \(error.localizedDescription)")
                    
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print("❌ 새 엑세스 토큰 발급 실패 - 응답 JSON 데이터: \(String(describing: json))")
                            
                        } catch {
                            print("❌ 응답 JSON 데이터 파싱 실패: \(error.localizedDescription)")
                        }
                    }
                    completion(false)
                    
                case .success(let data):
                    do {
                        let decodedResponse = data
                        let tokens = decodedResponse.result
                        let newAccessToken = tokens?.accessToken
                        
                        if let newAccessToken = newAccessToken {
                            print("✅ 새 엑세스 토큰 수신: \(newAccessToken)")
                            KeyChain.create(key: "accessToken", token: newAccessToken)
                            completion(true)
                        } else {
                            print("⚠️ 새 엑세스 토큰 발급 실패 - 응답에 토큰이 없습니다")
                            completion(false)
                        }
                    }
                }
            }
    }
    
}






