//
//  ProfileViewController.swift.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/24/24.
//

import UIKit
import SnapKit
import Then
import Alamofire
import Kingfisher

class ProfileViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let APInetwork = UserNetwork.shared
    
    //MARK: - properties
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "회원가입"
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
        image.clipsToBounds = true
        image.layer.cornerRadius = 75
        return image
    }()
    
    private lazy var imgPicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
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
        textfield.placeholder = "닉네임을 입력해주세요 (최대 10자)"
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
    
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
    
    @objc func doneclick(){
        registerProfile()
    }
    
    @objc func galleryclick() {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
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
    
    // MARK: - API
    private func registerProfile() {
        guard let image = profileImage.image else {
            print("프로필 이미지를 선택하세요.")
            return
        }
        
        let fcmToken = KeyChain.read(key: "fcmToken") ?? ""
        
        guard let nickname = nicknameTextfield.text, !nickname.isEmpty else {
            print("닉네임을 입력해야 합니다.")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("이미지를 JPEG 데이터로 변환하는 데 실패했습니다.")
            return
        }
        
        // 5. 프로필 데이터 설정
        let requestProfile = Requestprofile(nickname: nickname, fcmToken: fcmToken)
        let registerData = profileRequest(request: requestProfile, image: imageData)

        // 6. 다음 화면 준비
        let vc = IntroViewController()

        // 7. API 호출
        APInetwork.postProfile(profileData: registerData) { result in
            LoadingIndicator.showLoading()
            switch result {
            case .success(_):
                UserDefaults.standard.set(nickname, forKey: "nickname")
                
                LoadingIndicator.hideLoading()
                
                self.showToast(message: "회원가입이 완료되었습니다.")
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print("프로필 등록 실패: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    //MARK: - Gallery Setting
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                DispatchQueue.main.async {
                    self.profileImage.image = editedImage
                }
        } else if info[UIImagePickerController.InfoKey.originalImage] is UIImage {
                // 만약 편집된 이미지가 존재하지 않으면 원본 이미지를 사용합니다.
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(named: "profile")
                }
            }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func openGallery(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: true, completion: nil)
    }
    
    func deletephoto(){
        profileImage.image = UIImage(named: "profile")
    }
    
}


//MARK: - 키보드 세팅, textfield세팅
extension ProfileViewController : UITextFieldDelegate {
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
        guard textField.text!.count < 10 else {
            self.showToast(message: "최대 10자까지 입력해 주세요.")
            return false } // 10 글자로 제한
        
        return true
    }
}


//Preview code
#if DEBUG
import SwiftUI
struct ProfileViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        ProfileViewController()
    }
}
@available(iOS 13.0, *)
struct aProfileViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                ProfileViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
