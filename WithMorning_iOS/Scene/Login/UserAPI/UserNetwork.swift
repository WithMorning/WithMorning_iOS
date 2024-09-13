//
//  UserNetwork.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/5/24.
//

import Foundation
import Alamofire

class UserNetwork{
    
    static let shared = UserNetwork()
    
    //MARK: - 휴대폰 인증요청
    func requestSMS(phoneNumber :SMSnumRequest,completionHandler: @escaping (Result<SMSnumResponse, Error>) -> Void){
        //        AF.request(UserRouter.postSMSrequest(data: phoneNumber), interceptor: AuthInterceptor())
        AF.request(UserRouter.postSMSrequest(data: phoneNumber))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SMSnumResponse.self){(response: DataResponse<SMSnumResponse, AFError>) in
                switch response.result {
                case .failure(_):
                    if let data = response.data {
                        do {
                            // JSON 데이터 파싱
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print(#fileID, #function, #line, "- 실패 JSON 데이터: \(json ?? [:])")
                            
                            // JSON 응답에서 코드 확인
                            if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                                // 새로운 엑세스 토큰 발급
                                print("🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                                NewAccessToken.shared.newAccessToken { success in
                                    if success {
                                        // 새 엑세스 토큰 발급 성공 시, 다시 메인페이지 요청
                                        self.requestSMS(phoneNumber: phoneNumber, completionHandler: completionHandler)
                                        
                                    } else {
                                        // 실패 시, completionHandler 호출
                                        completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                    }
                                }
                            }
                        } catch {
                            print(#fileID, #function, #line, "- JSON 데이터 파싱 실패: \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    }
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️휴대폰 번호 전송!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                }
                
            }
        
    }
    //MARK: - 인증번호
    func responseSMS(responsedata : SMScodeResquest, completionHandler: @escaping (Result<SMScodeResponse, Error>) -> Void){
        //        AF.request(UserRouter.postSMSresponsse(data: phoneNumber), interceptor: AuthInterceptor())
        AF.request(UserRouter.postSMSresponsse(data: responsedata))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SMScodeResponse.self) {(response: DataResponse<SMScodeResponse, AFError>) in
                switch response.result{
                case .failure(_):
                    if let data = response.data {
                        do {
                            // JSON 데이터 파싱
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print(#fileID, #function, #line, "- 실패 JSON 데이터: \(json ?? [:])")
                            
                            // JSON 응답에서 코드 확인
                            if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                                // 새로운 엑세스 토큰 발급
                                print("🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                                NewAccessToken.shared.newAccessToken { success in
                                    if success {
                                        // 새 엑세스 토큰 발급 성공 시, 다시 메인페이지 요청
                                        self.responseSMS(responsedata: responsedata, completionHandler: completionHandler)
                                        
                                    } else {
                                        // 실패 시, completionHandler 호출
                                        completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                    }
                                }
                            }
                        } catch {
                            print(#fileID, #function, #line, "- JSON 데이터 파싱 실패: \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    }
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️인증번호 전송!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                    
                }
            }
        
    }
    
    
    
    
}

