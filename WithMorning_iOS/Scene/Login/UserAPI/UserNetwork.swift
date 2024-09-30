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
        AF.request(UserRouter.postSMSrequest(data: phoneNumber), interceptor: AuthInterceptor())
        //        AF.request(UserRouter.postSMSrequest(data: phoneNumber))
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
        AF.request(UserRouter.postSMSresponsse(data: responsedata), interceptor: AuthInterceptor())
        //        AF.request(UserRouter.postSMSresponsse(data: responsedata))
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
    
    //MARK: - 프로필 등록
    func postProfile(profileData: profileRequest, completionHandler: @escaping (Result<profileResponse, Error>) -> Void) {
        let url = "https://withmorning.site/api/user/profile"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // JSON 데이터 추가
                do {
                    let jsonData = try JSONEncoder().encode(profileData.request)
                    multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
                } catch {
                    print("프로필 데이터 인코딩 실패")
                    completionHandler(.failure(error))
                    return
                }
                
                // 이미지 데이터 추가
                if let imageData = profileData.image {
                    multipartFormData.append(imageData, withName: "image", fileName: "profile_image.jpg", mimeType: "image/jpeg")
                }
            },
            to: url,
            method: .post,
            headers: headers,
            interceptor: AuthInterceptor()
        )
        
        .validate(statusCode: 200..<300)
        .responseDecodable(of: profileResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("프로필 업로드 성공: \(data)")
                completionHandler(.success(data))
                
            case .failure(let error):
                print("프로필 업로드 실패: \(error.localizedDescription)")
                if let data = response.data, let statusCode = response.response?.statusCode {
                    print("응답 상태 코드: \(statusCode)")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("실패 JSON 데이터: \(json ?? [:])")
                        
                        if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                            print("엑세스 토큰 만료. 갱신 시도 중...")
                            NewAccessToken.shared.newAccessToken { success in
                                if success {
                                    self.postProfile(profileData: profileData, completionHandler: completionHandler)
                                } else {
                                    completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                }
                            }
                            return
                        }
                    } catch {
                        print("JSON 파싱 실패: \(error.localizedDescription)")
                    }
                }
                completionHandler(.failure(error))
            }
        }
    }
    //MARK: - 로그아웃
    func deletelogout(refreshToken : deletelogoutRequest, completionHandler: @escaping (Result<deletelogoutResponse, Error>) -> Void){
        AF.request(UserRouter.deletelogout(refreshToken: refreshToken), interceptor: AuthInterceptor())
        //        AF.request(UserRouter.deletelogout(refreshToken: refreshToken))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: deletelogoutResponse.self) {(response: DataResponse<deletelogoutResponse, AFError>) in
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
                                        self.deletelogout(refreshToken: refreshToken, completionHandler: completionHandler)
                                        
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
                    print(#fileID, #function, #line, "- ⭐️로그아웃 성공 ㅠㅜ⭐️!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                    
                }
            }
        
    }
    //MARK: - 회원 탈퇴
    func deleteaccount(completionHandler: @escaping (Result<deleteaccountResponse, Error>) -> Void) {
        AF.request(UserRouter.deleteaccount, interceptor: AuthInterceptor())
        //        AF.request(UserRouter.deleteaccount)
            .validate(statusCode: 200..<300).responseDecodable(of: deleteaccountResponse.self)  {(response: DataResponse<deleteaccountResponse, AFError>) in
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
                                        self.deleteaccount(completionHandler: completionHandler)
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
                    print(#fileID, #function, #line, "- ⭐️회원탈퇴 성공 ㅠㅜ⭐️!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                    
                }
            }
    }
    
}













