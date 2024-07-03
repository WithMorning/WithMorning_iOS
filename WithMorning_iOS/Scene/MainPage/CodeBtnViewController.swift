//
//  CodeBtnViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/29/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class CodeBtnViewController: UIViewController {
    
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
        textfield.textColor = .black
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .center
        
        //텍스트 필드 교정 메서드
        textfield.autocorrectionType = .no
        textfield.spellCheckingType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    private lazy var numberLabel : UILabel = {
        let label = UILabel()
        label.text = "전화번호 비공개"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(numberclicked))
        label.addGestureRecognizer(tapGestureRecognizer)
        
        return label
    }()
    
    private lazy var openButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = DesignSystemColor.Gray200.value
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(numberclicked), for: .touchUpInside)
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
        configuration.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 0, bottom: 40, trailing: 0) // 텍스트 위치 조정
        
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
        hideKeyboardWhenTappedAround()
        
        
    }
    //MARK: - SetUI
    
    func SetUI(){
        
        codeTextfield.delegate = self
        
        view.addSubviews(codeLabel,codeTextfield,numberLabel,openButton,notiLabel,DoneButton)
        
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
            $0.centerX.equalToSuperview().offset(-13)
        }
        
        openButton.snp.makeConstraints{
            $0.width.height.equalTo(25)
            $0.centerY.equalTo(numberLabel)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(5)
        }
        
        notiLabel.snp.makeConstraints{
            $0.top.equalTo(numberLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        DoneButton.snp.makeConstraints{
            $0.top.equalTo(notiLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
            
        }
    }
    //MARK: - @objc func
    @objc func buttonclicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func numberclicked(){
        if openButton.tintColor == DesignSystemColor.Gray200.value{
            openButton.tintColor = DesignSystemColor.Orange500.value
        }else{
            openButton.tintColor = DesignSystemColor.Gray200.value
        }
    }
}

//MARK: - 키보드 내리기
extension CodeBtnViewController : UITextFieldDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CodeBtnViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - textField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        textField.becomeFirstResponder()
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DesignSystemColor.Orange500.value.cgColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        textField.resignFirstResponder()
        textField.layer.borderWidth = 0
        
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
        CodeBtnViewController()
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
