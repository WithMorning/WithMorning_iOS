//
//  Router.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/10/24.
//

import Foundation
import Alamofire

private let BaseURL = "https://withmorning.site/api"

let Authorization =  "Bearer " +
"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2IiwiaWF0IjoxNzI3MTUzODQzLCJleHAiOjE3Mjc3NTg2NDN9.orFXuQCBz3e3SaTSqXB9fDMXvh0C0QOWsCAxuDvpFwA"

enum Router : URLRequestConvertible{
    
    case getmypage //마이페이지
    case getmainpage //메인페이지
    case postgroup(data : MakeGroupMaindata) //그룹 생성
    case deletegroup(groupId : Int) //그룹 삭제
    case deleteleavegroup(groupId : Int) // 그룹 나가기
    case joingroup(data : JoingroupMaindata) //그룹 참여
    case postbedtime(data : BedtimeMaindata) //자는 시간
    case patchdisturb(groupId: Int, data: DisturbMaindata) //방해금지모드
    case postprick(userId : prickRequest) //콕찌르기
    case patchwakeup(groupId : Int) //기상 상태로 변경
    case patcheditgroup(groupId : Int)
    
    
    
    // url가르기
    var endPoint: String {
        switch self {
        case .getmypage: return "/user/mypage"
        case .getmainpage: return "/home"
        case .postgroup: return "/groups"
        case .deletegroup(let groupId): return "/groups/\(groupId)"
        case .joingroup: return "/groups/join"
        case .postbedtime: return "/user/bedtime/alarm"
        case .patchdisturb(let groupId, _): return "/user/\(groupId)/disturb"
        case .postprick: return "/user/prick"
        case .patchwakeup(let groupId): return "/user/\(groupId)/wake-status"
        case .deleteleavegroup(let groupId): return "/groups/\(groupId)/leave"
        case .patcheditgroup(let groupId): return "/groups/\(groupId)"
        }
    }
    
    //헤더
    var headers: HTTPHeaders {
        switch self {
        case .patchdisturb(let groupId, _) : return HTTPHeaders(["accept":"application/json","Content-Type" : "application/json" ,"groupId":"\(groupId)","Authorization":"\(Authorization)"])
            
        default: return HTTPHeaders(["accept":"application/json","Content-Type" : "application/json" ,"Authorization":"\(Authorization)"])
        }
    }
    
    
    //어떤 방식(get, post, delete, update, patch)
    var method: HTTPMethod {
        switch self {
        case .getmypage, .getmainpage: return .get
        case .postgroup, .joingroup, .postbedtime, .postprick: return .post
        case .deletegroup, .deleteleavegroup: return .delete
        case .patchdisturb,.patchwakeup,.patcheditgroup : return .patch
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
        case .deletegroup:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        case .joingroup(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .postbedtime(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .patchdisturb(_, let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .postprick(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .patchwakeup(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        case .deleteleavegroup:
            request = try URLEncoding.queryString.encode(request, with: parameters)
        case .patcheditgroup(let data):
            request = try JSONParameterEncoder().encode(data, into: request)
        }
        
        //request = try URLEncoding.queryString.encode(request, with: parameters)
        //이 인코딩 방식은 GET 요청 또는 URL 쿼리 매개변수를 전송할 때 사용
        
        //request = try JSONParameterEncoder().encode(data, into: request)
        //이 인코딩 방식은 주로 POST 요청에서 사용되며, HTTP 요청 바디에 JSON 데이터를 넣어 전송할 때 사용
        
        return request
    }
}


