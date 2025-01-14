//
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

//class AlarmManager {
//    static let shared = AlarmManager()
//    private var currentGroups: [GroupList] = []
//    
//    private init() {
//        setupNotifications()
//    }
//    
//    private func setupNotifications() {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("알림 권한 승인됨")
//            } else {
//                print("알림 권한 거부됨: \(error?.localizedDescription ?? "")")
//            }
//        }
//    }
//
//    private func findNextAlarmDate(for group: GroupList) -> Date? {
//            let calendar = Calendar.current
//            let now = Date()
//            
//            // 알람 시간 파싱
//            let components = group.wakeupTime.split(separator: ":")
//            guard components.count == 2,
//                  let hour = Int(components[0]),
//                  let minute = Int(components[1]) else { return nil }
//            
//            // 요일 문자열을 숫자로 변환 (1 = 일요일, 2 = 월요일, ...)
//            let weekdays = (group.dayOfWeekList ?? []).map { convertWeekdayToNumber($0) }.sorted()
//            guard !weekdays.isEmpty else { return nil }
//            
//            // 현재 요일과 시간
//            let currentWeekday = calendar.component(.weekday, from: now)
//            let currentHour = calendar.component(.hour, from: now)
//            let currentMinute = calendar.component(.minute, from: now)
//            
//            var nextAlarmDate: Date?
//            var shortestDiff = Double.infinity
//            
//            // 앞으로 7일 동안의 모든 가능한 알람 시간을 확인
//            for dayOffset in 0...7 {
//                let date = calendar.date(byAdding: .day, value: dayOffset, to: now)!
//                let weekday = calendar.component(.weekday, from: date)
//                
//                // 알람이 설정된 요일인지 확인
//                guard weekdays.contains(weekday) else { continue }
//                
//                // 알람 시간 설정
//                var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
//                dateComponents.hour = hour
//                dateComponents.minute = minute
//                dateComponents.second = 0
//                
//                guard let alarmDate = calendar.date(from: dateComponents) else { continue }
//                
//                // 과거의 시간은 건너뛰기
//                if alarmDate <= now { continue }
//                
//                // 현재 시간과의 차이 계산
//                let diff = alarmDate.timeIntervalSince(now)
//                
//                // 가장 가까운 시간 저장
//                if diff < shortestDiff {
//                    shortestDiff = diff
//                    nextAlarmDate = alarmDate
//                }
//            }
//            
//            return nextAlarmDate
//        }
//    
//    private func scheduleNextAlarm(for group: GroupList) {
//            guard let nextAlarmDate = findNextAlarmDate(for: group) else {
//                print("다음 알람 시간을 찾을 수 없습니다.")
//                return
//            }
//            
//            // 60개의 알람 등록 (1초 간격)
//            let center = UNUserNotificationCenter.current()
//            let calendar = Calendar.current
//            
//            // 기존 알람 제거
//            stopAlarm(for: group.groupID)
//            
//            // 60초 동안의 알람 등록
//            for second in 0..<60 {
//                guard let alarmTime = calendar.date(byAdding: .second, value: second, to: nextAlarmDate) else {
//                    continue
//                }
//                
//                let content = UNMutableNotificationContent()
//                content.title = "기상 알람"
//                content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
//                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
//                content.userInfo = [
//                    "groupID": group.groupID,
//                    "isLastNotification": second == 59
//                ]
//                
//                let triggerComponents = calendar.dateComponents(
//                    [.year, .month, .day, .hour, .minute, .second],
//                    from: alarmTime
//                )
//                let trigger = UNCalendarNotificationTrigger(
//                    dateMatching: triggerComponents,
//                    repeats: false
//                )
//                
//                let identifier = "Alarm_\(group.groupID)_\(second)"
//                let request = UNNotificationRequest(
//                    identifier: identifier,
//                    content: content,
//                    trigger: trigger
//                )
//                
//                center.add(request) { error in
//                    if let error = error {
//                        print("알람 등록 실패 (\(second)초): \(error.localizedDescription)")
//                    }
//                }
//            }
//            
//            print("다음 알람 예약됨 - 그룹: \(group.groupID), 시간: \(nextAlarmDate)")
//        }
//    
//    private func convertWeekdayToNumber(_ weekday: String) -> Int {
//        let weekdays = ["sun": 1, "mon": 2, "tue": 3, "wed": 4, "thu": 5, "fri": 6, "sat": 7]
//        return weekdays[weekday.lowercased()] ?? 1
//    }
//    
//    func startAllAlarms(for groups: [GroupList]) {
//        stopAllAlarms()
//        currentGroups = groups
//        
//        for group in groups {
//            if !group.isDisturbBanGroup {
//                scheduleNextAlarm(for: group)
//            }
//        }
//    }
//    
//    func stopAllAlarms() {
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        center.removeAllDeliveredNotifications()
//        currentGroups.removeAll()
//        print("====== 모든 알람 중지됨 ======")
//    }
//    
//    func stopAlarm(for groupId: Int) {
//        let center = UNUserNotificationCenter.current()
//        let identifierPrefix = "Alarm_\(groupId)_"
//        
//        center.getPendingNotificationRequests { requests in
//            let identifiersToRemove = requests
//                .filter { $0.identifier.hasPrefix(identifierPrefix) }
//                .map { $0.identifier }
//            
//            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
//        }
//        
//        currentGroups.removeAll { $0.groupID == groupId }
//        
//        print("====== 알람 중지 ======")
//        print("그룹 ID: \(groupId)")
//        print("알람 제거됨")
//        print("=====================")
//    }
//    
//    func updateAlarm(from data: [GroupList]) {
//        startAllAlarms(for: data)
//    }
//}
class AlarmManager {
    static let shared = AlarmManager()
    private var currentGroups: [GroupList] = []
    
    private init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한 승인됨")
            } else {
                print("알림 권한 거부됨: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    // 특정 그룹의 다음 알람 시간을 찾는 함수
    private func findNextAlarmDate(for group: GroupList) -> (date: Date, groupId: Int)? {
        let calendar = Calendar.current
        let now = Date()
        
        // 알람 시간 파싱
        let components = group.wakeupTime.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else { return nil }
        
        // 요일 문자열을 숫자로 변환
        let weekdays = (group.dayOfWeekList ?? []).map { convertWeekdayToNumber($0) }.sorted()
        guard !weekdays.isEmpty else { return nil }
        
        var nextAlarmDate: Date?
        var shortestDiff = Double.infinity
        
        // 앞으로 7일 동안의 모든 가능한 알람 시간을 확인
        for dayOffset in 0...7 {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: now)!
            let weekday = calendar.component(.weekday, from: date)
            
            guard weekdays.contains(weekday) else { continue }
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = 0
            
            guard let alarmDate = calendar.date(from: dateComponents) else { continue }
            
            if alarmDate <= now { continue }
            
            let diff = alarmDate.timeIntervalSince(now)
            if diff < shortestDiff {
                shortestDiff = diff
                nextAlarmDate = alarmDate
            }
        }
        
        if let date = nextAlarmDate {
            return (date, group.groupID)
        }
        return nil
    }
    
    // 모든 그룹 중 가장 가까운 알람을 찾는 함수
    private func findClosestAlarm(from groups: [GroupList]) -> (date: Date, groupId: Int)? {
        var closestAlarm: (date: Date, groupId: Int)?
        var shortestDiff = Double.infinity
        
        for group in groups {
            guard !group.isDisturbBanGroup else { continue }
            
            if let nextAlarm = findNextAlarmDate(for: group) {
                let diff = nextAlarm.date.timeIntervalSince(Date())
                if diff < shortestDiff {
                    shortestDiff = diff
                    closestAlarm = nextAlarm
                }
            }
        }
        
        return closestAlarm
    }
    
    private func scheduleClosestAlarm(from groups: [GroupList]) {
        guard let closestAlarm = findClosestAlarm(from: groups) else {
            print("예약할 수 있는 알람이 없습니다.")
            return
        }
        
        // 기존 알람들 모두 제거
        stopAllAlarms()
        
        // 60개의 알람 등록 (1초 간격)
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        for second in 0..<60 {
            guard let alarmTime = calendar.date(byAdding: .second, value: second, to: closestAlarm.date) else {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "기상 알람"
            content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
            content.userInfo = [
                "groupID": closestAlarm.groupId,
                "isLastNotification": second == 59
            ]
            
            let triggerComponents = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: alarmTime
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: triggerComponents,
                repeats: false
            )
            
            let identifier = "Alarm_\(closestAlarm.groupId)_\(second)"
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("알람 등록 실패 (\(second)초): \(error.localizedDescription)")
                }
            }
        }
        
        print("다음 알람 예약됨 - 그룹: \(closestAlarm.groupId), 시간: \(closestAlarm.date)")
    }
    
    private func convertWeekdayToNumber(_ weekday: String) -> Int {
        let weekdays = ["sun": 1, "mon": 2, "tue": 3, "wed": 4, "thu": 5, "fri": 6, "sat": 7]
        return weekdays[weekday.lowercased()] ?? 1
    }
    
    func startAllAlarms(for groups: [GroupList]) {
        currentGroups = groups
        scheduleClosestAlarm(from: groups)
    }
    
    func stopAllAlarms() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        currentGroups.removeAll()
        print("====== 모든 알람 중지됨 ======")
    }
    
    func updateAlarm(from data: [GroupList]) {
        startAllAlarms(for: data)
    }
}
