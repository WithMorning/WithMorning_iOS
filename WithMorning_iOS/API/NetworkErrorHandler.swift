//
//  NetworkErrorHandler.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 10/11/24.
//

import Foundation
import Alamofire
import UIKit

//enum NetworkError: LocalizedError {
//    
//    case refreshTokenExpired   // 9103: 리프레시 토큰 만료
//    case accessTokenExpired    // 9104: 액세스 토큰 만료
//    case serverError(code: Int, message: String)  // 5XXX: 서버 에러
//    case unknownError(Error)
//    
//    var errorDescription: String? {
//        switch self {
//        case .refreshTokenExpired:
//            return "리프레시 토큰이 만료되었습니다."
//        case .accessTokenExpired:
//            return "액세스 토큰이 만료되었습니다."
//        case .serverError(_, let message):
//            return "서버 에러: \(message)"
//        case .unknownError(let error):
//            return "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
//        }
//    }
//}
//
//class NetworkErrorHandler {
//    
//    static let shared = NetworkErrorHandler()
//    
//    private init() {}
//    
//    //MARK: - 에러탐지
//    func handleNetworkError<T: Decodable>(_ error: AFError, data: Data?, retryRequest: @escaping () -> Void, completion: @escaping (Result<T, Error>) -> Void) {
//        if let data = data {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                if let errorCode = json?["code"] as? Int {
//                    print(#fileID, #function, #line, "- 실패 JSON 데이터: \(json ?? [:])")
//                    
//                    switch errorCode {
//                        
//                    case 9103: //리프레쉬 토큰 만료
//                        print(#fileID, #function, #line, "-🚨  실패 리프레쉬 토큰 만료. 로그인으로 이동합니다.: \(json ?? [:])")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            self.navigateToLoginViewController()
//                        }
//                        
//                        completion(.failure(NetworkError.refreshTokenExpired))
//                        
//                    case 9104: //엑세스 토큰 만료
//                        print(#fileID, #function, #line,"🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
//                        NewAccessToken.shared.newAccessToken { success in
//                            if success {
//                                retryRequest()
//                            } else {
//                                completion(.failure(NetworkError.accessTokenExpired))
//                            }
//                        }
//                        
//                    case 500:
//                        let message = json?["message"] as? String ?? "알 수 없는 서버 오류"
//                        print(#fileID, #function, #line,"- 실패 JSON 데이터: \(json ?? [:])")
//                        completion(.failure(NetworkError.serverError(code: errorCode, message: message)))
//                    default:
//                        completion(.failure(NetworkError.unknownError(error)))
//                    }
//                } else {
//                    completion(.failure(NetworkError.unknownError(error)))
//                }
//            } catch {
//                completion(.failure(NetworkError.unknownError(error)))
//            }
//        } else {
//            completion(.failure(NetworkError.unknownError(error)))
//        }
//    }
//    
//    //MARK: - refreshToken만료시 로그인 페이지로 이동
//    private func navigateToLoginViewController() {
//        let loginVC = LoginViewController()
//        
//        loginVC.loginviewtype = .session
//        
//        let navController = UINavigationController(rootViewController: loginVC)
//        navController.modalPresentationStyle = .fullScreen
//        navController.navigationBar.isHidden = true
//        if let keyWindow = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .flatMap({ $0.windows })
//            .first(where: { $0.isKeyWindow }) {
//            
//            keyWindow.rootViewController = navController
//            keyWindow.makeKeyAndVisible()
//        }
//    }
//}



#warning("에러가 안돼면 다시 원래대로")
enum NetworkError: LocalizedError {
    case apiError(APIError)
    case refreshTokenExpired
    case accessTokenExpired
    case serverError(code: Int, message: String)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let apiError):
            return apiError.errorMessage
        case .refreshTokenExpired:
            return APIError.expiredPeriodRefreshToken.errorMessage
        case .accessTokenExpired:
            return APIError.expiredPeriodAccessToken.errorMessage
        case .serverError(_, let message):
            return "서버 에러: \(message)"
        case .unknownError(let error):
            return "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}

class NetworkErrorHandler {
    
    static let shared = NetworkErrorHandler()
    
    private init() {}
    
    //MARK: - 에러탐지
    func handleNetworkError<T: Decodable>(_ error: AFError, data: Data?, retryRequest: @escaping () -> Void, completion: @escaping (Result<T, Error>) -> Void) {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let errorCode = json?["code"] as? Int {
                    print(#fileID, #function, #line, "- 실패 JSON 데이터: \(json ?? [:])")

                    if let error = APIError(rawValue: errorCode) {
                        switch error {
                        case .expiredPeriodRefreshToken: // 9103
                            print(#fileID, #function, #line, "-🚨  실패 리프레쉬 토큰 만료. 로그인으로 이동합니다.: \(json ?? [:])")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigateToLoginViewController()
                            }
                            completion(.failure(NetworkError.refreshTokenExpired))
                            
                        case .expiredPeriodAccessToken: // 9104
                            print(#fileID, #function, #line,"🚨 실패 - 엑세스 토큰 만료. 갱신 시도 중...")
                            NewAccessToken.shared.newAccessToken { success in
                                if success {
                                    retryRequest()
                                } else {
                                    completion(.failure(NetworkError.accessTokenExpired))
                                }
                            }
                            
                        case .internalServerError:
                            let message = json?["message"] as? String ?? "알 수 없는 서버 오류"
                            print(#fileID, #function, #line,"- 실패 JSON 데이터: \(json ?? [:])")
                            completion(.failure(NetworkError.serverError(code: errorCode, message: message)))
                            
                        default:
                            completion(.failure(NetworkError.apiError(error)))  // error를 직접 사용
                        }
                    } else {
                        completion(.failure(NetworkError.unknownError(error)))
                    }
                } else {
                    completion(.failure(NetworkError.unknownError(error)))
                }
            } catch {
                completion(.failure(NetworkError.unknownError(error)))
            }
        } else {
            completion(.failure(NetworkError.unknownError(error)))
        }
    }
    
    //MARK: - refreshToken만료시 로그인 페이지로 이동
    private func navigateToLoginViewController() {
        let loginVC = LoginViewController()
        
        loginVC.loginviewtype = .session
        
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            keyWindow.rootViewController = navController
            keyWindow.makeKeyAndVisible()
        }
    }
}
