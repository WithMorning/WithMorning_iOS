//
//  NotificationPermission.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 11/15/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class NotificationPermission : UIViewController{
    
    private lazy var permissionView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.addSubviews(permissionLabel,permissionSubLabel,permissionButton)
        return view
    }()
    
    private lazy var permissionLabel : UILabel = {
        let label = UILabel()
        label.text = "💡 기기의 알림을 켜주세요"
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_SemiBold16.value
        label.textColor = .black
        return label
    }()
    
    private lazy var permissionSubLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var permissionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitle("알람 허용하러가기", for: .normal)
        button.addTarget(self, action: #selector(permissionAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        setUI()
        sublabelcolor()
        setupTapGesture()
    }
    
    
    func setUI(){
        view.addSubview(permissionView)
        
        permissionView.snp.makeConstraints{
            $0.height.equalTo(170)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(70)
        }
        
        permissionLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        permissionSubLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(permissionLabel.snp.bottom).offset(12)
        }
        
        permissionButton.snp.makeConstraints{
            $0.top.equalTo(permissionSubLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
//MARK: - attributeText
    func sublabelcolor(){
        let fullText = "기기 설정 > 알림 > [윗모닝] 알림을 허용해 주세요!"
        let targetText = "허용"
        let targetColor = DesignSystemColor.Orange500.value
        
        permissionSubLabel.textColor = DesignSystemColor.Gray600.value
        
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: targetColor, range: nsRange)
        }
        
        permissionSubLabel.attributedText = attributedString
    }
//MARK: - 배경터치시 dissmiss

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
//MARK: - objc func

    // 탭 했을 때 실행되는 함수
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !permissionView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    @objc func permissionAction(){
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}


//MARK: - 배경터치시 dismiss

extension NotificationPermission: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: view)
        return !permissionView.frame.contains(location)
    }
}

//Preview code
#if DEBUG
import SwiftUI
struct NotificationPermissionRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        NotificationPermission()
    }
}
@available(iOS 13.0, *)
struct NotificationPermissionRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                NotificationPermissionRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
