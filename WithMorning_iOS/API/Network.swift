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
    
    func getMypage(completionHandler: @escaping (Result<Mypage, Error>) -> Void) {
        //        AF.request(Router.getmypage, interceptor: CommonLoginManage()) 소셜로그인
        AF.request(Router.getmypage)
            .validate(statusCode: 200..<1001)
            .responseDecodable(of: Mypage.self) { (response: DataResponse<Mypage, AFError>) in
                
                switch response.result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let data):
                    completionHandler(.success(data))
                }
            }
        
    }
}
