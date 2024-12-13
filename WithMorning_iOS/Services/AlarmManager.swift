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
    
    // 그룹 기반 알람 예약
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
                    var dateComponents = DateComponents()
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    dateComponents.weekday = weekday + 1
                    
                    let content = UNMutableNotificationContent()
                    content.title = "기상 알람"
                    content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
                    let identifier = "Group_\(group.groupID)_\(day)"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: content,
                        trigger: trigger
                    )
                    
                    // 예약된 알람의 정보를 출력
                    print("알람 예약됨 - Identifier: \(identifier)")
                    print("  Title: \(content.title)")
                    print("  Body: \(content.body)")
                    print("  Trigger: \(trigger.dateComponents.description)")
                    
                    center.add(request) { error in
                        if let error = error {
                            print("알람 예약 실패: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    // API로부터 받은 데이터를 기반으로 알람을 갱신하는 함수
    func updateAlarm(from data: [GroupList]) {
        // 기존 알람 삭제
        removeAllNotifications()
        
        // 새로운 알람 예약
        scheduleLocalNotifications(for: data)
    }
    
    // 모든 예약된 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 특정 그룹의 알림만 제거
    func removeNotification(for groupId: Int) {
        let identifiers = (0...6).map { "Group_\(groupId)_\($0)" } // 요일별 알림 제거
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // 앱 내에서 소리 볼륨을 설정하는 함수
    func setAppVolume(to volume: Float) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            
            let volume = UserDefaults.standard.float(forKey: "volume")
            
            print("설정된 볼륨: \(volume)")
            
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
    
    func playAlarmSound() {
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default) //.playback 무음모드에 관계없이 알람
            try audioSession.setActive(true)
            
            // 알람 소리 파일 경로
            if let soundURL = Bundle.main.url(forResource: "wakeupalarm", withExtension: "wav") {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.play()
            } else {
                print("알람 소리 파일을 찾을 수 없습니다.")
            }
        } catch {
            print("알람 소리 재생 실패: \(error)")
        }
    }
}

