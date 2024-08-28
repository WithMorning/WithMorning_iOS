//
//  NetWorkError.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/28/24.
//

import Foundation

enum APIError: Int, Error {
    case success = 200
    case internalServerError = 500
    
    // Group related errors (1000~)
    case invalidRequest = 1000
    case notFoundGroupId = 1001
    case notFoundUserId = 1010
    case duplicatedMemberNickname = 1013
    
    // Image related errors (5000~)
    case exceedImageCapacity = 5001
    case nullImage = 5002
    case emptyImageList = 5003
    case exceedImageListSize = 5004
    case invalidImageUrl = 5005
    case invalidImagePath = 5101
    case invalidImage = 5102
    
    // User related errors (8000~)
    case invalidUser = 8001
    case invalidPassword = 8002
    case nullAdminAuthority = 8101
    case duplicatedAdminUsername = 8102
    case notFoundAdminId = 8103
    case invalidCurrentPassword = 8104
    case invalidAdminAuthority = 8201
    
    // Login related errors (9000~)
    case invalidAuthorizationCode = 9001
    case notSupportedOAuthService = 9002
    case failToConvertUrlParameter = 9003
    case invalidRefreshToken = 9101
    case invalidAccessToken = 9102
    case expiredPeriodRefreshToken = 9103
    case expiredPeriodAccessToken = 9104
    case failToValidateToken = 9105
    case notFoundRefreshToken = 9106
    case invalidAuthority = 9201
    
    var isSuccess: Bool {
        return self == .success
    }
    
    var errorMessage: String {
        switch self {
        case .success:
            return "요청에 성공하였습니다."
        case .internalServerError:
            return "서버 에러가 발생하였습니다. 관리자에게 문의해 주세요."
        case .invalidRequest:
            return "올바르지 않은 요청입니다."
        case .notFoundGroupId:
            return "요청한 ID에 해당하는 그룹이 존재하지 않습니다."
        case .notFoundUserId:
            return "요청한 ID에 해당하는 유저가 존재하지 않습니다."
        case .duplicatedMemberNickname:
            return "중복된 닉네임입니다."
        case .exceedImageCapacity:
            return "업로드 가능한 이미지 용량을 초과했습니다."
        case .nullImage:
            return "업로드한 이미지 파일이 NULL입니다."
        case .emptyImageList:
            return "최소 한 장 이상의 이미지를 업로드해야합니다."
        case .exceedImageListSize:
            return "업로드 가능한 이미지 개수를 초과했습니다."
        case .invalidImageUrl:
            return "요청한 이미지 URL의 형식이 잘못되었습니다."
        case .invalidImagePath:
            return "이미지를 저장할 경로가 올바르지 않습니다."
        case .invalidImage:
            return "올바르지 않은 이미지 파일입니다."
        case .invalidUser:
            return "존재하지 않는 사용자입니다."
        case .invalidPassword:
            return "비밀번호가 일치하지 않습니다."
        case .nullAdminAuthority:
            return "잘못된 관리자 권한입니다."
        case .duplicatedAdminUsername:
            return "중복된 사용자 이름입니다."
        case .notFoundAdminId:
            return "요청한 ID에 해당하는 관리자를 찾을 수 없습니다."
        case .invalidCurrentPassword:
            return "현재 사용중인 비밀번호가 일치하지 않습니다."
        case .invalidAdminAuthority:
            return "해당 관리자 기능에 대한 접근 권한이 없습니다."
        case .invalidAuthorizationCode:
            return "유효하지 않은 인증 코드입니다."
        case .notSupportedOAuthService:
            return "해당 OAuth 서비스는 제공하지 않습니다."
        case .failToConvertUrlParameter:
            return "Url Parameter 변환 중 오류가 발생했습니다."
        case .invalidRefreshToken:
            return "올바르지 않은 형식의 RefreshToken입니다."
        case .invalidAccessToken:
            return "올바르지 않은 형식의 AccessToken입니다."
        case .expiredPeriodRefreshToken:
            return "기한이 만료된 RefreshToken입니다."
        case .expiredPeriodAccessToken:
            return "기한이 만료된 AccessToken입니다."
        case .failToValidateToken:
            return "토큰 유효성 검사 중 오류가 발생했습니다."
        case .notFoundRefreshToken:
            return "RefreshToken이 null이거나 빈 문자열입니다."
        case .invalidAuthority:
            return "해당 요청에 대한 접근 권한이 없습니다."
        }
    }
}
