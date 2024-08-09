//
//  UISlider_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/9/24.
//

import Foundation
import UIKit

//MARK: - 슬라이더 두께 조절
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // 원하는 두께로 조절하세요. 여기서는 10으로 설정했습니다.
        let customTrackRect = CGRect(
            x: 0,
            y: bounds.origin.y + bounds.size.height/2 - 3,
            width: bounds.width,
            height: 6
        )
        super.trackRect(forBounds: customTrackRect)
        return customTrackRect
    }
    
}
