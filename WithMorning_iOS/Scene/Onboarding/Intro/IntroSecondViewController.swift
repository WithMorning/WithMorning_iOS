//
//  IntroSecondViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/16/24.
//

import Foundation
import UIKit
import SnapKit
import Then

class IntroSecondViewController : UIViewController {
    
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
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(nextbtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.backgroundColor = .clear
        return view
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
        view.addSubviews(popButton,skipButton,logoView,nextButton)
        
        popButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        skipButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(92)
        }
        logoView.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        
        
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        
    }
    
    //MARK: - objc func
    @objc func nextbtn(){
        let vc = IntroThridViewContoller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//Preview code
#if DEBUG
import SwiftUI
struct IntroSecondViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        IntroSecondViewController()
    }
}
@available(iOS 13.0, *)
struct IntroSecondViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                IntroSecondViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
