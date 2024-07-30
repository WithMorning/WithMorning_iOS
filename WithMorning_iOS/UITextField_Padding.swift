//
//  UITextField_Padding.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/30/24.
//

import Foundation
import UIKit

extension UITextField{
    func addleftPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
