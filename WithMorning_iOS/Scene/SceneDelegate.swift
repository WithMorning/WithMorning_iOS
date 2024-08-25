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
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        RegisterUserInfo.shared.$loginState.sink { loginState in
            let refreshToken = KeyChain.read(key: "refreshToken")
            
            print(#fileID, #function, #line, "- sceneDelegate refreshToken: \(refreshToken)")
            if let loginState = loginState {
                switch loginState {
                case .login:
                    // 로그인 상태이지만 아직 회원가입을 완료하지 않은 경우
                    self.setRootViewContrller(scene, type: .joined)
                case .joined:
                    // 로그인 상태이며 회원가입을 완료한 경우
                    self.setRootViewContrller(scene, type: .joined)
                }
            } else {
                // loginState가 nil인 경우 (로그아웃 상태)
                
                if refreshToken != "" {
                    print("🔥KeyChain에 저장된 accessToken : ", KeyChain.read(key: "accessToken") ?? "")
                    print("🔥KeyChain에 저장된 refreshToken : ",KeyChain.read(key: "refreshToken") ?? "")
                    // refreshToken이 있으면 자동 로그인
                    self.setRootViewContrller(scene, type: .login)
                    
                } else if Storage.isFirstTime() {
                    self.setRootViewContrller(scene, type: .termAgree)
                } else {
                    self.setRootViewContrller(scene, type: .login)
                }
            }
        }
        .store(in: &cancellables)
    }
    
    
}

func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

//MARK: - 상태
enum rootViewController {
    case login
    case joined
    case termAgree
    //    case onBoarding
    
    var vc : UIViewController{
        switch self{
        case .login : return LoginViewController()
        case .joined: return MainViewController()
        case .termAgree: return OnBoardingFirstViewController()
            //        case .onBoarding: return OnBoardingTutorialViewController()
        }
    }
}

//MARK: - 시작 순서 결정 : 약관동의 -> 로그인 -> 회원가입 -> 인증번호 -> 프로필작성 -> 튜토리얼

extension SceneDelegate{
    private func setRootViewController(_ scene: UIScene) {
        let refreshToken = KeyChain.read(key: "refreshToken")
        print(#fileID, #function, #line, "- refreshToken: \(refreshToken)")
        
        //        if refreshToken != ""{
        //            setRootViewContrller(scene, type: .main)
        //        }
        
        if Storage.isFirstTime() {
            setRootViewContrller(scene, type: .termAgree)
        }
        else if refreshToken != "" {
            setRootViewContrller(scene, type: .joined)
        }
        else {
            setRootViewContrller(scene, type: .login)
        }
    }
    //MARK: - 데이터 타입을 확인하고 문제가 뷰컨을 교체해줍니당
    private func setRootViewContrller(_ scene: UIScene, type: rootViewController) {
        if let windowScene = scene as? UIWindowScene {
            DispatchQueue.main.async {
                let window = UIWindow(windowScene: windowScene)
                print(#fileID, #function, #line, "- 어떤 type의 data인지 확인하기⭐️: \(type)")
                
                if type == .termAgree {
                    let navigationController = UINavigationController(rootViewController: type.vc)
                    window.rootViewController = navigationController
                } else {
                    window.rootViewController = type.vc //그에 맞게 Rootview를 변경해준다
                }
                
                self.window = window
                window.makeKeyAndVisible()
            }
            
        }
    }
    
    public class Storage {
        static func isFirstTime() -> Bool {
            let defaults = UserDefaults.standard //defaults DB를 가지고 온다
            if defaults.object(forKey: "isFirstTime") == nil { //해당 DB에서 isFirstTime이라는 키가 있느지 체크한다
                defaults.set(true, forKey: "isFirstTime")
                return true
            } else {
                let isFirstTime = UserDefaults.standard.bool(forKey: "isFirstTime") //isFirstTime인지 체크하기
                return isFirstTime
            }
        }
    }
    
}

