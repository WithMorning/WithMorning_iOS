//
//  UserAuthService.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 10/4/24.
//

//import Foundation
//import Combine
//import UIKit
//
//class UserAuthService {
//    static let shared = UserAuthService()
//    private init() {}
//    
//    @Published var loginState: LoginState?
//    var cancellables = Set<AnyCancellable>()
//    
//    enum LoginState {
//        case login
//        case logout
//    }
//    
//    func checkAuthStatus() -> StartViewControllerType {
//        let refreshToken = KeyChain.read(key: "refreshToken")
//        
//        if Storage.isFirstTime() {
//            return .termAgree
//        } else if let refreshToken = refreshToken, !refreshToken.isEmpty {
//            return loginState == .login ? (RegisterUserInfo.shared.userIsRegistered ? .main : .register) : .main
//        } else {
//            return .login
//        }
//    }
//    
//    func saveAuthInfo(refreshToken: String) {
//        KeyChain.create(key: "refreshToken", token: refreshToken)
//        loginState = .login
//    }
//    
//    func clearAuthInfo() {
//        KeyChain.delete(key: "refreshToken")
//        loginState = .logout
//    }
//    
//    func setUserRegistered(_ isRegistered: Bool) {
//        RegisterUserInfo.shared.userIsRegistered = isRegistered
//    }
//}
//
//// Storage class remains the same
//class Storage {
//    static func isFirstTime() -> Bool {
//        let defaults = UserDefaults.standard
//        if defaults.object(forKey: "isFirstTime") == nil {
//            defaults.set(true, forKey: "isFirstTime")
//            return true
//        } else {
//            return defaults.bool(forKey: "isFirstTime")
//        }
//    }
//}
//
//// Enum for start view controller types
//enum StartViewControllerType {
//    case login
//    case termAgree
//    case main
//    case register
//    
//    var vc: UIViewController {
//        switch self {
//        case .login: return LoginViewController()
//        case .termAgree: return TermsViewController()
//        case .main: return MainViewController()
//        case .register: return RegisterViewController()
//        }
//    }
//}
