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
    
    //MARK: - 프로필 등록
//    func postProfile(profileData: profileRequest, completionHandler: @escaping (Result<profileResponse, Error>) -> Void) {
//        let url = "https://withmorning.site/api/user/profile"
//        
//        let headers: HTTPHeaders = [
//            "Accept": "application/json, application/javascript, text/javascript, text/json",
//            "Content-Type": "multipart/form-data",
//            "Authorization": Authorization1
//        ]
//        
//        // 멀티파트 데이터 업로드
//        AF.upload(
//            multipartFormData: { multipartFormData in
//                // JSON 포맷으로 닉네임과 FCM 토큰 준비
//                let requestProfileDict: [String: String] = [
//                    "nickname": profileData.request.nickname,
//                    "fcmToken": profileData.request.fcmToken
//                ]
//                
//                // JSON 데이터 인코딩
//                if let jsonData = try? JSONSerialization.data(withJSONObject: requestProfileDict, options: []) {
//                    multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
//                }
//
//                // 이미지 파일 데이터 전송 (profile_image라는 키로 추가)
//                multipartFormData.append(profileData.imageData, withName: "profile_image", fileName: "profile.jpg", mimeType: "image/jpeg")
//            },
//            to: url,
//            method: .post,
//            headers: headers
//        )
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: profileResponse.self) { response in
//            switch response.result {
//            case .success(let data):
//                print("프로필 업로드 성공: \(data)")
//                completionHandler(.success(data))
//                
//            case .failure(let error):
//                if let data = response.data, let statusCode = response.response?.statusCode {
//                    print("응답 상태 코드: \(statusCode)")
//                    do {
//                        // 실패 시 JSON 데이터 파싱
//                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        print("실패 JSON 데이터: \(json ?? [:])")
//                        
//                        // 'code'가 9104일 경우 토큰 갱신 시도
//                        if let errorCode = json?["code"] as? Int, errorCode == 9104 {
//                            print("엑세스 토큰 만료. 갱신 시도 중...")
//                            NewAccessToken.shared.newAccessToken { success in
//                                if success {
//                                    // 토큰 갱신 성공 시, 다시 요청
//                                    self.postProfile(profileData: profileData, completionHandler: completionHandler)
//                                } else {
//                                    // 토큰 갱신 실패 시 에러 처리
//                                    completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
//                                }
//                            }
//                            return
//                        }
//                    } catch {
//                        print("JSON 파싱 실패: \(error.localizedDescription)")
//                    }
//                }
//                print("프로필 업로드 실패: \(error.localizedDescription)")
//                completionHandler(.failure(error))
//            }
//        }
//    }
    func postProfile(profileData: profileRequest, completionHandler: @escaping (Result<profileResponse, Error>) -> Void) {
        
        let url = "https://withmorning.site/api/user/profile"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json, application/javascript, text/javascript, text/json",
            "Content-Type": "multipart/form-data",
            "Authorization": Authorization1,
            "Cache-Control": "no-cache, no-store, must-revalidate" // 캐시 방지
        ]
        
        // 현재 시간을 파일 이름에 추가하여 고유성 보장
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let timestamp = dateFormatter.string(from: Date())
        let fileName = "profile_\(timestamp).jpg"
        
        AF.upload(
            multipartFormData: { multipartFormData in
                let requestProfileDict: [String: String] = [
                    "nickname": profileData.request.nickname,
                    "fcmToken": profileData.request.fcmToken
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: requestProfileDict, options: []) {
                    multipartFormData.append(jsonData, withName: "request", mimeType: "application/json")
                    print("Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
                }
                
                // 이미지 파일 데이터 전송 (고유한 파일 이름 사용)
                multipartFormData.append(profileData.imageData, withName: "profile_image", fileName: fileName, mimeType: "image/jpeg")
                
                print("Image file name: \(fileName)")
                print("Image data size: \(profileData.imageData.count) bytes")
            },
            to: url,
            method: .post,
            headers: headers
        )
        .uploadProgress { progress in
            print("Upload progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            switch response.result {
            case .success(let data):
                if let httpResponse = response.response {
                    print("Response status code: \(httpResponse.statusCode)")
                }
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "")")
                
                do {
                    let decodedResponse = try JSONDecoder().decode(profileResponse.self, from: data)
                    print("프로필 업로드 성공: \(decodedResponse)")
                    
//                    // 이미지 URL이 응답에 포함되어 있다면 출력
//                    if let imageUrl = decodedResponse.imageUrl {
//                        print("Updated image URL: \(imageUrl)")
//                    } else {
//                        print("Warning: Image URL not found in the response")
//                    }
                    
                    completionHandler(.success(decodedResponse))
                } catch {
                    print("Decoding error: \(error)")
                    completionHandler(.failure(error))
                }
                
            case .failure(let error):
                print("프로필 업로드 실패: \(error.localizedDescription)")
                if let data = response.data {
                    print("Error response data: \(String(data: data, encoding: .utf8) ?? "")")
                }
                completionHandler(.failure(error))
            }
        }
    }
}








