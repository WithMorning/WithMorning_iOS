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
        button.addTarget(self, action: #selector(galleryclick), for: .touchUpInside)
        return button
    }()
    
    private lazy var nicknameTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "일이삼사오육칠팔구십"
        textfield.backgroundColor = .white
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
    
    private lazy var doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.layer.cornerRadius = 8
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold16.value
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
        hideKeyboardWhenTappedAround()
        popGesture()
    }
    
    func setUI(){
        nicknameTextfield.delegate = self
        
        view.addSubviews(mainLabel,popButton,profileLabel,profileImage,galleryButton,nicknameTextfield,doneButton)
        
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
            $0.bottom.equalTo(profileImage)
            $0.centerX.equalTo(profileImage).offset(55)
        }
        nicknameTextfield.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(65)
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(nicknameTextfield.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(62)
        }
        
    }
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
    @objc func doneclick(){
        
    }
    
    @objc func galleryclick(){
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "앨범에서 선택", style: .default, handler: nil)
        
        let removeAction = UIAlertAction(title: "프로필 사진 삭제", style: .destructive, handler: nil)
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - 키보드 세팅, textfield세팅

extension EditprofileViewController : UITextFieldDelegate,UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditprofileViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DesignSystemColor.Orange500.value.cgColor
        doneButton.backgroundColor = DesignSystemColor.Gray300.value
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        doneButton.backgroundColor = DesignSystemColor.Orange500.value
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 10 else { return false } // 10 글자로 제한
        return true
    }
    
    func popGesture(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
