//
//  Network.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

class Network{
    
    static let shared = Network()
    
    //MARK: - 마이페이지
    func getMypage(completionHandler: @escaping (Result<MypageResponse, Error>) -> Void) {
                AF.request(Router.getmypage)
//        AF.request(Router.getmypage, interceptor: AuthInterceptor()) //소셜로그인
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Mypage.self) { (response: DataResponse<Mypage, AFError>) in
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
                                        self.getMypage(completionHandler: completionHandler)
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
                    print(#fileID, #function, #line, "- ⭐️메인페이지 조회 성공")
                    // 성공 시, 데이터 처리
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    
    // MARK: - 메인페이지
    func getMainpage(completionHandler: @escaping (Result<MainpageResponse, Error>) -> Void) {
        AF.request(Router.getmainpage)
//        AF.request(Router.getmainpage, interceptor: AuthInterceptor()) // 소셜로그인
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Mainpage.self) { (response: DataResponse<Mainpage, AFError>) in
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
                                        self.getMainpage(completionHandler: completionHandler)
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
                    print(#fileID, #function, #line, "- ⭐️메인페이지 조회 성공")
                    // 성공 시, 데이터 처리
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    //MARK: - 알람(그룹)생성
    func postGroup(data: MakeGroupMaindata,completionHandler: @escaping (Result<MakegroupResponse, Error>) -> Void){
        AF.request(Router.postgroup(data : data))
//        AF.request(Router.postgroup(data : data), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Makegroup.self){(response: DataResponse<Makegroup, AFError>) in
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
//                                        self.getMainpage(completionHandler: completionHandler)
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
                    print(#fileID, #function, #line, "- ⭐️메인페이지 조회 성공")
                    // 성공 시, 데이터 처리
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
        
    }
    
    
}
