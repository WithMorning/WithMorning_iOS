//
//  CertificateViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/23/24.
//

import UIKit
import Then
import SnapKit
import Alamofire



class CertificateViewController : UIViewController{
    
    let APInetwork = UserNetwork.shared
    var viewType: ViewType = .register
    
    //MARK: - properties
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var subLabel : UILabel = {
        let label = UILabel()
        label.text = "인증번호를 입력해주세요."
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    
    private lazy var numberTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "000000"
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
        textfield.textContentType = .oneTimeCode
        textfield.addTarget(self, action: #selector(editchange), for: .editingChanged)
        return textfield
    }()
    
    private lazy var timerLabel : UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemColor.Orange500.value
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.text = "3:00"
        return label
    }()
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = DesignSystemColor.Gray300.value
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold16.value
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(nextclick), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.isNavigationBarHidden = true
        setUI()
        mainLabelType()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getsetTime()
    }
    
    func setUI(){
        view.addSubviews(popButton,mainLabel,subLabel,numberTextfield,timerLabel,nextButton)
        
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
        timerLabel.snp.makeConstraints{
            $0.centerY.equalTo(numberTextfield)
            $0.trailing.equalTo(numberTextfield.snp.trailing).inset(24)
        }
        
        nextButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(numberTextfield.snp.bottom).offset(16)
            $0.height.equalTo(62)
        }
    }
    
    func mainLabelType(){
        switch viewType.self{
        case .changeNumber:
            mainLabel.text = "연락처 변경"
        case .register:
            mainLabel.text = "회원가입"
        }
        
    }
    
    //MARK: - API
    var phonenumber = ""
    var code = ""
    
    private func responseSMS(){
        LoadingIndicator.showLoading()
        
        let data = SMScodeResquest(phone: phonenumber, code: code)
        let vc = ProfileViewController()
        
        APInetwork.responseSMS(responsedata: data){ result in
            
            switch result{
            case .success(let data):
                print(data)
                LoadingIndicator.hideLoading()
                
                if self.viewType == .changeNumber{
                    self.navigateToMainViewController()
                    self.showToast(message: "인증번호가 확인되었습니다.")
                    
                }else{
                    UserDefaults.standard.set(false, forKey: "isFirstTime")
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.showToast(message: "인증번호가 확인되었습니다.")
                }
                
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    //MARK: - 타이머
    var limitTime : Int = 180
    
    func getsetTime(){
        secTotime(sec: limitTime)
        limitTime = limitTime - 1
    }
    
    func secTotime(sec : Int){
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":" + "0" + String(second)
        }else{
            timerLabel.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.getsetTime()
            }
        }
        
        if limitTime == 0{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - @objc func
    @objc func editchange(_ sender: Any){
        guard let txtfield = sender as? UITextField, let text = txtfield.text else {return}
        
        if text.count > 6{
            txtfield.deleteBackward()
            nextButton.backgroundColor = DesignSystemColor.Orange500.value
        }
        if text.count < 6{
            nextButton.backgroundColor = DesignSystemColor.Gray300.value
        }
        if text.count == 6{
            nextButton.backgroundColor = DesignSystemColor.Orange500.value
        }
        code = text
    }
    
    @objc func nextclick(){
        if nextButton.backgroundColor == DesignSystemColor.Orange500.value{
            responseSMS()
        }
    }
    
    //MARK: - 휴대폰 번호 변경 후 메인으로 루트 뷰컨을 변경
    func navigateToMainViewController() {
        let mainVC = MainViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            keyWindow.rootViewController = navController
            keyWindow.makeKeyAndVisible()
        }
    }
    
}


//MARK: - 키보드 세팅, textfield세팅
extension CertificateViewController : UITextFieldDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CertificateViewController.dismissKeyboard))
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
struct CertificateViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        CertificateViewController()
    }
}
@available(iOS 13.0, *)
struct CertificateViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                CertificateViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif

