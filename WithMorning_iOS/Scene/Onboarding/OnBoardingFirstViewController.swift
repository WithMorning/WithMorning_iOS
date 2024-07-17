//
//  OnBoardingFirstViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/17/24.
//

import UIKit
import Then
import SnapKit

class OnBoardingFirstViewController: UIViewController{

    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "서비스 이용 동의"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var view1 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(ageLabel,agecheckButton,serviceLabel,serviceButton,infoLabel,infoButton,maketingLabel,maketingButton)
        return view
    }()
    
    //MARK: - (필수) 만 14세입니다.
    private lazy var ageLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 만 14세입니다."
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var agecheckButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
//        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    //MARK: - (필수) 서비스 이용 약관
    private lazy var serviceLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 서비스 이용 약관"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var serviceButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
//        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    //MARK: - (필수) 개인정보 처리방침
    private lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 개인정보 처리방침"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var infoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
//        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    //MARK: - (선택) 마케팅 정보 수신 동의
    private lazy var maketingLabel : UILabel = {
        let label = UILabel()
        label.text = "(선택) 마케팅 정보 수신 동의"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var maketingButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
//        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var view2 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews()
        return view
    }()
    
    //MARK: - 저장 버튼
    private lazy var nextButton : UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = DesignSystemColor.Orange500.value
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 0, bottom: 40, trailing: 0) // 텍스트 위치 조정
        
        let titleTextAttributes = AttributeContainer([
            NSAttributedString.Key.font: DesignSystemFont.Pretendard_Bold16.value
        ])
        configuration.attributedTitle = AttributedString("다음", attributes: titleTextAttributes)
        
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    func setUI(){
        view.addSubviews(mainLabel,nextButton,view1,view2)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        view1.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(204)
        }
        ageLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        agecheckButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(ageLabel)
        }
        serviceLabel.snp.makeConstraints{
            $0.top.equalTo(ageLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        serviceButton.snp.makeConstraints{
            $0.centerY.equalTo(serviceLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(serviceLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        infoButton.snp.makeConstraints{
            $0.centerY.equalTo(infoLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        maketingLabel.snp.makeConstraints{
            $0.top.equalTo(infoLabel.snp.bottom)
            .offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        maketingButton.snp.makeConstraints{
            $0.centerY.equalTo(maketingLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        view2.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top).inset(-16)
            $0.height.equalTo(95)
        }
        
        nextButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(92)
        }
    }
}
//Preview code
#if DEBUG
import SwiftUI
struct OnBoardingFirstViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        OnBoardingFirstViewController()
    }
}
@available(iOS 13.0, *)
struct OnBoardingFirstViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                OnBoardingFirstViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif

