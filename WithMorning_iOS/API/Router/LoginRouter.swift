//
//  LoginRouter.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/16/24.
//

import Foundation
import Alamofire

private let BaseURL = "https://withmorning.site/api"


enum LoginRouter : URLRequestConvertible{
    case AppleLogin(data : AppleloginRequest)
    case getNewAccessToken(refreshToken: String)
    
    // url가르기
    var endPoint: String {
        switch self {
        case .AppleLogin : return "/login/oauth/apple"
        case .getNewAccessToken: return "/accesstoken"
        }
    }
    
    //헤더
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders(["accept" : "application/json", "Content-Type" : "application/json"])
        }
    }
    
    //어떤 방식(get, post, delete, update)
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters {
        return Parameters()
    }
    
    
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
        case .AppleLogin(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .getNewAccessToken(let refreshToken):
            request = try JSONParameterEncoder().encode(refreshToken, into: request)
        }
        
        //request = try URLEncoding.queryString.encode(request, with: parameters)
        //이 인코딩 방식은 GET 요청 또는 URL 쿼리 매개변수를 전송할 때 사용
        
        //request = try JSONParameterEncoder().encode(data, into: request)
        //이 인코딩 방식은 주로 POST 요청에서 사용되며, HTTP 요청 바디에 JSON 데이터를 넣어 전송할 때 사용
        return request
    }
}


