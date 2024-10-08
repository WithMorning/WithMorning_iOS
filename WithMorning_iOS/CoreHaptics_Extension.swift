//
//  CoreHaptics_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/10/24.
//

import Foundation
import UIKit
import CoreHaptics

class CoreHaptics_Extension {

    static let shared = CoreHaptics_Extension()
    
    private let hapticEngine: CHHapticEngine
    
    private var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer? = nil /// 엔진이 패턴가지고 만드는 플레이어
    
    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        
        guard hapticCapability.supportsHaptics else {
            print("Haptic engine Creation Error: Not Support")
            return nil
        }
        
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
    }

    //MARK: - 햅틱 끄기
    func stopHapric() {
        do {
            print(" 0. 진동 끄기")
            try hapticAdvancedPlayer?.stop(atTime: 0)
        } catch {
            print("Failed to stopHapric: \(error)")
        }
    }
    
    //MARK: - 햅틱 시작

    func playHaptic(durations: [Double], powers: [Float]) {
        do {
            print(" 0. 전에 있던 진동 끄기")
            try hapticAdvancedPlayer?.stop(atTime: 0)
            
            print(" 1. 패턴만들기")
            let pattern = try makePattern(durations: durations, powers: powers)
            
            print(" 2. 엔진시작, 플레이어 만들기")
            try hapticEngine.start()
            hapticAdvancedPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
            hapticAdvancedPlayer?.loopEnabled = true
            hapticAdvancedPlayer?.playbackRate = 1.0
            
            print(" 3. 플레이어 시작")
            try hapticAdvancedPlayer?.start(atTime: 0)
        } catch {
            print("Failed to playHaptic: \(error)")
        }
    }
    
    /// duration 단위 : second(초)
    /// power 단위 : 0.0 ~ 1.0
    private func makePattern(durations: [Double], powers: [Float]) throws -> CHHapticPattern {
        
        var events: [CHHapticEvent] = []
        var relativeTime = 0.0
        
        durations.enumerated().forEach {
            let duration = $0.element
            let power = powers[$0.offset]
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: power)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
            
            let params = [intensity, sharpness]
    
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: params, relativeTime: relativeTime, duration: duration)
            relativeTime += duration
            events.append(event)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
    
}
