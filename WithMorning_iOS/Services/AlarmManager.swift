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
//    private var timers: [Int: Timer] = [:]  // groupID를 키로 사용하는 타이머 딕셔너리
//    private var currentGroups: [GroupList] = []
//    
//    var isTimerRunning = false
//    
//    private init() {}
//    
//    // 특정 시간이 현재 알람을 울려야 할 시간인지 확인하는 함수
//    private func shouldTriggerAlarm(wakeupTime: String, dayOfWeekList: [String], currentDate: Date = Date()) -> Bool {
//        let calendar = Calendar.current
//        let weekdaySymbols = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
//        
//        let currentWeekday = calendar.component(.weekday, from: currentDate)
//        let currentWeekdayString = weekdaySymbols[currentWeekday - 1]
//        
//        let hour = calendar.component(.hour, from: currentDate)
//        let minute = calendar.component(.minute, from: currentDate)
//        let currentTimeString = String(format: "%02d:%02d", hour, minute)
//        
//        return dayOfWeekList.contains(currentWeekdayString) && wakeupTime == currentTimeString
//    }
//    
//    // 각 그룹에 대한 타이머 시작
//    private func startTimer(for group: GroupList) {
//        guard isTimerRunning else { return }
//
//        // 기존 타이머 중지
//        timers[group.groupID]?.invalidate()
//
//        // 타이머 참조를 저장할 변수
//        var newTimer: Timer?
//
//        newTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self, self.isTimerRunning else {
//                // 타이머가 실행 중이 아니면 타이머 무효화
//                newTimer?.invalidate()
//                return
//            }
//
//            if self.shouldTriggerAlarm(wakeupTime: group.wakeupTime, dayOfWeekList: group.dayOfWeekList ?? []) {
//                self.triggerAlarm(for: group)
//            }
//        }
//
//        if let timer = newTimer {
//            timers[group.groupID] = timer
//        }
//    }
//
//    
//    // 알람 트리거 함수
//    private func triggerAlarm(for group: GroupList) {
//        guard isTimerRunning else { return } // 추가된 안전 검사
//
//        let center = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = "기상 알람"
//        content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
//        content.userInfo = ["groupID": group.groupID]
//
//        // 즉시 알람 발생
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let identifier = "Alarm_\(group.groupID)_\(Date().timeIntervalSince1970)"
//
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        center.add(request) { error in
//            if let error = error {
//                print("알람 트리거 실패: \(error)")
//            } else {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                print("====== 알람 발생 ======")
//                print("그룹 ID: \(group.groupID)")
//                print("발생 시간: \(formatter.string(from: Date()))")
//                print("=======================")
//            }
//        }
//    }
//
//    
//    // 모든 그룹의 알람 시작
//    func startAllAlarms(for groups: [GroupList]) {
//        // 먼저 모든 알람 중지
//        stopAllAlarms()
//        
//        // 타이머 실행 상태 활성화
//        isTimerRunning = true
//        currentGroups = groups
//        
//        // 각 그룹에 대해 타이머 시작
//        for group in groups {
//            if !group.isDisturbBanGroup {
//                startTimer(for: group)
//            }
//        }
//        
//        print("====== 알람 시작 확인 ======")
//        print("시작된 타이머 개수: \(timers.count)")
//        print("등록된 그룹 개수: \(currentGroups.count)")
//        print("타이머 실행 상태: \(isTimerRunning)")
//        print("==========================")
//    }
//    
//    
//    // 모든 알람 중지
//    func stopAllAlarms() {
//        // 타이머 실행 상태 변경
//        isTimerRunning = false
//        
//        // 모든 타이머 무효화
//        for (_, timer) in timers {
//            timer.invalidate()
//        }
//        timers.removeAll()
//        
//        // 현재 그룹 목록 초기화
//        currentGroups.removeAll()
//        
//        // 모든 알림 제거
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.removeAllPendingNotificationRequests()
//        notificationCenter.removeAllDeliveredNotifications()
//        
//        print("====== 모든 알람 중지 확인 ======")
//        print("타이머 개수: \(timers.count)")
//        print("그룹 개수: \(currentGroups.count)")
//        print("타이머 실행 상태: \(isTimerRunning)")
//        print("=============================")
//    }
//    
//    func stopAlarm(for groupId: Int) {
//        timers[groupId]?.invalidate()
//        timers.removeValue(forKey: groupId)
//
//        // 알림 제거
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [])
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//
//        // 현재 그룹 목록에서 제거
//        currentGroups.removeAll(where: { $0.groupID == groupId })
//
//        // 실행 상태 업데이트
//        isTimerRunning = !timers.isEmpty
//
//        print("====== 알람 중지 ======")
//        print("그룹 ID: \(groupId)")
//        print("타이머 제거됨")
//        print("알림 제거됨")
//        print("=====================")
//    }
//    
//    // 알람 업데이트
//    func updateAlarm(from data: [GroupList]) {
//        startAllAlarms(for: data)
//    }
//    
//    // 모든 예약된 알림 제거
//    func removeAllNotifications() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//}
class AlarmManager {
    static let shared = AlarmManager()
    private var timers: [Int: Timer] = [:]  // groupID를 키로 사용하는 타이머 딕셔너리
    private var currentGroups: [GroupList] = []  // 현재 그룹 목록
    private var timerStates: [Int: Bool] = [:]  // 각 그룹별 타이머 상태 관리
    
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
//    private func startTimer(for group: GroupList) {
//        guard !timerStates[group.groupID, default: false] else { return }  // 타이머가 이미 실행 중이면 종료
//
//        // 기존 타이머 중지
//        timers[group.groupID]?.invalidate()
//
//        // 타이머 참조를 저장할 변수
//        var newTimer: Timer?
//
//        newTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//
//            if self.shouldTriggerAlarm(wakeupTime: group.wakeupTime, dayOfWeekList: group.dayOfWeekList ?? []) {
//                self.triggerAlarm(for: group)
//            }
//        }
//
//        if let timer = newTimer {
//            timers[group.groupID] = timer
//            timerStates[group.groupID] = true  // 타이머 상태를 실행 중으로 설정
//        }
//    }
    
    private func startTimer(for group: GroupList) {
        guard !timerStates[group.groupID, default: false] else { return }  // 타이머가 이미 실행 중이면 종료

        // 기존 타이머 중지
        timers[group.groupID]?.invalidate()

        // 현재 시간을 가져오기
        let currentDate = Date()

        // 알람이 울려야 할 시간이 현재 시간과 동일한지 확인
        if shouldTriggerAlarm(wakeupTime: group.wakeupTime, dayOfWeekList: group.dayOfWeekList ?? [], currentDate: currentDate) {
            print("현재 시간과 알람 시간이 동일하므로 알람을 시작하지 않습니다.")
            return  // 알람을 시작하지 않음
        }

        // 타이머 시작
        var newTimer: Timer?

        newTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.shouldTriggerAlarm(wakeupTime: group.wakeupTime, dayOfWeekList: group.dayOfWeekList ?? []) {
                self.triggerAlarm(for: group)
            }
        }

        if let timer = newTimer {
            timers[group.groupID] = timer
            timerStates[group.groupID] = true  // 타이머 상태를 실행 중으로 설정
        }
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

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

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
        // 먼저 모든 알람 중지
        stopAllAlarms()

        currentGroups = groups
        
        // 각 그룹에 대해 타이머 시작
        for group in groups {
            if !group.isDisturbBanGroup {
                startTimer(for: group)
            }
        }
        
        print("====== 알람 시작 확인 ======")
        print("시작된 타이머 개수: \(timers.count)")
        print("등록된 그룹 개수: \(currentGroups.count)")
        print("==========================")
    }
    
    

    // 모든 알람 중지
    func stopAllAlarms() {
        // 모든 타이머 무효화
        for (_, timer) in timers {
            timer.invalidate()
        }
        timers.removeAll()
        
        // 모든 타이머 상태를 false로 설정
        for groupID in timerStates.keys {
            timerStates[groupID] = false
        }
        
        // 현재 그룹 목록 초기화
        currentGroups.removeAll()
        
        // 모든 알림 제거
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        
        print("====== 모든 알람 중지 확인 ======")
        print("타이머 개수: \(timers.count)")
        print("그룹 개수: \(currentGroups.count)")
        print("=============================")
    }
    
    // 특정 그룹의 알람 중지
    func stopAlarm(for groupId: Int) {
        timers[groupId]?.invalidate()
        timers.removeValue(forKey: groupId)
        timerStates[groupId] = false  // 해당 그룹의 타이머 상태를 false로 설정

        // 알림 제거
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // 현재 그룹 목록에서 제거
        currentGroups.removeAll { $0.groupID == groupId }

        print("====== 알람 중지 ======")
        print("그룹 ID: \(groupId)")
        print("타이머 제거됨")
        print("알림 제거됨")
        print("=====================")
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

