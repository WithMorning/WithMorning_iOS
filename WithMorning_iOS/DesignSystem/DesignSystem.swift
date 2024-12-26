//
//  DesignSystem.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/12/24.
//

import UIKit

// MARK: - 컬러
enum DesignSystemColor {
    
    //Orange
    case Orange50
    case Orange100
    case Orange200
    case Orange300
    case Orange400
    case Orange500
    case Orange600
    case Orange700
    case Orange800
    case Orange900
    
    //Gray
    case Gray100
    case Gray150
    case Gray200
    case Gray300
    case Gray400
    case Gray500
    case Gray600
    case Gray700
    case Gray800
    case Gray900
    
    //Basics
    case Black
    case White
    case Gray
    
}

extension DesignSystemColor {
    var value: UIColor {
        switch self {
        case .Orange50:
            UIColor(hex: "#FFF4EB")
        case .Orange100:
            UIColor(hex: "#FFE4CC")
        case .Orange200:
            UIColor(hex: "#FFCA99")
        case .Orange300:
            UIColor(hex: "#FFAF66")
        case .Orange400:
            UIColor(hex: "#FF9533")
        case .Orange500:
            UIColor(hex: "#FF7A00")
        case .Orange600:
            UIColor(hex: "#CC6200")
        case .Orange700:
            UIColor(hex: "#994900")
        case .Orange800:
            UIColor(hex: "#663100")
        case .Orange900:
            UIColor(hex: "#331800")
            
            
        case .Gray100:
            UIColor(hex: "#FAFAFA")
        case .Gray150:
            UIColor(hex: "#F5F5F5") //backgroundcolor
        case .Gray200:
            UIColor(hex: "#E3E3E3")
        case .Gray300:
            UIColor(hex: "#CDCDCD")
        case .Gray400:
            UIColor(hex: "#A5A5A5")
        case .Gray500:
            UIColor(hex: "#8F8F8F")
        case .Gray600:
            UIColor(hex: "#727272")
        case .Gray700:
            UIColor(hex: "#565656")
        case .Gray800:
            UIColor(hex: "#393939")
        case .Gray900:
            UIColor(hex: "#1D1D1D")
            
        case .Black:
            UIColor(hex: "#202020")
        case .White:
            UIColor(hex: "#FFFFFF")
        case .Gray:
            UIColor(hex: "#F5F5F5")
        }
    }
}

// MARK: - 폰트
enum DesignSystemFont {
    case Pretendard_Bold8
    case Pretendard_Bold12
    case Pretendard_Bold20
    case Pretendard_Bold14
    case Pretendard_Bold16
    case Pretendard_Bold70
    case Pretendard_SemiBold10
    case Pretendard_SemiBold12
    case Pretendard_SemiBold14
    case Pretendard_SemiBold16
    case Pretendard_Medium12
    case Pretendard_Medium14
    case Pretendard_Medium16
    case Pretendard_Medium18
    case Pretendard_Bold30
    case Pretendard_Bold18
}

extension DesignSystemFont {
    var value: UIFont {
        switch self {
        case .Pretendard_Bold8:
            return UIFont.pretendard(.bold, size: 8)
        case .Pretendard_Bold12:
            return UIFont.pretendard(.bold, size: 12)
        case .Pretendard_Bold20:
            return UIFont.pretendard(.bold, size: 20)
        case .Pretendard_Bold14:
            return UIFont.pretendard(.bold, size: 14)
        case .Pretendard_Bold70:
            return UIFont.pretendard(.bold, size: 70)
        case .Pretendard_SemiBold10:
            return UIFont.pretendard(.semiBold, size: 10)
        case .Pretendard_SemiBold12:
            return UIFont.pretendard(.semiBold, size: 12)
        case . Pretendard_SemiBold16:
            return UIFont.pretendard(.semiBold, size: 16)
        case .Pretendard_Medium12:
            return UIFont.pretendard(.medium, size: 12)
        case .Pretendard_Medium14:
            return UIFont.pretendard(.medium, size: 14)
        case . Pretendard_Medium16:
            return UIFont.pretendard(.medium, size: 16)
        case .Pretendard_Medium18:
            return UIFont.pretendard(.medium, size: 18)
        case .Pretendard_Bold30:
            return UIFont.pretendard(.bold, size: 30)
        case .Pretendard_Bold18:
            return UIFont.pretendard(.bold, size: 18)
        case .Pretendard_Bold16:
            return UIFont.pretendard(.bold, size: 16)
        case .Pretendard_SemiBold14:
            return UIFont.pretendard(.semiBold, size: 14)
        }
    }
    
    var lineHeightMultiple: CGFloat {
        return 1.4
        //                switch self {
        //                case .Pretendard_Bold8:
        //                    return 1.17
        //                case .Pretendard_Bold12:
        //                    return 1.19
        //                case .Pretendard_Bold20:
        //                    return 1.19
        //                case .Pretendard_Bold14:
        //                    return 1.19
        //                case .Pretendard_Bold70:
        //                    return 1.17
        //                case .Pretendard_SemiBold10:
        //                    return 1.17
        //                case .Pretendard_SemiBold12:
        //                    return 2.32
        //                case .Pretendard_Medium12:
        //                    return 1.17
        //                case .Pretendard_Medium14:
        //                    return 1.17
        //                case .Pretendard_Medium16:
        //                    return 1.17
        //                case .Pretendard_Bold30:
        //                    return 1.19
        //                case .Pretendard_Bold18:
        //                    return 1.19
        //                case .Pretendard_Bold16:
        //                    return 1.17
        //                case .Pretendard_SemiBold14:
        //                    return 1.17
        //                case .Pretendard_SemiBold16:
        //                    return 1.17
        //                case .Pretendard_Medium18:
        //                    return 1.17
        //                }
    }
    
    func attributedString(for text: String, color: UIColor = .black) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = self.lineHeightMultiple
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.value,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
}

// MARK: - 아이콘
enum DesignSystemIcon {
    case codbutton
    
}

extension DesignSystemIcon {
    var imageName: String {
        switch self {
            
        case .codbutton:
            return "codebutton"
        }
    }
}

