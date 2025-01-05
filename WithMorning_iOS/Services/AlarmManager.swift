//
//  AlarmManager.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 12/13/24.
//
import Foundation
import UIKit
import UserNotifications
import AVFoundation

class AlarmManager {
    
    static let shared = AlarmManager()
    private init() {}
    
    //MARK: -  그룹 기반 알람 예약
    //    func scheduleLocalNotifications(for groups: [GroupList]) {
    //        let center = UNUserNotificationCenter.current()
    //
    //        // 기존 예약된 알림 모두 제거
    //        center.removeAllPendingNotificationRequests()
    //
    //        for group in groups {
    //            // 방해 금지 그룹은 건너뜀
    //            if group.isDisturbBanGroup { continue }
    //
    //            // 알람 시간 파싱
    //            let timeComponents = group.wakeupTime.split(separator: ":")
    //            guard timeComponents.count == 2,
    //                  let hour = Int(timeComponents[0]),
    //                  let minute = Int(timeComponents[1]) else {
    //                continue
    //            }
    //
    //            // 요일 변환
    //            let daysOfWeek = group.dayOfWeekList ?? []
    //            let weekdaySymbols = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    //
    //            for day in daysOfWeek {
    //                if let weekday = weekdaySymbols.firstIndex(of: day) {
    //                    var dateComponents = DateComponents()
    //                    dateComponents.hour = hour
    //                    dateComponents.minute = minute
    //                    dateComponents.weekday = weekday + 1
    //
    //                    let content = UNMutableNotificationContent()
    //                    content.title = "기상 알람"
    //                    content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
    //                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
    //                    content.userInfo = [
    //                        "groupID": group.groupID,
    //                    ]
    //
    //                    let identifier = "Group_\(group.groupID)_\(day)"
    //                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    //
    //                    let request = UNNotificationRequest(
    //                        identifier: identifier,
    //                        content: content,
    //                        trigger: trigger
    //                    )
    //
    //                    center.add(request) { error in
    //                        if let error = error {
    //                            print("알람 예약 실패: \(error)")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func scheduleLocalNotifications(for groups: [GroupList]) {
        let center = UNUserNotificationCenter.current()
        
        // 기존 예약된 알림 모두 제거
        center.removeAllPendingNotificationRequests()
        
        for group in groups {
            // 방해 금지 그룹은 건너뜀
            if group.isDisturbBanGroup { continue }
            
            // 알람 시간 파싱
            let timeComponents = group.wakeupTime.split(separator: ":")
            guard timeComponents.count == 2,
                  let hour = Int(timeComponents[0]),
                  let minute = Int(timeComponents[1]) else {
                continue
            }
            
            // 요일 변환
            let daysOfWeek = group.dayOfWeekList ?? []
            let weekdaySymbols = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
            
            for day in daysOfWeek {
                if let weekday = weekdaySymbols.firstIndex(of: day) {
                    // 현재 시간부터 다음 6개의 10초 간격 알람을 예약
                    scheduleNextSixAlarms(for: group.groupID, day: day)
                }
            }
        }
    }
    
    private func scheduleNextSixAlarms(for groupID: String, day: String) {
        let center = UNUserNotificationCenter.current()
        
        // 현재 시간으로부터 60초 동안의 알람을 10초 간격으로 예약
        for i in 0..<6 {
            let content = UNMutableNotificationContent()
            content.title = "기상 알람"
            content.body = "얼른 일어나세요!"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
            content.userInfo = [
                "groupID": groupID,
                "isRepeating": true  // 반복 알람임을 표시
            ]
            
            // i * 10초 후에 알람이 울리도록 설정
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 10), repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "Group_\(groupID)_\(day)_Alarm\(i)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("알람 예약 실패: \(error)")
                }
            }
        }
        
        // 마지막 알람이 울린 후 새로운 알람들을 예약하기 위해 타이머 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 55) { // 마지막 알람 직전에 다음 알람들 예약
            self.scheduleNextSixAlarms(for: groupID, day: day)
        }
    }
    
    // API로부터 받은 데이터를 기반으로 알람을 갱신하는 함수
    func updateAlarm(from data: [GroupList]) {
        removeAllNotifications()
        scheduleLocalNotifications(for: data)
    }
    
    // 모든 예약된 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
