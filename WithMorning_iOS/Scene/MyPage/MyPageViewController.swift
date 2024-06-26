//
//  MyPageViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 5/8/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MyPageViewController : UIViewController {
    
    //MARK: - 네비게이션
    
    private lazy var myPageLabel : UILabel = {
        let label = UILabel()
        label.text = "마이 페이지"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    //MARK: - profile
    private lazy var profileImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        return image
    }()
    
    private lazy var nickNameLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold18.value
        label.tintColor = .black
        label.text = "일이삼사오육칠팔구십"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editProfileButton : UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.backgroundColor = DesignSystemColor.Gray200.value
        button.setTitleColor(DesignSystemColor.Gray600.value, for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var ContectButton : UIButton = {
        let button = UIButton()
        button.setTitle("연락처 연동", for: .normal)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitleColor(DesignSystemColor.White.value, for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.layer.cornerRadius = 4
        return button
    }()

    //MARK: - StackView
    
    //
//    private lazy var pushView: UIStackView = UIStackView()
//        
//        private let pushLabel = UILabel().then {
//            $0.text = "푸시 알림 설정"
//            $0.font = UIFont.pretendard(.medium, size: 16)
//            $0.textColor = UIColor(hex: "24252E")
//        }
//        
//        private lazy var pushLeftArrow = UIImageView().then {
//            $0.image = UIImage(systemName: "chevron.right")
//            $0.contentMode = .scaleAspectFit
//            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
//            $0.tintColor = UIColor(hex: "24252E")
//        }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
    }
    
    func SetUI(){
        view.addSubviews(myPageLabel,popButton,nickNameLabel,editProfileButton,ContectButton)
        
        myPageLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(myPageLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        nickNameLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(109.5)
            $0.trailing.equalTo(ContectButton)
            $0.leading.equalTo(editProfileButton.snp.leading)
            $0.trailing.equalTo(ContectButton.snp.trailing)
        }
        
        editProfileButton.snp.makeConstraints{
            $0.trailing.equalTo(ContectButton.snp.leading).offset(-6)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(16)
            $0.height.equalTo(44)
            $0.width.equalTo(97)
        }
        
        ContectButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-32)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(16)
            $0.height.equalTo(44)
            $0.width.equalTo(97)
        }
        
    }
    
    @objc func popclicked(){
//        let vc = MainViewController()
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
}
//Preview code
#if DEBUG
import SwiftUI
struct ProfileViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        MyPageViewController()
    }
}
@available(iOS 13.0, *)
struct ProfileViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                ProfileViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
