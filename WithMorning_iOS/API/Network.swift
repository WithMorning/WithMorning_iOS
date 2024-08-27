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
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️마이페이지 조회 성공")
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    
    //MARK: - 메인페이지
    func getMainpage(completionHandler: @escaping (Result<MainpageResponse, Error>) -> Void) {
        AF.request(Router.getmainpage)
        //        AF.request(Router.getmainpage, interceptor: AuthInterceptor()) //소셜로그인
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Mainpage.self) { (response: DataResponse<Mainpage, AFError>) in
                switch response.result {
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                case .success(let data):
                    print(#fileID, #function, #line, "- ⭐️메인페이지 조회 성공")
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    
}
