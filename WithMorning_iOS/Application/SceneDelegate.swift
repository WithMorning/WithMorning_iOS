//
//  SceneDelegate.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import Combine
import AuthenticationServices
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    //subscriber
    var cancellables = Set<AnyCancellable>()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        //MARK: - 화면
        RegisterUserInfo.shared.$loginState
            .sink { loginState in
                DispatchQueue.main.async {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserStateChange), name: NSNotification.Name("UserStateChanged"), object: nil)
                    let userState = UserDefaults.getUserState()
                    self.updateViewControllerForUserState(userState, windowScene: windowScene, refreshToken: nil)
                }
            }
            .store(in: &cancellables)
        
    }
    
    @objc private func handleUserStateChange() {
        let userState = UserDefaults.getUserState()
        print(#fileID, #function, #line, "- 현재 사용자 상태: \(userState ?? "nil")")
        let refreshToken = KeyChain.read(key: "refreshToken")
        if let windowScene = window?.windowScene {
            updateViewControllerForUserState(userState, windowScene: windowScene, refreshToken: refreshToken)
        }
    }
    
    private func updateViewControllerForUserState(_ userState: String?, windowScene: UIWindowScene, refreshToken: String?) {
        switch userState {
        case "termsagree":
            setRootViewController(windowScene, type: .termAgree)
        case "register":
            setRootViewController(windowScene, type: .register)
        case "login":
            setRootViewController(windowScene, type: .main)
        case "logout":
            setRootViewController(windowScene, type: .login)
        case "deleteaccount":
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            setRootViewController(windowScene, type: .termAgree)
        default:
            setRootViewController(windowScene, type: .termAgree)
        }
    }
    
    private func setRootViewController(_ scene: UIWindowScene, type: StartViewControllerType) {
        window?.rootViewController = nil
        let newWindow = UIWindow(windowScene: scene)
        print(#fileID, #function, #line, "- 설정된 화면 타입: \(type)")
        let viewController = type.vc
        let navigationController: UINavigationController
        switch type {
        case .termAgree, .register, .main, .login:
            navigationController = UINavigationController(rootViewController: viewController)
            if type == .main {
                navigationController.navigationBar.isHidden = true
            }
            newWindow.rootViewController = navigationController
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.window = newWindow
            newWindow.makeKeyAndVisible()
        }
    }
    
    //MARK: - sceneDidDisconnect 앱이 terminated일때 push알람
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
    
    
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



