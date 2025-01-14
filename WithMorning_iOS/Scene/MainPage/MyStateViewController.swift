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
    
    private lazy var NumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.addSubviews(NumLabel,NumButton)
        return stackView
    }()
    
    private lazy var NumLabel : UILabel = {
        let label = UILabel()
        label.text = "전화번호 비공개"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var NumButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(numButtonclick), for: .touchUpInside)
        return button
    }()
    
    lazy var subLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    //MARK: - 완료버튼
    private lazy var DoneButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.setBackgroundColor(DesignSystemColor.Black.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Black.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - UI
    
    func SetUI(){
        view.addSubviews(userImage,nicknameLabel,NumStackView,subLabel,DoneButton)
        
        userImage.snp.makeConstraints{
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        nicknameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userImage.snp.bottom).offset(16)
        }
        NumStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(122)
            $0.height.equalTo(24)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16)
        }
        NumLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        NumButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(NumStackView.snp.bottom).offset(10)
        }
        
        DoneButton.snp.makeConstraints{
            $0.top.equalTo(subLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    //MARK: - 유저 상태
    var userphoneNum: String = ""
    var imageURL : String?
    var userId : Int = 0
    var groupId : Int = 0
    var isagree : Bool = false
    let mainVC = MainViewController()
    
    func configureUserState(){
        
        print("isagree",isagree as Any)
        print("닉네임",nicknameLabel.text as Any)
        print("유저아이디",userId)
        print("이미지 url", imageURL as Any)
        print("groupId", groupId as Any)
        
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
        
        let fullText: String
        let targetText: String
        let color = DesignSystemColor.Orange500.value // 강조할 텍스트의 색상
        
        if isagree{
            fullText = "이 그룹에서는 친구에게 전화를 받아요."
            targetText = "전화"
            NumButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            NumButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        } else {
            fullText = "이 그룹에서는 친구에게 푸시 알림을 받아요."
            targetText = "푸시 알림"
            NumButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            NumButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        }
        
        //텍스트 부분 강조
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        subLabel.attributedText = attributedString
    }
    
    //MARK: - API
    var reloadisagree : (()->Void)? = nil
    
    func editphoneagree(completion: @escaping () -> Void) {
        LoadingIndicator.showLoading()
        
        let editphoneData = EditphoneMaindata(isAgree: isagree)
        
        APInetwork.patchphoneagree(groupId: self.groupId, editphoneagree: editphoneData) { result in
            switch result {
            case .success(let data):
                print("전화번호 공개 상태 변경 성공: \(data)")
                completion() // 상태 변경 후 메시지 호출
                LoadingIndicator.hideLoading()
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
                completion() // 오류 발생 시에도 메시지 호출
                LoadingIndicator.hideLoading()
                self.showToast(message: "오류가 발생했습니다.")
            }
        }
    }
    
    
    //MARK: - @objc func
    @objc func numButtonclick() {
        isagree.toggle() // isagree 값을 반전

        // 상태에 따라 버튼 이미지 및 메시지 설정
        let imageName = isagree ? "checkboxgray" : "checkboxorange"
        let message = isagree ? "전화번호를 공개합니다." : "전화번호를 비공개합니다."
        self.NumButton.setImage(UIImage(named: imageName), for: .normal)
        self.NumButton.setImage(UIImage(named: imageName), for: .highlighted)
        self.showToast(message: message)

        self.configureUserState() // UI 업데이트
        editphoneagree {} // API 호출
    }
    
    
    @objc func doneclick() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.reloadisagree?()
        }
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
