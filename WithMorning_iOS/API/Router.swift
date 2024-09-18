//
//  Router.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

private let BaseURL = "https://withmorning.site"

let Authorization =  "Bearer " +
"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNzI2NjM0NTYxLCJleHAiOjE3MjcyMzkzNjF9.GpZ2ZBcLoDs4CBkRTHbzvPJ9tnsarE7FcyfFbTNoF80"

enum Router : URLRequestConvertible{
    
    case getmypage
    case getmainpage
    case postgroup(data : MakeGroupMaindata)
    case deletegrop(groupId : Int)
    case joingroup(data : JoingroupMaindata)
    case postbedtime(data : BedtimeMaindata)
    case patchdisturb(data : DisturbMaindata)
    
    
    // url가르기
    var endPoint: String {
        switch self {
        case .getmypage: return "/user/mypage"
        case .getmainpage: return "/home"
        case .postgroup: return "/groups"
        case .deletegrop(let groupId): return "/groups/\(groupId)"
        case .joingroup: return "/groups/join"
        case .postbedtime: return "/user/bedtime/alarm"
        case .patchdisturb(let groupId) : return "/groups/\(groupId)/disturb"
        }
    }
    
    //헤더
    var headers: HTTPHeaders {
        switch self {
        case .patchdisturb(let groupId) : return HTTPHeaders(["accept":"application/json","Content-Type" : "application/json" ,"groupId":"\(groupId)","Authorization":"\(Authorization)"])
            
//            case .patchdisturb(let groupId) : return HTTPHeaders(["accept":"application/json","Content-Type" : "application/json" ,"groupId":"\(groupId)"])
            
        default: return HTTPHeaders(["accept":"application/json","Content-Type" : "application/json" ,"Authorization":"\(Authorization)"])
            //        default: return HTTPHeaders(["accept":"application/json", "Content-Type" : "application/json"])
        }
    }
    
    
    //어떤 방식(get, post, delete, update, patch)
    var method: HTTPMethod {
        switch self {
        case .getmypage, .getmainpage: return .get
        case .postgroup, .joingroup, .postbedtime: return .post
        case .deletegrop: return .delete
        case .patchdisturb : return .patch
            
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
        case .getmypage:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        case .getmainpage:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        case .postgroup(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .deletegrop:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        case .joingroup(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .postbedtime(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .patchdisturb:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        }
        
        //request = try URLEncoding.queryString.encode(request, with: parameters)
        //이 인코딩 방식은 GET 요청 또는 URL 쿼리 매개변수를 전송할 때 사용
        
        //request = try JSONParameterEncoder().encode(data, into: request)
        //이 인코딩 방식은 주로 POST 요청에서 사용되며, HTTP 요청 바디에 JSON 데이터를 넣어 전송할 때 사용
        
        return request
    }
}


