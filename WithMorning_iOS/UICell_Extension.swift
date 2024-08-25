//
//  UICell_Extension.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/15/24.
//

import UIKit

extension UITableViewCell {
    var parentVC: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
