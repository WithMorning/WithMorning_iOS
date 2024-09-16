//
//  IntroFirstViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/16/24.
//

import Foundation
import UIKit
import SnapKit
import Then

class IntroFirstViewController : UIViewController {
    
    //MARK: - properties
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        //        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Medium16.value
        button.setTitleColor(DesignSystemColor.Gray400.value, for: .normal)
        //        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.text = "윗모닝은 어떤 알람으로도\n한번에 기상하기 힘든 사람들을 위한 앱이에요."
        label.font = DesignSystemFont.Pretendard_Medium16.value
        return label
    }()

    
    private lazy var introImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "intro1")
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - 다음 버튼
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(nextbtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "다음"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    //MARK: - auto layout
    func setUI(){
        view.addSubviews(popButton,skipButton,logoView,mainLabel,introImageView,nextButton)
        
        popButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        skipButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        logoView.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(24)
        }
        
        
        introImageView.snp.makeConstraints{
            $0.width.equalTo(257)
            $0.height.equalTo(280)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30) //수정 가능성 용이함ㅇㅇ
        }
        
        nextButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(92)
        }
        
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        
    }
    
    //MARK: - objc func
    @objc func nextbtn(){
        let vc = IntroSecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//Preview code
#if DEBUG
import SwiftUI
struct IntroFirstViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        IntroFirstViewController()
    }
}
@available(iOS 13.0, *)
struct IntroFirstViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                IntroFirstViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
