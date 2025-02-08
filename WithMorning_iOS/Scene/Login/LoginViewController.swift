//
//  LoginViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/19/24.
//

import UIKit
import Then
import SnapKit
import AuthenticationServices
import Alamofire

enum loginViewType {
    case session
    case register
}

class LoginViewController: UIViewController{
    
    var loginviewtype : loginViewType = .register
    
    //MARK: - properties
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 메인 라벨
    private lazy var titleIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "titleLabel")
        return view
    }()

    
    //MARK: - 애플로 로그인
    private lazy var appleButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(DesignSystemColor.Black.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Black.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.setTitle("  Apple로 로그인", for: .normal)
        
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setImage(UIImage(named: "Apple"), for: .normal)
        button.setImage(UIImage(named: "Apple"), for: .highlighted)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        
        button.tintColor = .white
        button.layer.cornerRadius = 8
        
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(apple), for: .touchUpInside)
        return button
    }()
    
//    //MARK: - 게스트로 로그인
//    private lazy var guestButton : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = DesignSystemColor.Gray400.value
//        button.setTitle("  게스트로 로그인", for: .normal)
//        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
//        button.setTitleColor(.white, for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 8
//        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
//        button.titleLabel?.textAlignment = .center
//        button.addTarget(self, action: #selector(guest), for: .touchUpInside)
//        return button
//    }()
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.isNavigationBarHidden = true
        setUI()
        loginviewcheck()
    }
    
    //MARK: - setUI
    
    func setUI(){
        view.addSubviews(popButton,titleIMG,appleButton)
        
        popButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        titleIMG.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.leading.equalToSuperview()
        }
        
        appleButton.snp.makeConstraints{
            $0.height.equalTo(64)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
    }
    
    func loginviewcheck(){
        if loginviewtype == .session{
            self.showToast(message: "세션이 만료되었습니다!")
        }
    }
    
    //MARK: - objc func
    @objc private func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func apple(){
        AppleLoginManager.shared.startSignInWithAppleFlow()
        
    }
    
    
}






//Preview code
#if DEBUG
import SwiftUI
struct OnBoardingSecondViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        LoginViewController()
    }
}
@available(iOS 13.0, *)
struct OnBoardingSecondViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                OnBoardingSecondViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
