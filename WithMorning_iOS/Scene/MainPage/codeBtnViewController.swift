//
//  codeBtnViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/29/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class codeBtnViewController: UIViewController {
    
    //MARK: - properties
    private lazy var codeLabel : UILabel = {
        let label = UILabel()
        label.text = "참여 코드 입력"
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var codeTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "코드를 입력해 주세요"
        textfield.backgroundColor = DesignSystemColor.Gray150.value
        textfield.font = DesignSystemFont.Pretendard_Medium14.value
        textfield.textColor = DesignSystemColor.Gray400.value
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .center
        return textfield
    }()
    
    private lazy var numberLabel : UILabel = {
        let label = UILabel()
        label.text = "전화번호 비공개"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var Button : UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var notiLabel : UILabel = {
        let label = UILabel()
        label.text = "전화번호 비공개 시 전화 대신 푸시 알림을 받게 됩니다."
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    private lazy var DoneButton : UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: -230, leading: 0, bottom: 10, trailing: 0) // 텍스트 위치 조정
        
        let titleTextAttributes = AttributeContainer([
            NSAttributedString.Key.font: DesignSystemFont.Pretendard_Bold16.value
        ])
        configuration.attributedTitle = AttributedString("메이트 함께하기", attributes: titleTextAttributes)
        
        let button = UIButton(configuration: configuration)
        
        button.addTarget(self, action: #selector(buttonclicked), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        SetUI()
        
    }
    //MARK: - SetUI

    func SetUI(){
        view.addSubviews(codeLabel,codeTextfield,numberLabel,notiLabel,DoneButton)
        
        codeLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        codeTextfield.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(codeLabel.snp.bottom).offset(10)
            $0.height.equalTo(52)
        }
        numberLabel.snp.makeConstraints{
            $0.top.equalTo(codeTextfield.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        notiLabel.snp.makeConstraints{
            $0.top.equalTo(numberLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        DoneButton.snp.makeConstraints{
            $0.top.equalTo(notiLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
            
        }
    }
//MARK: - @objc func
    @objc func buttonclicked(){
        self.dismiss(animated: true, completion: nil)
    }
    

    
}


//Preview code
#if DEBUG
import SwiftUI
struct codeBtnViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        codeBtnViewController()
    }
}
@available(iOS 13.0, *)
struct codeBtnViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                codeBtnViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
