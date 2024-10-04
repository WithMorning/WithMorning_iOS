//
//  LoadingIndicator.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/23/24.
//

import UIKit

class LoadingIndicator {
    
    static private var activityIndicator: UIActivityIndicatorView?
    
    static func showLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            if let existingIndicator = activityIndicator {
                existingIndicator.startAnimating()
                window.bringSubviewToFront(existingIndicator)
            } else {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.frame = window.bounds
                indicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                indicator.color = /*.white*/ /*DesignSystemColor.Orange500.value*/.black
                indicator.startAnimating()
                window.addSubview(indicator)
                window.bringSubviewToFront(indicator)
                activityIndicator = indicator
            }
            
            window.isUserInteractionEnabled = false
            print("Loading indicator is now visible")
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            window.isUserInteractionEnabled = true
            print("Loading indicator has been hidden")
        }
    }
}
