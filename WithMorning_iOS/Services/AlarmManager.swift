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
                    content.title = "기상 알람(local)"
                    content.body = "얼른 일어나서 다른 메이트들을 깨워주세요!"
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "wakeupalarm.wav"))
                    content.userInfo = [
                        "groupID": group.groupID,
                    ]
                    
                    let identifier = "Group_\(group.groupID)_\(day)"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: content,
                        trigger: trigger
                    )
                    
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
        removeAllNotifications()
        scheduleLocalNotifications(for: data)
        playAlarmSound()
    }
    
    // 모든 예약된 알림 제거
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 앱 내에서 소리 볼륨을 설정하는 함수
    func playAlarmSound() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // .playback 카테고리 사용 (무음 모드에서도 소리 나도록 설정)
            try audioSession.setCategory(.playback, mode: .default, options: .mixWithOthers)
            try audioSession.setActive(true)
            
            // 알람 소리 파일 경로
            if let soundURL = Bundle.main.url(forResource: "wakeupalarm", withExtension: "wav") {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                
                // 볼륨 설정 (0.0 ~ 1.0 사이의 값)
                let volume = UserDefaults.standard.float(forKey: "volume") / 100 // 설정된 볼륨 값을 가져옴
                player.volume = volume  // AVAudioPlayer의 볼륨을 설정
                
                player.play()
            } else {
                print("알람 소리 파일을 찾을 수 없습니다.")
            }
        } catch {
            print("알람 소리 재생 실패: \(error)")
        }
    }

}
