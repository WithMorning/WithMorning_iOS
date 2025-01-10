//
//
//  AlarmManager.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 12/13/24.
//
//import Foundation
//import UIKit
//import UserNotifications
//import AVFoundation
//
//class AlarmManager {
//
//    static let shared = AlarmManager()
//    private init() {}
//
//    //MARK: -  그룹 기반 알람 예약
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
//
//
//
//
//    //MARK: - API로부터 받은 데이터를 기반으로 알람을 갱신하는 함수
//    func updateAlarm(from data: [GroupList]) {
//        removeAllNotifications()
//        scheduleLocalNotifications(for: data)
//    }
//
//    // 모든 예약된 알림 제거
//    func removeAllNotifications() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//}

import Foundation
import UIKit
import UserNotifications
import AVFoundation

class AlarmManager {
    static let shared = AlarmManager()
    private var timers: [Int: Timer] = [:]  // groupID를 키로 사용하는 타이머 딕셔너리
    private var currentGroups: [GroupList] = []
    private init() {}
    
    // 특정 시간이 현재 알람을 울려야 할 시간인지 확인하는 함수
    private func shouldTriggerAlarm(wakeupTime: String, dayOfWeekList: [String], currentDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let weekdaySymbols = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        let currentWeekdayString = weekdaySymbols[currentWeekday - 1]
        
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        let currentTimeString = String(format: "%02d:%02d", hour, minute)
        
        return dayOfWeekList.contains(currentWeekdayString) && wakeupTime == currentTimeString
    }
    
    // 각 그룹에 대한 타이머 시작
    private func startTimer(for group: GroupList) {
        // 기존 타이머가 있다면 중지
        timers[group.groupID]?.invalidate()
        
        // 1초마다 체크하는 타이머 생성
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.shouldTriggerAlarm(wakeupTime: group.wakeupTime, dayOfWeekList: group.dayOfWeekList ?? []) {
                self.triggerAlarm(for: group)
            }
        }
        
        timers[group.groupID] = timer
    }
    
    // 알람 트리거 함수
    private func triggerAlarm(for group: GroupList) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "기상 알람"
        content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
        content.userInfo = ["groupID": group.groupID]
        
        // 즉시 알람 발생
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "Alarm_\(group.groupID)_\(Date().timeIntervalSince1970)"
        
        let request = UNNotificationRequest(identifier: identifier,
                                          content: content,
                                          trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("알람 트리거 실패: \(error)")
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                print("====== 알람 발생 ======")
                print("그룹 ID: \(group.groupID)")
                print("발생 시간: \(formatter.string(from: Date()))")
                print("=======================")
            }
        }
    }
    
    // 모든 그룹의 알람 시작
    func startAllAlarms(for groups: [GroupList]) {
        // 기존 타이머들 모두 중지
        stopAllAlarms()
        
        currentGroups = groups
        
        // 각 그룹에 대해 타이머 시작
        for group in groups {
            if !group.isDisturbBanGroup {
                startTimer(for: group)
                
                // 디버그 정보 출력
                print("====== 알람 타이머 시작 ======")
                print("그룹 ID: \(group.groupID)")
                print("알람 시간: \(group.wakeupTime)")
                print("알람 요일: \(group.dayOfWeekList ?? [])")
                print("============================")
            }
        }
    }
    
    // 모든 알람 중지
    func stopAllAlarms() {
        for timer in timers.values {
            timer.invalidate()
        }
        timers.removeAll()
        removeAllNotifications()
    }
    
    // 알람 업데이트
    func updateAlarm(from data: [GroupList]) {
        startAllAlarms(for: data)
    }
    
    // 모든 예약된 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
