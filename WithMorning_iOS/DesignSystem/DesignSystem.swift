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
    case fontGray
    case memoGray
}

extension DesignSystemColor {
    var value: UIColor {
        switch self {
        case .backgroundColor : UIColor(hex: "#FAFAFA")
        case .mainColor : UIColor(hex: "#FF7A00")
        case .settingGray : UIColor(hex: "#E8E9EB")
        case .fontBlack : UIColor(hex: "#202020")
        case .fontGray : UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1)
        case .memoGray : UIColor(red: 0.982, green: 0.982, blue: 0.982, alpha: 1)
        }
    }
}

// MARK: - 폰트
enum DesignSystemFont {
    case Pretendard_Bold12
    case Pretendard_Bold20
    case Pretendard_Bold14
    case Pretendard_SemiBold12
    case Pretendard_Medium12
    case Pretendard_Bold30
    case Pretendard_Bold18
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
        case .Pretendard_SemiBold12:
            return UIFont.pretendard(.semiBold, size: 12)
        case .Pretendard_Medium12:
            return UIFont.pretendard(.medium, size: 12)
        case .Pretendard_Bold30:
            return UIFont.pretendard(.bold, size: 30)
        case .Pretendard_Bold18:
            return UIFont.pretendard(.bold, size: 18)
        }
    }
    
    var lineHeightMultiple: CGFloat {
        switch self {
        case .Pretendard_Bold12:
            return 1.19
        case .Pretendard_Bold20:
            return 1.19
        case .Pretendard_Bold14:
            return 1.19
        case .Pretendard_SemiBold12:
            return 2.32
        case .Pretendard_Medium12:
            return 1.17
        case .Pretendard_Bold30:
            return 1.19
        case .Pretendard_Bold18:
            return 1.19
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
