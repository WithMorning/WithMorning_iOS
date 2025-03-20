//
//  UIColor_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/11/24.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}


extension UIColor {
    /// 색상의 밝기를 조정 (factor > 1.0이면 밝아짐, < 1.0이면 어두워짐)
    func adjustBrightness(by factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let adjustedBrightness = min(max(brightness * factor, 0.0), 1.0)
            return UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
        
        return self
    }
}
