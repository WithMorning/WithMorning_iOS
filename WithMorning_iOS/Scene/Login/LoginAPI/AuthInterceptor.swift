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
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        guard let accessToken = (KeyChain.read(key: "accessToken")) else {return}
        //Bearer 추가해야하나 안하나 모르나 ㅋㅋ
        urlRequest.headers.add(.authorization(bearerToken: "Bearer " + accessToken))
        completion(.success(urlRequest))
    }
    
    //MARK: - accessToken이 만료되었을때 refreshToken 통해 accessToken재발급
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let refreshToken = KeyChain.read(key: "refreshToken") else { return }
        
        print(#fileID, #function, #line, "- refreshToken check: \(refreshToken)")
        
        guard let response = request.task?.response as? HTTPURLResponse else { return }
        print("code : ",response.statusCode)
        
        // adapt를해서 돌아올때 statusCode가 9104일 경우 -> accessToken만료된 것(재발급)
        if response.statusCode == 9104 {
            print("엑세스토큰 만료 !")
            AF.request(LoginRouter.getNewAccessToken(refreshToken: refreshToken))
                .validate(statusCode: 200..<300)
                .responseDecodable(of: getTokenResponse.self) { (response: DataResponse<getTokenResponse, AFError> ) in
                    switch response.result {
                    case .failure(let error):
                        completion(.doNotRetry)
                        print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                        
                    case .success(let data):
                        guard let tokens = data.result else{return}
                        
                        KeyChain.create(key: "accessToken", token: tokens.accessToken ?? "")
                        KeyChain.create(key: "refreshToken", token: tokens.refreshToken ?? "")
                        
                        completion(.retry)
                    }
                }
            
            print("🔥KeyChain에 재발급 받고 저장된 accessToken : ", KeyChain.read(key: "accessToken") ?? "")
            print("🔥KeyChain에 재발급 받고 저장된 refreshToken : ",KeyChain.read(key: "refreshToken") ?? "")
        }
        print("🔥KeyChain에 재발급 안받고 그냥 그대로 있는 accessToken : ", KeyChain.read(key: "accessToken") ?? "")
        print("🔥KeyChain에 재발급 안받고 그냥 그대로 있는 refreshToken : ",KeyChain.read(key: "refreshToken") ?? "")
    }
}

