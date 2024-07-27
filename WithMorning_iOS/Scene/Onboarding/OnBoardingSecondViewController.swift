//
//  OnBoardingSecondViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/19/24.
//

import UIKit
import Then
import SnapKit
import AuthenticationServices

class OnBoardingSecondViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    //MARK: - properties
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    //MARK: - 애플로 로그인
    private lazy var appleButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("  Apple로 로그인", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(apple), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 게스트로 로그인
    private lazy var guestButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Gray400.value
        button.setTitle("  게스트로 로그인", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(guest), for: .touchUpInside)
        return button
    }()
    
    //MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.isNavigationBarHidden = true
        setUI()
    }
    
    //MARK: - setUI

    func setUI(){
        view.addSubviews(popButton,appleButton,guestButton)
        
        popButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        appleButton.snp.makeConstraints{
            $0.height.equalTo(64)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(guestButton.snp.top).offset(-8)
        }
        
        guestButton.snp.makeConstraints{
            $0.height.equalTo(64)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
    }
    
    //MARK: - objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func guest(){
        let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func apple(){
//        applelogin()
        let vc = OnBoardingRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - 애플 로그인
    func applelogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
                
         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // You can create an account in your system.
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                if  let authorizationCode = appleIDCredential.authorizationCode,
                    let identityToken = appleIDCredential.identityToken,
                    let authCodeString = String(data: authorizationCode, encoding: .utf8),
                    let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                    print("authorizationCode: \(authorizationCode)")
                    print("identityToken: \(identityToken)")
                    print("authCodeString: \(authCodeString)")
                    print("identifyTokenString: \(identifyTokenString)")
                }
                
                print("useridentifier: \(userIdentifier)")
                print("fullName: \(fullName)")
                print("email: \(email)")
                
                //Move to MainPage
                //let validVC = SignValidViewController()
                //validVC.modalPresentationStyle = .fullScreen
                //present(validVC, animated: true, completion: nil)
                
            case let passwordCredential as ASPasswordCredential:
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                print("username: \(username)")
                print("password: \(password)")
                
            default:
                break
            }
        }
        

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // 로그인 실패(유저의 취소도 포함)
            print("login failed - \(error.localizedDescription)")
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
        OnBoardingSecondViewController()
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