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
    
    var cancellables = Set<AnyCancellable>()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWakeUpAlarm), name: NSNotification.Name("WakeUpAlarmReceived"), object: nil)
        
        if UserDefaults.standard.bool(forKey: "isWakeUpAlarmActive") {
            setRootViewController(windowScene, type: .alarmON)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserStateChange), name: NSNotification.Name("UserStateChanged"), object: nil)
        
        let userState = UserDefaults.getUserState()
        updateViewControllerForUserState(userState, windowScene: windowScene, refreshToken: nil)
        
        //MARK: - 컴바인 최고
        RegisterUserInfo.shared.$loginState.sink { loginState in
            DispatchQueue.main.async {
                if UserDefaults.standard.bool(forKey: "isWakeUpAlarmActive") {
                    self.setRootViewController(windowScene, type: .alarmON)
                }
            }
            
        }
        .store(in: &cancellables)
    }
    
    func wakeupAlarm(_ scene: UIWindowScene, loginState: LoginStatus?){
        if UserDefaults.standard.bool(forKey: "isWakeUpAlarmActive") {
            setRootViewController(scene, type: .alarmON)
            return
        }
    }
    
    @objc private func handleWakeUpAlarm() {
        if let windowScene = window?.windowScene {
            setRootViewController(windowScene, type: .alarmON)
        }
    }
    
    //기상알람을 받음
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
            if let token = refreshToken,
               !token.isEmpty,
               UserDefaults.standard.bool(forKey: "isExistingUser") {
                setRootViewController(windowScene, type: .main)
            } else {
                setRootViewController(windowScene, type: .register)
            }
        case "login":
            setRootViewController(windowScene, type: .main)
        case "logout":
            setRootViewController(windowScene, type: .login)
        case "alarmON":
            setRootViewController(windowScene, type: .alarmON)
        case "deleteaccount":
            // 회원탈퇴 상태에서는 무조건 약관 동의부터 시작
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            setRootViewController(windowScene, type: .termAgree)
        default:
            setRootViewController(windowScene, type: .termAgree)
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
        
        DispatchQueue.main.async { [weak self] in
            self?.window = newWindow
            newWindow.makeKeyAndVisible()
        }
    }
    
    // 필수 SceneDelegate 메서드들
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        
        let content = UNMutableNotificationContent()
        content.title = "혹시 무음모드를 켜두지는 않으셨나요?"
        content.body = "무음모드를 해지하지 않으면 소리가 나지 않아요!"
        content.sound = .default
        
        // 트리거 설정 (5초 후 알림)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        // 요청 생성
        let request = UNNotificationRequest(identifier: "appTerminationNotification", content: content, trigger: trigger)
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Local Notification Error: \(error.localizedDescription)")
            } else {
                print("Local Notification Scheduled")
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
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



