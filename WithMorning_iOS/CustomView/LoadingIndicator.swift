//
//  LoadingIndicator.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/23/24.
//

import UIKit

class LoadingIndicator {
    
    static let shared = LoadingIndicator()
    
    static func showLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            let backgroundView = UIView(frame: window.bounds)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 투명도 조절
            backgroundView.tag = 999
            
            let loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.center = backgroundView.center
            loadingIndicatorView.color = DesignSystemColor.Orange500.value.withAlphaComponent(0.7) // 인디케이터 색상을 메인칼라루 변경
            
            backgroundView.addSubview(loadingIndicatorView)
            window.addSubview(backgroundView)
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            window.subviews.filter({ $0.tag == 999 }).forEach { $0.removeFromSuperview() }
        }
    }
}
