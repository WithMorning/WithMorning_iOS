import Foundation
import UIKit
import SnapKit

extension UIViewController {
    
    func showToast(message: String, delayTime: Double, withduration : Double) {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        self.view.addSubview(containerView)
        
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = DesignSystemFont.Pretendard_Medium14.value
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        containerView.addSubview(toastLabel)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        UIView.animate(withDuration: withduration, delay: delayTime, options: .curveEaseOut, animations: {
            containerView.alpha = 0.0
        }, completion: { _ in
            containerView.removeFromSuperview()
        })
    }
}
