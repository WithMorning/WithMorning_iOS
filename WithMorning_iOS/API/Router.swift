//
//  Router.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

//let Accesstoken = "Bearer" + "  eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJpZCI6MSwiZW1haWwiOiJoeXVuMTIzQG5hdmVyLmNvbSIsInN1YiI6Imh5dW4xMjNAbmF2ZXIuY29tIiwiaWF0IjoxNzA3MjE0NzYzLCJleHAiOjE3MDcyMjE5NjN9.vG0GDgQSJv9znIH9zE7ElwhpSiyeWnk6oEVy3AlBduw" //수정


private let BaseURL = "https://withmorning.site"

let userId = 1


enum Router : URLRequestConvertible{
    
    case getmypage                                      //모다라트 리스트 조회
    case getmainpage
    
    // url가르기
    var endPoint: String {
        switch self {
        case .getmypage: return "/mypage"
        case .getmainpage: return "/main"
        }
    }
    
    //헤더
    var headers: HTTPHeaders {
        switch self {
            //        default: return HTTPHeaders(["accept":"application/json", "Authorization" : Accesstoken])
        default: return HTTPHeaders(["accept":"application/json", "userId" : "\(userId)"]) //"인증아이디" : "인증코드"
        }
    }
    
    
    //어떤 방식(get, post, delete, update)
    var method: HTTPMethod {
        switch self {
        case .getmypage: return .get
        case .getmainpage: return .get
            
        }
    }
    
    var parameters: Parameters {
        return Parameters()
    }
    
    //    func asURLRequest() throws -> URLRequest {
    //        var url = BaseURL.appending(endPoint)
    //        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    //        let urlString = URL(string: url)!
    //
    //        var request = URLRequest(url: urlString)
    //        request.method = method
    //        request.headers = headers
    
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: BaseURL) else {
            throw AFError.invalidURL(url: BaseURL)
        }
        urlComponents.path += endPoint
        
        guard let url = urlComponents.url else {
            throw AFError.invalidURL(url: urlComponents.string ?? "")
        }
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .getmypage: request = try URLEncoding.queryString.encode(request, with: parameters)
            
        case .getmainpage: request = try URLEncoding.queryString.encode(request, with: parameters)
        }
        //request = try URLEncoding.queryString.encode(request, with: parameters)
        //이 인코딩 방식은 GET 요청 또는 URL 쿼리 매개변수를 전송할 때 사용
        
        //request = try JSONParameterEncoder().encode(data, into: request)
        //이 인코딩 방식은 주로 POST 요청에서 사용되며, HTTP 요청 바디에 JSON 데이터를 넣어 전송할 때 사용
        return request
    }
}


