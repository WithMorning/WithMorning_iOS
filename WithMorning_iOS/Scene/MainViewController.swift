//
//  MainViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MainViewController: UIViewController {

//MARK: - properties
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "HI, 율무엄마"
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = DesignSystemColor.fontBlack.value
        return label
    }()
    
    private lazy var settingButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.settingGray.value
        button.setTitle("설정", for: .normal)
        button.titleLabel?.font =  DesignSystemFont.Pretendard_Bold12.value
        button.setTitleColor(DesignSystemColor.fontBlack.value, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(clickedSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.mainColor.value
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitle("  새로운 알람설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        button.addTarget(self, action: #selector(clickedmakeAlarm), for: .touchUpInside)
        

        
        return button
    }()
    
    private lazy var codeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("참여 코드 입력", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitleColor(DesignSystemColor.fontBlack.value, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "codebutton"), for: .normal)
        
        button.addTarget(self, action: #selector(clickedcode), for: .touchUpInside)
        
        return button
    }()
    


//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.backgroundColor.value
        SetUI()

    }
//MARK: - UI

    func SetUI(){
        view.addSubviews(nameLabel,settingButton,alarmButton,codeButton)
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            $0.leading.equalToSuperview().inset(16)
        }
        settingButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(45)
            $0.height.equalTo(30)
        }
        alarmButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(nameLabel.snp.bottom).offset(27)
            $0.height.equalTo(56)
        }
        codeButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(alarmButton.snp.bottom).offset(8)
            $0.height.equalTo(56)
        }
    }

//MARK: - objc func
    
    @objc func clickedSetting(){
        print("세팅버튼 : 아왜요 시2ㅏ발")
    }
    @objc func clickedmakeAlarm(){
        print("알람생성버튼 : 아왜불러")
    }
    @objc func clickedcode(){
        print("참여코드버튼 : 아왜요")
    }

}



#if DEBUG
import SwiftUI
struct Preview3: UIViewControllerRepresentable {
    
    // 여기 ViewController를 변경해주세요
    func makeUIViewController(context: Context) -> UIViewController {
        MainViewController()
    }
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
}

struct ViewController_PreviewProvider3: PreviewProvider {
    static var previews: some View {
        Group {
            Preview3()
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Preview")
        }
    }
}
#endif
