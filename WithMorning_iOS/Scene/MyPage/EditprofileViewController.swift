//
//  EditprofileViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/15/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class EditprofileViewController : UIViewController {
    
    //MARK: - properties
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
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
    
    private lazy var profileLabel : UILabel = {
        let label = UILabel()
        label.text = "사용하실 프로필을 설정해주세요."
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profile")
        return image
    }()
    
    private lazy var galleryButton : UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let image = UIImage(systemName: "camera",withConfiguration: imageConfig)
        button.setImage(image , for: .normal)
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    func setUI(){
        view.addSubviews(mainLabel,popButton,profileLabel,profileImage,galleryButton)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        profileLabel.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints{
            $0.width.height.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileLabel.snp.bottom).offset(16)
        }
        galleryButton.snp.makeConstraints{
            $0.height.width.equalTo(40)
            $0.center.equalToSuperview()
        }
        
    }
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
}


//Preview code
#if DEBUG
import SwiftUI
struct EditprofileViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        EditprofileViewController()
    }
}
@available(iOS 13.0, *)
struct EditprofileViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                EditprofileViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
