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

class EditprofileViewController : UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let APInetwork = UserNetwork.shared
    
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
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileLabel : UILabel = {
        let label = UILabel()
        label.text = "사용하실 프로필을 설정해 주세요."
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imgPicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var profileImage : UIImageView = {
        let image = UIImageView()
        image.image = RegisterUserInfo.shared.profileImage
        image.clipsToBounds = true
        image.layer.cornerRadius = 75
        return image
    }()
    
    private lazy var galleryButton : UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let image = UIImage(named: "Camera")
        button.setImage(image , for: .normal)
        button.setImage(image , for: .highlighted)
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(galleryclick), for: .touchUpInside)
        return button
    }()
    
    var nickname : String = ""
    
    private lazy var nicknameTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = nickname
        textfield.backgroundColor = .white
        textfield.font = DesignSystemFont.Pretendard_Medium18.value
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
        button.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        
        button.layer.cornerRadius = 8
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold16.value
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
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
        imgPicker.delegate = self
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
    
    // MARK: - API
    private var selectedIMG : UIImage?
    private func registerProfile() {
        LoadingIndicator.showLoading()
        
        let fcmToken = KeyChain.read(key: "fcmToken") ?? ""
        
        if let inputNickname = nicknameTextfield.text, !inputNickname.isEmpty {
            nickname = inputNickname
        } else {
            nickname = UserDefaults.standard.string(forKey: "nickname") ?? "닉네임을 입력해주세요."
        }
        
        let requestProfile = Requestprofile(nickname: nickname, fcmToken: fcmToken)
        
        var imageData: Data?
        
        if let selectedImage = selectedIMG {
            imageData = selectedImage.jpegData(compressionQuality: 0.5)
            
        }else if let currentImage = profileImage.image {
            // 이미지를 선택하지 않았다면 현재 프로필 이미지를 사용
            imageData = currentImage.jpegData(compressionQuality: 0.5)
        }
        
        let registerData = profileRequest(request: requestProfile, image: imageData)
        
        APInetwork.postProfile(profileData: registerData) { result in
            switch result {
            case .success(let data):
                print("프로필 업로드 성공: \(data)")
                
                UserDefaults.standard.set(self.nickname, forKey: "nickname")
                
                if let selectedImage = self.selectedIMG {
                    RegisterUserInfo.shared.profileImage = selectedImage
                }
                
                self.showToast(message: "프로필 수정이 완료되었습니다.")
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                LoadingIndicator.hideLoading()
                
            case .failure(let error):
                LoadingIndicator.hideLoading()
                self.showToast(message: "프로필 수정에 실패하였습니다.")
                print("프로필 등록 실패: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func doneclick(){
        registerProfile()
    }
    
    @objc func galleryclick(){
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        let galleyAction = UIAlertAction(title: "앨범에서 선택", style: .default) {
            (action) in self.openGallery()
        }
        let removeAction = UIAlertAction(title: "프로필 사진 삭제", style: .destructive){
            (action) in self.deletephoto()
        }
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        alert.addAction(galleyAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Gallery Setting
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.profileImage.image = editedImage
                self.selectedIMG = editedImage
            }
        } else if info[UIImagePickerController.InfoKey.originalImage] is UIImage {
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(named: "profile")
                self.selectedIMG = nil
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func openGallery(){
        LoadingIndicator.showLoading()
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: true, completion: nil)
        LoadingIndicator.hideLoading()
    }
    
    func deletephoto(){
        profileImage.image = UIImage(named: "profile")
        selectedIMG = nil
    }
    
}


//MARK: - 키보드 세팅, textfield세팅

extension EditprofileViewController : UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    private func updateDoneButtonState(for text: String? = nil) {
        
        let textToCheck = text ?? nicknameTextfield.text ?? ""
        
        if textToCheck.isEmpty {
            doneButton.backgroundColor = DesignSystemColor.Gray300.value
        } else {
            doneButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
            doneButton.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
            
        }
    }
    
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
        updateDoneButtonState()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        updateDoneButtonState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 10
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        let isWithinLimit = newString.count <= maxLength
        
        if isWithinLimit {
            updateDoneButtonState(for: newString)
        }
        
        return isWithinLimit
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
