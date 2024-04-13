//
//  DesignSystem.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/12/24.
//

import UIKit

// MARK: - 컬러
enum DesignSystemColor {
    case backgroundColor
    case mainColor
    case settingGray
    case fontBlack
}

extension DesignSystemColor {
    var value: UIColor {
        switch self {
        case .backgroundColor : UIColor(hex: "#FAFAFA")
        case .mainColor : UIColor(hex: "#627CF2")
        case .settingGray : UIColor(hex: "#E8E9EB")
        case .fontBlack : UIColor(hex: "#202020")

        }
    }
}

// MARK: - 폰트
enum DesignSystemFont {
    case Pretendard_Bold12
    case Pretendard_Bold20
    case Pretendard_Bold14
}

extension DesignSystemFont {
    var value: UIFont {
        switch self {
        case .Pretendard_Bold12:
            return UIFont.pretendard(.bold, size: 12)
        case .Pretendard_Bold20:
            return UIFont.pretendard(.bold, size: 20)
        case .Pretendard_Bold14:
            return UIFont.pretendard(.bold, size: 14)
        }
    }
    
    var lineHeightMultiple: CGFloat {
        switch self {
        case .Pretendard_Bold12:
            return 1.1958
        case .Pretendard_Bold20:
            return 1.1935
        case .Pretendard_Bold14:
            return 1.1936
        }
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
