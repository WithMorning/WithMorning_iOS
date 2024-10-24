//
//  UserStateViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/15/24.
//

import UIKit
import SnapKit
import Then
import Alamofire
import Kingfisher

class UserStateViewController : UIViewController{
    
    //MARK: - 유저 정보
    lazy var userImage : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .gray
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nicknameLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = DesignSystemFont.Pretendard_Bold18.value
        label.textColor = .black
        return label
    }()
    
    lazy var subLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        return label
    }()
    
    lazy var callButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitle("전화로 깨우기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "phone"), for: .normal)
        button.addTarget(self, action: #selector(callclick), for: .touchUpInside)
        return button
    }()
    
    lazy var pickButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitle("콕 찔러 깨우기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "pick"), for: .normal)
        button.addTarget(self, action: #selector(pickup), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 완료버튼
    private lazy var DoneButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .white
        SetUI()
        configureUserState()
    }
    
    func SetUI(){
        view.addSubviews(userImage,nicknameLabel,subLabel,callButton,pickButton,DoneButton)
        
        userImage.snp.makeConstraints{
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        nicknameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userImage.snp.bottom).offset(16)
        }
        subLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        }
        callButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(view.snp.centerX).offset(-4)
        }
        pickButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(view.snp.centerX).offset(4)
        }
        
        DoneButton.snp.makeConstraints{
            $0.top.equalTo(pickButton.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    var userphoneNum: String = ""
    var isagree : Bool = false
    
    func configureUserState(){
        
        if isagree == true {
            subLabel.text = "전화를 걸어 친구를 깨워주세요."
        }else{
            subLabel.text = "콕 찔러 깨우기를 선호하는 유저입니다."
            callButton.backgroundColor = DesignSystemColor.Gray300.value
        }
    }
    
    var userId : Int = 0
    
    func prickUser(){
        LoadingIndicator.showLoading()
        
        let useridData = prickRequest(userID: userId)
        
        APInetwork.postprick(userId: useridData){ result in
            
            switch result{
            case .success(let data):
                print(data)
                
                LoadingIndicator.hideLoading()
                self.showToast(message: "\(self.nicknameLabel.text ?? "") 님을 콕! 찔렀어요.")
                
            case .failure(let error):
                print(error.localizedDescription)
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    //MARK: - @objc func
    @objc func callclick() {
        if isagree == true{
            self.dismiss(animated: true, completion: {
                if let phoneURL = URL(string: "tel://\(self.userphoneNum)"), UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }
            })
        }else{
            return
        }
    }
    
    
    
    @objc func pickup(){
        prickUser()
    }
    
    @objc func doneclick(){
        self.dismiss(animated: true)
    }
    
    
    
    
}





//Preview code
#if DEBUG
import SwiftUI
struct UserStateViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        UserStateViewController()
    }
}
@available(iOS 13.0, *)
struct UserStateViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                UserStateViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
