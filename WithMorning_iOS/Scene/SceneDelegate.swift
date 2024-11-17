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
        
        let refreshToken = KeyChain.read(key: "refreshToken")
        
        // 사용자 상태 변경 및 알람 이벤트 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserStateChange), name: NSNotification.Name("UserStateChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWakeUpAlarm), name: NSNotification.Name("WakeUpAlarmReceived"), object: nil)
        
        //MARK: - 컴바인 최고ㅜㅜㅜㅜ
        RegisterUserInfo.shared.$loginState.sink { loginState in
            DispatchQueue.main.async {
                self.wakeupAlarm(windowScene, loginState: loginState)
            }
        }
        .store(in: &cancellables)
        
        let userState = UserDefaults.getUserState()
        updateViewControllerForUserState(userState, windowScene: windowScene, refreshToken: refreshToken)
    }
    
    func wakeupAlarm(_ scene: UIWindowScene, loginState: LoginStatus?){
        if let windowScene = window?.windowScene {
            // 알람 상태로 화면 전환
            setRootViewController(windowScene, type: .alarmON)
        }
        
        if UserDefaults.standard.bool(forKey: "isWakeUpAlarmActive") {
            setRootViewController(scene, type: .alarmON)
            return
        }
    }
    
    @objc private func handleWakeUpAlarm() {
        if let windowScene = window?.windowScene {
            // 알람 상태로 화면 전환
            setRootViewController(windowScene, type: .alarmON)
        }
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
            if let token = refreshToken, !token.isEmpty, UserDefaults.standard.bool(forKey: "isExistingUser"){
                setRootViewController(windowScene, type: .main)
            } else {
                setRootViewController(windowScene, type: .register) // 회원가입 화면
            }
        case "login":
            setRootViewController(windowScene, type: .main) // 메인 화면
        case "logout":
            setRootViewController(windowScene, type: .login) // 로그인 화면
        case "deleteaccount":
            setRootViewController(windowScene, type: .termAgree) // 약관 동의 화면
        default:
            setRootViewController(windowScene, type: .termAgree) // 기본적으로 약관 동의 화면
        }
    }
    
    private func setRootViewController(_ scene: UIWindowScene, type: StartViewControllerType) {
        // 새로운 window 설정 전에 기존 window를 nil로 설정
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
    case alarmON
    
    var vc: UIViewController {
        switch self {
        case .login: return LoginViewController()
        case .termAgree: return TermsViewController()
        case .main: return MainViewController()
        case .register: return RegisterViewController()
        case .alarmON: return AlarmViewController()
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

