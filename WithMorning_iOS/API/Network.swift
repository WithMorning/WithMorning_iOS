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
        //        AF.request(Router.getmypage, interceptor: CommonLoginManage()) 소셜로그인
        AF.request(Router.getmypage)
            .validate(statusCode: 200..<1001)
            .responseDecodable(of: Mypage.self) { (response: DataResponse<Mypage, AFError>) in
                switch response.result {
                case .failure(let error):
                    print("마이페이지 오류")
                    completionHandler(.failure(error))
                case .success(let data):
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    
    //MARK: - 메인페이지
    func getMainpage(completionHandler: @escaping (Result<MainpageResponse, Error>) -> Void) {
        //        AF.request(Router.getmypage, interceptor: CommonLoginManage()) 소셜로그인
        AF.request(Router.getmypage)
            .validate(statusCode: 200..<1001)
            .responseDecodable(of: Mainpage.self) { (response: DataResponse<Mainpage, AFError>) in
                switch response.result {
                case .failure(let error):
                    print("메인페이지 오류")
                    completionHandler(.failure(error))
                case .success(let data):
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
}
