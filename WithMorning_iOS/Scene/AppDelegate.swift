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
    
    
    // MARK: UISceneSession Lifecycle
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
    
    
    
    //MARK: - Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        handleNotification(userInfo)
        completionHandler([.banner, .list, .sound])
        
    }
    
    //MARK: - Background(앱 꺼진 상태)에서도 알림 오는 설정
    /// 기상알람의 경우 앱 진입시 뷰가 바뀌기 때문에 설정 필요함. 근디? 아직? 모름ㅋㅋ
    /// 실행되는 메서드를 옮기면 될거 같기도 한데 일단 대기 ㅋㅋ

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo)
        completionHandler()
        
    }
    
    //MARK: - silent remote push
    //아마 백그라운드에 있거나, 앱이 켜져있지 않은 상태에서 호출되는 부분으로 추정
    //자세한건 진형이가 하고 나서 설정해야함
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        print("silent push")
        completionHandler(.newData)
    }
    
    
    
    //MARK: - 알림 타입
    private func handleNotification(_ userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String {
            
            switch title {
            case "기상 알람":
                handlewakeup(userInfo)
//                playNotificationSound(named: "ThirdSound")
            case "콕 찌르기":
                handleprick(userInfo)
//                playNotificationSound(named: "ThirdSound")
            case "취침 알람":
                handlebedtime(userInfo)
            default:
                handleDefault(userInfo)
            }
        }
    }
    
    private var notificationVolume: Float {
        // 0-100 스케일을 0-1 스케일로 변환
        return UserDefaults.standard.float(forKey: "volume") / 100.0
    }
    
    // 진동 설정 값을 가져오는 프로퍼티
    private var isVibrateEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "vibrate")
    }
    
    //MARK: - 알림 소리를 위한 메서드(알림 이름을 대입)
    //앱이 켜져있는 상태에서만 소리가 나는 것으로 예상
    private func playNotificationSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file not found")
            return
        }
        
        do {
            
            // AVAudioSession 설정
            // playback - 무음모드일때도 소리남
            // ambient - 무음모드일때는 소리 안남
            
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = notificationVolume // UserDefaults에서 가져온 볼륨 적용
            
            // 진동 설정이 켜져있으면 진동 실행
            if isVibrateEnabled {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    private func handlewakeup(_ userInfo: [AnyHashable: Any]) {
        print("기상알람")
        UserDefaults.standard.set(true, forKey: "isWakeUpAlarmActive")
        NotificationCenter.default.post(name: NSNotification.Name("WakeUpAlarmReceived"), object: nil)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
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
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNS token: \(deviceToken)")
        
        Messaging.messaging().apnsToken = deviceToken
        
        
    }
    
}
