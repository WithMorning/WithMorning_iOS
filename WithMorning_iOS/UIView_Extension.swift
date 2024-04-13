//
//  UIView_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/13/24.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
