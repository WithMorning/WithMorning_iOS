//
//  AppDelegate.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate:UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(1)
        
        //파이어베이스 설정
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        // 푸시 알림 권한 요청 추가
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    
    //MARK: - : UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    //MARK: - 앱이 실행 중인 경우 (Foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        handleNotificationResponse(userInfo)
        completionHandler([.banner, .list, .sound])
    }
    
    //MARK: - 앱이 백그라운드인 경우 (Background) & 백그라운드에서 사용자가 푸시를 탭한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotificationResponse(userInfo)
        completionHandler()
        
    }
    
    //MARK: -  알림을 userdefualt로 처리
    func handleNotificationResponse(_ userInfo: [AnyHashable: Any]) {
        if let groupID = userInfo["groupID"] as? String, let groupIDInt = Int(groupID) {
            UserDefaults.standard.set(groupIDInt, forKey: "wakeupGroupId")
            NavigateToAlarm()
        } else if let groupID = userInfo["groupID"] as? Int {
            UserDefaults.standard.set(groupID, forKey: "wakeupGroupId")
            NavigateToAlarm()
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func NavigateToAlarm() {
        LoadingIndicator.showLoading()
        DispatchQueue.main.async {
            let alarmVC = AlarmViewController.shared
            
            // 현재 활성화된 scene과 window를 가져옴
            guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                LoadingIndicator.hideLoading()
                return
            }
            
            // 현재 루트 뷰 컨트롤러가 AlarmViewController가 아닐 때만 전환
            if !(window.rootViewController is AlarmViewController) {
                let navController = UINavigationController(rootViewController: alarmVC)
                navController.modalPresentationStyle = .fullScreen
                navController.navigationBar.isHidden = true
                
                // 화면 전환 애니메이션 추가
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    window.rootViewController = navController
                }, completion: nil)
                
                window.makeKeyAndVisible()
            }
        }
        LoadingIndicator.hideLoading()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

