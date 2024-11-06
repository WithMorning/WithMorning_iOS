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
        AF.request(Router.getmypage, interceptor: AuthInterceptor()) //소셜로그인
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Mypage.self) { (response: DataResponse<Mypage, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.getMypage(completionHandler: completionHandler)
                    }, completion: completionHandler)
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
        //        AF.request(Router.getmainpage)
        AF.request(Router.getmainpage, interceptor: AuthInterceptor()) // 소셜로그인
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Mainpage.self) { (response: DataResponse<Mainpage, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.getMainpage(completionHandler: completionHandler)
                    }, completion: completionHandler)
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
        //        AF.request(Router.postgroup(data : groupdata))
        AF.request(Router.postgroup(data : groupdata), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Makegroup.self){(response: DataResponse<Makegroup, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.postGroup(groupdata: groupdata, completionHandler: completionHandler)
                    }, completion: completionHandler)
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
    func deleteGroup(groupId : Int, completionHandler: @escaping (Result<Deletegroup, Error>) -> Void){
        AF.request(Router.deletegroup(groupId: groupId), interceptor: AuthInterceptor())
        //        AF.request(Router.deletegroup(groupId: groupId))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Deletegroup.self){(response: DataResponse<Deletegroup, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.deleteGroup(groupId : groupId, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️알람(그룹)삭제 완료!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                    
                }
                
                
            }
        
    }
    
    //MARK: - 코드로 방 입장
    func joinGroup(joindata : JoingroupMaindata,completionHandler: @escaping (Result<JoingroupResponse, Error>) -> Void){
        AF.request(Router.joingroup(data: joindata), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Joingroup.self){(response: DataResponse<Joingroup, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.joinGroup(joindata: joindata, completionHandler: completionHandler)
                    }, completion: completionHandler)
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
        AF.request(Router.postbedtime(data: bedtimedata), interceptor: AuthInterceptor())
        //        AF.request(Router.postbedtime(data: bedtimedata))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Bedtime.self){(response: DataResponse<Bedtime, AFError>) in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.postBedtime(bedtimedata: bedtimedata, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️취침시간 수정 완료!")
                    // 성공 시, 데이터 처리
                    completionHandler(.success(data))
                }
                
                
            }
    }
    
    //MARK: - 방해금지모드 설정
    func patchDisturb(groupId: Int, DisturbData: DisturbMaindata, completionHandler: @escaping (Result<DisturbResponse, Error>) -> Void) {
        
        AF.request(Router.patchdisturb(groupId: groupId, data: DisturbData), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DisturbResponse.self) { response in
                switch response.result {
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.patchDisturb(groupId: groupId, DisturbData: DisturbData, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    print("⭐️ 방해금지 설정 완료!")
                    completionHandler(.success(data))
                }
            }
    }
    
    //MARK: - 콕찌르기
    func postprick(userId: prickRequest, completionHandler: @escaping (Result<prickResponse, Error>) -> Void){
        
        AF.request(Router.postprick(userId: userId), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: prickResponse.self){ response in
                switch response.result{
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.postprick(userId: userId, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    print("⭐️\(userId)의 아이디를 가진 유저를 콕찔러버림ㅋㅋ")
                    completionHandler(.success(data))
                    
                }
            }
    }
    
    //MARK: - 기상
    func patchWakeup(groupId: Int, completionHandler: @escaping (Result<wakeupResponse, Error>) -> Void){
        
        print("보내는 groupId: \(groupId)")
        AF.request(Router.patchwakeup(groupId: groupId), interceptor: AuthInterceptor())
        
            .validate(statusCode: 200..<300)
            .responseDecodable(of: wakeupResponse.self){ response in
                switch response.result{
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.patchWakeup(groupId: groupId, completionHandler: completionHandler)
                    }, completion: completionHandler)
                   
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️\(groupId)의 방 기상완료맨")
                    completionHandler(.success(data))
                    
                }
            }
    }
    //MARK: - 알람 나가기
    func deleteleaveGroup(groupId: Int, completionHandler: @escaping (Result<leavegroupResponse, Error>) -> Void) {
        
        print("보내는 groupId: \(groupId)")
        AF.request(Router.deleteleavegroup(groupId: groupId), interceptor: AuthInterceptor())
        //        AF.request(Router.deleteleavegroup(groupId: groupId))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: leavegroupResponse.self){response in
                switch response.result{
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.deleteleaveGroup(groupId: groupId, completionHandler: completionHandler)
                    }, completion: completionHandler)
                    
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️\(groupId)의 방나가기 성공")
                    completionHandler(.success(data))
                    
                }
                
            }
        
    }
    
    //MARK: - 그룹 수정
    func patcheditGroup(groupId : Int ,editGroupdata: EditGroupMaindata, completionHandler: @escaping (Result<EditgroupResponse, Error>) -> Void){
        print("보내는 groupId: \(groupId)")
        AF.request(Router.patcheditgroup(groupId: groupId, data: editGroupdata), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: EditgroupResponse.self){response in
                switch response.result{
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.patcheditGroup(groupId: groupId, editGroupdata: editGroupdata, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    completionHandler(.success(data))
                    print(#fileID, #function, #line, "- ⭐️\(groupId)의 방 그룹 수정성공")
                }
                
            }
    }
    //MARK: - 전화번호 공개 수정
    func patchphoneagree(groupId : Int, editphoneagree : EditphoneMaindata, completionHandler: @escaping (Result<EditphoneagreeResponse, Error>) -> Void){
        
        print("보내는 groupId: \(groupId) \(editphoneagree)")
        
        AF.request(Router.patchphoneagree(groupId: groupId, data: editphoneagree), interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: EditphoneagreeResponse.self){response in
                switch response.result{
                case .failure(let error):
                    NetworkErrorHandler.shared.handleNetworkError(error, data: response.data, retryRequest: {
                        self.patchphoneagree(groupId: groupId, editphoneagree : editphoneagree, completionHandler: completionHandler)
                    }, completion: completionHandler)
                case .success(let data):
                    completionHandler(.success(data))
                    print(#fileID, #function, #line, "- ⭐️\(groupId)의 전화번호 공개 수정 성공")
                }
                
            }
    }

    
    
    
    
}

