//
//  AppDelegate.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import Firebase
import AVFoundation
import AudioToolbox
import UserNotifications

@main
class AppDelegate:UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var audioPlayer : AVAudioPlayer?
    
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
        
        var window: UIWindow?
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
    
    //MARK: - 알림 타입
    private func handleNotification(_ userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String {
            
            switch title {
            case "기상 알람":
                handlewakeup(userInfo)
            case "콕 찌르기":
                handleprick(userInfo)
            case "취침 알람":
                handlebedtime(userInfo)
            default:
                handleDefault(userInfo)
            }
        }
    }
    
    private func handlewakeup(_ userInfo: [AnyHashable: Any]) {
        print("기상알람")
        UserDefaults.standard.set(true, forKey: "isWakeUpAlarmActive")
        NotificationCenter.default.post(name: NSNotification.Name("WakeUpAlarmReceived"), object: nil)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            if let groupId = userInfo["groupId"] as? String {
                print("🔑 그룹 ID: \(groupId)")
                UserDefaults.standard.set(groupId, forKey: "wakeupGroupId")
                UserDefaults.standard.set(true, forKey: "isWakeUpAlarmActive")
            } else {
                print("❌ groupId가 없습니다.")
            }
            print("📋 전체 알림 데이터:")
            print(jsonString)
        }
    }
    
    private func handleprick(_ userInfo: [AnyHashable: Any]) {
        print("콕 찌르기")
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📋 전체 알림 데이터:")
            print(jsonString)
        }
        
    }
    
    private func handlebedtime(_ userInfo: [AnyHashable: Any]) {
        print("취침 알람")
    }
    
    private func handleDefault(_ userInfo: [AnyHashable: Any]) {
        print("기본 알람")
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNS token: \(deviceToken)")
        
        Messaging.messaging().apnsToken = deviceToken
        
        
    }
    
    //MARK: - 앱이 실행 중인 경우 (Foreground) & 포어그라운드에서 사용자가 푸시를 탭한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        handleNotification(userInfo)
        print("Appdelegate : foreground에서 실행")
        completionHandler([.banner, .list, .sound])
        
    }
    
    //MARK: - 앱이 백그라운드인 경우 (Background) & 백그라운드에서 사용자가 푸시를 탭한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Appdelegate : background에서 실행")
        handleNotification(userInfo)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📋 전체 알림 데이터:")
            print(jsonString)
        }
        
        completionHandler()
        
    }
    
    
    
}
