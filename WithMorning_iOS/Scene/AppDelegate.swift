//
//  AppDelegate.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import Firebase
import AVFoundation
import UserNotifications

@main
class AppDelegate:UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(1)
        
        //파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
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
    
    
    //MARK: - 앱이 실행 중인 경우 (Foreground) & 포어그라운드에서 사용자가 푸시를 탭한 경우
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
        print("푸시 알림 데이터: \(userInfo)")
        
        // groupID 확인 후 UserDefaults에 저장
        if let groupID = userInfo["groupID"] as? String, let groupIDInt = Int(groupID) {
            UserDefaults.standard.set(groupIDInt, forKey: "wakeupGroupId")
            NavigateToAlarm()
        } else if let groupID = userInfo["groupID"] as? Int {
            UserDefaults.standard.set(groupID, forKey: "wakeupGroupId")
            NavigateToAlarm()
        } else {
            print("groupID가 포함되어 있지 않거나 형식이 다릅니다.")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func NavigateToAlarm() {
        let alarmVC = AlarmViewController()
        let navController = UINavigationController(rootViewController: alarmVC)
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
}
