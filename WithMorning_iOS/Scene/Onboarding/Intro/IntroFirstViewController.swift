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
    
    private lazy var logoView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.applyDesignFont(.Pretendard_Medium16, text: "윗모닝은 어떤 알람으로도\n한번에 기상하기 힘든 사람들을 위한 앱이에요.",color: .black)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - intro이미지
    private lazy var introView : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray150.value
        view.addSubview(introImageView)
        return view
    }()

    private lazy var introImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "intro1")
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    //MARK: - auto layout
    func setUI(){
        view.addSubviews(logoView,mainLabel,introView)
        
        logoView.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(36)
        }
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(24)
        }
        
        introView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        introImageView.snp.makeConstraints{
            $0.width.equalTo(257)
            $0.height.equalTo(280)
            $0.center.equalToSuperview()
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
