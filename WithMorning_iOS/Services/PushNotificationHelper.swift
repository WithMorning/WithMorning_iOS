//
//  PushNotificationHelper.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/21/24.
//

import Foundation
import UserNotifications

class PushNotificationHelper {
    
    static let shared = PushNotificationHelper()
    
    enum AMPMType: String {
        case am = "AM"
        case pm = "PM"
    }
    
    func sleepTimeNotifications(title: String, body: String, weekdays: [Int], hour: Int, minute: Int, ampm: AMPMType, identifier: String) {
        // 1️⃣ 알림 내용 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        // 2️⃣ 12시간 형식을 24시간 형식으로 변환
        let hour24 = convertTo24Hour(hour: hour, ampm: ampm)
        
        for (index, weekday) in weekdays.enumerated() {
            // 3️⃣ 날짜 구성요소 설정
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday // 1(일요일) ~ 7(토요일)
            dateComponents.hour = hour24
            dateComponents.minute = minute
            
            // 4️⃣ 날짜 기반 트리거 생성
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // 5️⃣ 요청 생성
            let uniqueIdentifier = "\(identifier)_\(index)"
            let request = UNNotificationRequest(identifier: uniqueIdentifier,
                                                content: notificationContent,
                                                trigger: trigger)
            
            // 6️⃣ 알림 등록
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Notification Error for weekday \(weekday): ", error)
                }
            }
        }
    }
    
    // 12시간 형식을 24시간 형식으로 변환하는 메서드
    private func convertTo24Hour(hour: Int, ampm: AMPMType) -> Int {
        var hour24 = hour
        if ampm == .pm && hour != 12 {
            hour24 += 12
        } else if ampm == .am && hour == 12 {
            hour24 = 0
        }
        return hour24
    }
}
