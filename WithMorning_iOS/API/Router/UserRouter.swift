//
//  UserRouter.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/5/24.
//

import Alamofire

private let BaseURL = "https://withmorning.site/api"

enum UserRouter : URLRequestConvertible{
    
    case postSMSrequest(data : SMSnumRequest) //휴대폰 번호 인증
    case postSMSresponsse(data : SMScodeResquest) //번호 + 코드 인증
    case RegisterProfile(data : profileRequest) //닉네임 + 이미지 + FCM토큰
    
    case deletelogout(refreshToken: deletelogoutRequest) //로그아웃
    case deleteaccount //회원 탈퇴
    
    // url가르기
    var endPoint: String {
        switch self {
        case .postSMSrequest : return "/user/send-code"
        case .postSMSresponsse : return "/user/verify-code"
        case .RegisterProfile : return "/user/profile"
            
        case .deletelogout: return "/logout"
        case .deleteaccount: return "/account/apple"
        }
    }
    
    //헤더
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders(["accept" : "application/json", "Content-Type" : "application/json"/*, "Authorization":"\(Authorization1)"*/])
        }
    }
    
    //어떤 방식(get, post, delete, update)
    var method: HTTPMethod {
        switch self {
        case .postSMSrequest, .postSMSresponsse, .RegisterProfile: return .post
        case .deletelogout, .deleteaccount: return .delete
        }
        
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
        case .postSMSrequest(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .postSMSresponsse(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .RegisterProfile(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
            
        case .deletelogout(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .deleteaccount:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        }
        
        
        //request = try URLEncoding.queryString.encode(request, with: parameters)
        //이 인코딩 방식은 GET 요청 또는 URL 쿼리 매개변수를 전송할 때 사용
        
        //request = try JSONParameterEncoder().encode(data, into: request)
        //이 인코딩 방식은 주로 POST 요청에서 사용되며, HTTP 요청 바디에 JSON 데이터를 넣어 전송할 때 사용
        return request
    }
}



