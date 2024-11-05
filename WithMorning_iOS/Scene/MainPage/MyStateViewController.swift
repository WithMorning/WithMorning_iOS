//
//  MyStateViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 11/5/24.
//
import UIKit
import SnapKit
import Then
import Alamofire
import Kingfisher

class MyStateViewController : UIViewController{
    
    var userphoneNum: String = ""
    var isagree : Bool?
    var imageURL : String?
    
    var APInetwork = Network.shared
    
    //MARK: - 유저 정보
    lazy var userImage : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.backgroundColor = .gray
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nicknameLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = DesignSystemFont.Pretendard_Bold18.value
        label.textColor = .black
        return label
    }()
    
    lazy var subLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    lazy var opencallButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitle("전화번호 공개", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "phone"), for: .normal)
        button.addTarget(self, action: #selector(callclick), for: .touchUpInside)
        return button
    }()
    
    lazy var closecallButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitle("전화번호 비공개", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "pick"), for: .normal)
        button.addTarget(self, action: #selector(callclick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 완료버튼
    private lazy var DoneButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .white
        SetUI()
        configureUserState()
    }
    
    func SetUI(){
        view.addSubviews(userImage,nicknameLabel,subLabel,opencallButton,closecallButton,DoneButton)
        
        userImage.snp.makeConstraints{
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        nicknameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userImage.snp.bottom).offset(16)
        }
        subLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        }
        opencallButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(view.snp.centerX).offset(-4)
        }
        closecallButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(view.snp.centerX).offset(4)
        }
        
        DoneButton.snp.makeConstraints{
            $0.top.equalTo(closecallButton.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    //MARK: - API
    var userId : Int = 0
    
    func editphoneagree(){
        LoadingIndicator.showLoading()
        APInetwork.patchphoneagree(groupId: self.userId){ result in
            switch result{
            case .success(let data):
                LoadingIndicator.hideLoading()
                print(data)
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print(error.localizedDescription)
            }
            
        }
    }

    
    
    func configureUserState(){
        print("isagree",isagree as Any)
        print("닉네임",nicknameLabel.text as Any)
        print("유저아이디",userId)
        print("이미지 url", imageURL as Any)
        
        
        // 유저 이미지 설정
        if let imageURLString = imageURL, !imageURLString.isEmpty, let url = URL(string: imageURLString) {
            // Kingfisher를 사용하여 이미지 다운로드 및 둥근 모서리 적용 처리
            let placeholderImage = UIImage(named: "profile")
            let processor = RoundCornerImageProcessor(cornerRadius: 50) // 둥근 모서리
            
            // Kingfisher 이미지 설정
            userImage.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)]) {
                result in
                switch result {
                case .success(let value):
                    print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                case .failure( _):
                    self.userImage.image = placeholderImage
                }
            }
        } else {
            // imageURL이 nil이거나 빈 문자열일 경우 기본 이미지 설정
            userImage.image = UIImage(named: "profile")
        }
        
        
        //전화번호 공개 비공개
        if isagree == true{
            subLabel.text = "전화번호를 공개한 그룹입니다."
            closecallButton.backgroundColor = DesignSystemColor.Gray300.value
        }else{
            subLabel.text = "전화번호를 공개한 그룹입니다."
            opencallButton.backgroundColor = DesignSystemColor.Gray300.value
        }
        
        
        
    }
    
    
    //MARK: - @objc func
    @objc func callclick() {
        editphoneagree()
    }
    
    
    
    @objc func doneclick(){
        self.dismiss(animated: true)
    }
    
    
}





//Preview code
#if DEBUG
import SwiftUI
struct MyStateViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        MyStateViewController()
    }
}
@available(iOS 13.0, *)
struct MyStateViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                MyStateViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
