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
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                case .success(let data):
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
    
    //MARK: - 메인페이지
    func getMainpage(completionHandler: @escaping (Result<MainpageResponse, Error>) -> Void) {
        AF.request(Router.getmainpage)
            .validate(statusCode: 200..<1001)
            .responseDecodable(of: Mainpage.self) { (response: DataResponse<Mainpage, AFError>) in
                switch response.result {
                case .failure(let error):
                    print(#fileID, #function, #line, "- error: \(error.localizedDescription)")
                case .success(let data):
                    if let result = data.result {
                        completionHandler(.success(result))
                    }
                }
            }
    }
}

//func getMainpage(completionHandler: @escaping (Result<MainpageResponse, Error>) -> Void) {
//    AF.request(Router.getmainpage)
//        .validate(statusCode: 200..<1001)
//        .responseDecodable(of: MainpageResponse.self) { response in
//            switch response.result {
//            case .success(let mainpage):
//                completionHandler(.success(mainpage))
//            case .failure(let error):
//                if let data = response.data,
//                   let str = String(data: data, encoding: .utf8) {
//                    print("Raw response: \(str)")
//                }
//
//                if let decodingError = error.underlyingError as? DecodingError {
//                    switch decodingError {
//                    case .dataCorrupted(let context):
//                        print("Data corrupted: \(context)")
//                    case .keyNotFound(let key, let context):
//                        print("Key '\(key)' not found: \(context.debugDescription)")
//                    case .typeMismatch(let type, let context):
//                        print("Type '\(type)' mismatch: \(context.debugDescription)")
//                    case .valueNotFound(let type, let context):
//                        print("Value of type '\(type)' not found: \(context.debugDescription)")
//                    @unknown default:
//                        print("Unknown decoding error")
//                    }
//                }
//                print("Decoding error: \(error)")
//                completionHandler(.failure(error))
//            }
//        }
//}
