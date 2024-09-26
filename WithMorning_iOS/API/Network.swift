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
                                        // 새 엑세스 토큰 발급 성공 시, API 재호출
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
                    print(#fileID, #function, #line, "- ⭐️마이페이지 조회 성공")
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
                                        // 새 엑세스 토큰 발급 성공 시,API 재호출
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
    func postGroup(groupdata: MakeGroupMaindata,completionHandler: @escaping (Result<MakegroupResponse, Error>) -> Void){
        AF.request(Router.postgroup(data : groupdata))
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
                                        // 새 엑세스 토큰 발급 성공 시,API 재호출
                                        self.postGroup(groupdata: groupdata, completionHandler: completionHandler)
                                        
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
                    print(#fileID, #function, #line, "- ⭐️알람(그룹)생성 완료!")
                    // 성공 시, 데이터 처리
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                    
                }
            }
        
    }
    
    //MARK: - 알람(그룹)삭제
    func deleteGroup(groupId : Int,completionHandler: @escaping (Result<Deletegroup, Error>) -> Void){
        //        AF.request(Router.deletegrop(groupId: groupId), interceptor: AuthInterceptor())
        AF.request(Router.deletegrop(groupId: groupId))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Deletegroup.self){(response: DataResponse<Deletegroup, AFError>) in
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
                                        // 새 엑세스 토큰 발급 성공 시,API 재호출
                                        self.deleteGroup(groupId: groupId, completionHandler: completionHandler)
                                        
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
                    print(#fileID, #function, #line, "- ⭐️알람(그룹)삭제 완료!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                    
                }
                
                
            }
        
    }
    
    //MARK: - 코드로 방 입장
    func joinGroup(joindata : JoingroupMaindata,completionHandler: @escaping (Result<JoingroupResponse, Error>) -> Void){
        //        AF.request(Router.joingroup(data: data), interceptor: AuthInterceptor())
        AF.request(Router.joingroup(data: joindata))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Joingroup.self){(response: DataResponse<Joingroup, AFError>) in
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
                                        // 새 엑세스 토큰 발급 성공 시, API 재호출
                                        self.joinGroup(joindata: joindata, completionHandler: completionHandler)
                                        
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
                    print(#fileID, #function, #line, "- ⭐️알람(그룹)입장 완료!")
                    // 성공 시, 데이터 처리
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                    
                }
            }
    }
    
    //MARK: - 자는 시간 설정
    func postBedtime(bedtimedata : BedtimeMaindata, completionHandler: @escaping (Result<Bedtime, Error>) -> Void ){
        //        AF.request(Router.postbedtime(data: bedtimedata), interceptor: AuthInterceptor())
        AF.request(Router.postbedtime(data: bedtimedata))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Bedtime.self){(response: DataResponse<Bedtime, AFError>) in
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
                                        // 새 엑세스 토큰 발급 성공 시, API 재호출
                                        self.postBedtime(bedtimedata: bedtimedata, completionHandler: completionHandler)
                                        
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
                    print(#fileID, #function, #line, "- ⭐️취침시간 수정 완료!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                }
                
                
            }
    }
    
    //MARK: - 방해금지모드 설정
    func patchDisturb(groupId: Int, DisturbData: DisturbMaindata, completionHandler: @escaping (Result<DisturbResponse, Error>) -> Void) {
        
        print("보내는 groupId: \(groupId)")
        
        //        AF.request(Router.patchdisturb(groupId: groupId, data: DisturbData), interceptor: AuthInterceptor())
        AF.request(Router.patchdisturb(groupId: groupId, data: DisturbData))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DisturbResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("⭐️ 방해금지 설정 완료!")
                    completionHandler(.success(data))
                case .failure:
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print("- 실패 JSON 데이터: \(json ?? [:])")
                            
                            if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                                print("🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                                
                                NewAccessToken.shared.newAccessToken { success in
                                    if success {
                                        // 엑세스 토큰 갱신 후 API 재시도
                                        self.patchDisturb(groupId: groupId, DisturbData: DisturbData, completionHandler: completionHandler)
                                    } else {
                                        completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                    }
                                }
                            } else {
                                completionHandler(.failure(NSError(domain: "ServerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "서버에서 정의되지 않은 오류 발생"])))
                            }
                        } catch {
                            print("- JSON 데이터 파싱 오류: \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    } else {
                        completionHandler(.failure(NSError(domain: "ResponseErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 데이터 없음"])))
                    }
                }
            }
    }
    
    //MARK: - 콕찌르기
    func postprick(userId: prickRequest, completionHandler: @escaping (Result<prickResponse, Error>) -> Void){
        
        print("보내는 userId: \(userId)")
        
        //AF.request(Router.postprick(userId: userId), interceptor: AuthInterceptor())
        AF.request(Router.postprick(userId: userId))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: prickResponse.self){ response in
                switch response.result{
                case .success(let data):
                    print("⭐️\(userId)의 아이디를 가진 유저를 콕찔러버림ㅋㅋ")
                    completionHandler(.success(data))
                case .failure:
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print("- 실패 JSON 데이터: \(json ?? [:])")
                            
                            if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                                print("🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                                
                                NewAccessToken.shared.newAccessToken { success in
                                    if success {
                                        // 엑세스 토큰 갱신 후 API 재시도
                                        self.postprick(userId: userId, completionHandler: completionHandler)
                                    } else {
                                        completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                    }
                                }
                            } else {
                                completionHandler(.failure(NSError(domain: "ServerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "서버에서 정의되지 않은 오류 발생"])))
                            }
                        } catch {
                            print("- JSON 데이터 파싱 오류: \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    } else {
                        completionHandler(.failure(NSError(domain: "ResponseErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 데이터 없음"])))
                    }
                }
            }
    }
    
    
    func patchWakeup(groupId: Int, completionHandler: @escaping (Result<wakeupResponse, Error>) -> Void){
        
        print("보내는 groupId: \(groupId)")
        
        AF.request(Router.patchwakeup(groupId: groupId)).validate(statusCode: 200..<300)
            .responseDecodable(of: wakeupResponse.self){ response in
                switch response.result{
                case .success(let data):
                    completionHandler(.success(data))
                    
                case .failure:
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            print("- 실패 JSON 데이터: \(json ?? [:])")
                            
                            if let errorCode = json?["code"] as? Int, errorCode == 9104 {
                                print("🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                                
                                NewAccessToken.shared.newAccessToken { success in
                                    if success {
                                        // 엑세스 토큰 갱신 후 API 재시도
                                        self.patchWakeup(groupId: groupId,completionHandler:completionHandler)
                                    } else {
                                        completionHandler(.failure(NSError(domain: "NewAccessTokenErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "새 엑세스 토큰 발급 실패"])))
                                    }
                                }
                            } else {
                                completionHandler(.failure(NSError(domain: "ServerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "서버에서 정의되지 않은 오류 발생"])))
                            }
                        } catch {
                            print("- JSON 데이터 파싱 오류: \(error.localizedDescription)")
                            completionHandler(.failure(error))
                        }
                    } else {
                        completionHandler(.failure(NSError(domain: "ResponseErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 데이터 없음"])))
                    }
                }
            }
        
        
        
    }
}
