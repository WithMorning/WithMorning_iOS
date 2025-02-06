//
//  RegisterViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/20/24.
//

import UIKit
import Then
import SnapKit
import JSPhoneFormat
import Firebase

enum ViewType {
    case changeNumber
    case register
}

class RegisterViewController : UIViewController{
    let APInetwork = UserNetwork.shared
    var viewType: ViewType = .register
    
    //MARK: - properties
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var subLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    //휴대폰번호 포멧
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")
    
    private lazy var numberTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "000 - 0000 - 0000"
        textfield.backgroundColor = .white
        textfield.font = DesignSystemFont.Pretendard_Medium18.value
        textfield.textColor = .black
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .center
        textfield.tintColor = DesignSystemColor.Orange500.value
        
        //텍스트 필드 교정 메서드
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.spellCheckingType = .no
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .numberPad
        textfield.addTarget(self, action: #selector(editchange), for: .editingChanged)
        return textfield
    }()
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = DesignSystemColor.Gray300.value
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold16.value
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(nextclick), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.isNavigationBarHidden = true
        setUI()
        mainLabelType()
        hideKeyboardWhenTappedAround()
    }
    
    func setUI(){
        view.addSubviews(popButton,mainLabel,subLabel,numberTextfield,nextButton)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        subLabel.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
        }
        numberTextfield.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.height.equalTo(65)
        }
        nextButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(numberTextfield.snp.bottom).offset(16)
            $0.height.equalTo(62)
        }
    }
    
    //MARK: - 회원가입, 연락처 변경
    func mainLabelType(){
        switch viewType.self{
        case .changeNumber:
            mainLabel.text = "연락처 변경"
            subLabel.text = "변경할 휴대폰 번호를 입력해 주세요."
            popButton.isHidden = false
        case .register:
            mainLabel.text = "회원가입"
            subLabel.text = "가입할 휴대폰 번호를 입력해 주세요."
            popButton.isHidden = true
        }
        
    }
    
    
    //MARK: - API
    var phonenumber = ""
    
    private func requestSMS(){
        LoadingIndicator.showLoading()
        let data = SMSnumRequest(phone: phonenumber)
        let vc = CertificateViewController()
        
        APInetwork.requestSMS(phoneNumber: data){result in
            switch result{
            case .success(let data):
                print(data)
                vc.phonenumber = self.phonenumber
                LoadingIndicator.hideLoading()
                self.showToast(message: "인증번호를 전송했습니다.")
                
                //회원가입, 연락처 변경 구분
                if self.viewType == .changeNumber{
                    vc.viewType = .changeNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                LoadingIndicator.hideLoading()
                self.showToast(message: "인증번호 전송에 실패했습니다.")
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    
    //MARK: - @objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editchange(_ sender: Any){
        guard let txtfield = sender as? UITextField, let text = txtfield.text else {return}
        
        txtfield.text = phoneFormat.addCharacter(at: text)
        
        if text.count > 13{
            txtfield.deleteBackward()
            nextButton.backgroundColor = DesignSystemColor.Orange500.value
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .highlighted)
        }
        if text.count < 13{
            nextButton.backgroundColor = DesignSystemColor.Gray300.value
        }
        
        if text.count == 13{
            nextButton.backgroundColor = DesignSystemColor.Orange500.value
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        }
        
        let phoneNumberWithoutDash = text.replacingOccurrences(of: "-", with: "")
        
        phonenumber = phoneNumberWithoutDash
        print("Phone number without dash: \(phonenumber)")
        
    }
    
    @objc func nextclick() {
        if numberTextfield.text?.count == 13 {
            requestSMS()
        } else {
            self.showToast(message: "전화번호를 입력해주세요.")
        }
    }
    
}


//MARK: - 키보드 세팅, textfield세팅
extension RegisterViewController : UITextFieldDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DesignSystemColor.Orange500.value.cgColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        
    }
}




//Preview code
#if DEBUG
import SwiftUI
struct RegisterViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        RegisterViewController()
    }
}
@available(iOS 13.0, *)
struct OnBoardingRegisterViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                RegisterViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
