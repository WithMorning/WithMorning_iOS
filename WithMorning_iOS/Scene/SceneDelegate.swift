//
//  SceneDelegate.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//


import UIKit
import Combine
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var cancellables = Set<AnyCancellable>()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        RegisterUserInfo.shared.$loginState.sink { [weak self] loginState in
            DispatchQueue.main.async {
                self?.updateRootViewController(windowScene, loginState: loginState)
            }
        }
        .store(in: &cancellables)
        
        // 초기 상태 설정
        updateRootViewController(windowScene, loginState: RegisterUserInfo.shared.loginState)
    }
    
    private func updateRootViewController(_ scene: UIWindowScene, loginState: LoginStatus?) {
        
        let refreshToken = KeyChain.read(key: "refreshToken")
        
        let isRegistered = UserDefaults.standard.bool(forKey: "isRegistered")
        
        let viewControllerType: StartViewControllerType
        if let refreshToken = refreshToken, !refreshToken.isEmpty {
            viewControllerType = .main
        } else {
            switch loginState { //로그인 분기처리
                
            case .login: //로그인 상태
                if isRegistered {
                    viewControllerType = .main
                } else {
                    viewControllerType = .register
                }
            case .logout, nil: //로그아웃 or 처음인 상태
                if Storage.isFirstTime() { //처음일 경우
                    viewControllerType = .termAgree
                } else if refreshToken != nil && isRegistered {
                    viewControllerType = .login
                } else {
                    viewControllerType = .login
                }
            }
        }
        
        setRootViewController(scene, type: viewControllerType)
    }
    
    private func setRootViewController(_ scene: UIWindowScene, type: StartViewControllerType) {
        // 새로운 window 설정 전에 기존 window를 nil로 설정
        window?.rootViewController = nil
        
        let newWindow = UIWindow(windowScene: scene)
        print(#fileID, #function, #line, "- 설정된 화면 타입: \(type)")
        
        let viewController = type.vc
        let navigationController: UINavigationController
        
        switch type {
        case .termAgree, .register, .main:
            navigationController = UINavigationController(rootViewController: viewController)
            if type == .main {
                navigationController.navigationBar.isHidden = true
            }
            newWindow.rootViewController = navigationController
        default:
            newWindow.rootViewController = viewController
        }
        
        // 키보드 관련 문제 해결을 위한 딜레이 추가
        DispatchQueue.main.async { [weak self] in
            self?.window = newWindow
            newWindow.makeKeyAndVisible()
        }
    }
    
    // 필수 SceneDelegate 메서드들
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

enum StartViewControllerType {
    case login
    case termAgree
    case main
    case register
    
    var vc: UIViewController {
        switch self {
        case .login: return LoginViewController()
        case .termAgree: return TermsViewController()
        case .main: return MainViewController()
        case .register: return RegisterViewController()
        }
    }
}

public class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set(true, forKey: "isFirstTime")
            return true
        } else {
            return UserDefaults.standard.bool(forKey: "isFirstTime")
        }
    }
}
