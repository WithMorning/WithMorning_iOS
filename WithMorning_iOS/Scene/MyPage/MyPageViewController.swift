//
//  MyPageViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 5/8/24.
//

import UIKit
import SnapKit
import Then
import Alamofire
import Kingfisher
import WebKit
import MessageUI

enum WebUrl: String{
    case privacy = "https://withmorning-2024.tistory.com/2"
    case perm = "https://withmorning-2024.tistory.com/1"
    
}

class MyPageViewController : UIViewController, UIScrollViewDelegate {
    
    let APInetwork = Network.shared
    let USERnetwork = UserNetwork.shared
    //    let registerUserInfo = RegisterUserInfo.shared
    
    //MARK: - 네비게이션
    
    private lazy var myPageLabel : UILabel = {
        let label = UILabel()
        label.text = "마이 페이지"
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
    
    private lazy var mypageScrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.addSubview(contentView)
        scrollview.isScrollEnabled = true
        scrollview.delegate = self
        scrollview.showsVerticalScrollIndicator = false
        return scrollview
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.addSubviews(profileImage,nickNameLabel,editProfileButton,ContectButton,topView,middleView,bottomView,logoutButton,bar1,quitButton)
        return view
    }()
    
    //MARK: - profile
    
    private lazy var profileImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.tintColor = .black
        return image
    }()
    
    private lazy var nickNameLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold18.value
        label.tintColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editProfileButton : UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setBackgroundColor(DesignSystemColor.Gray200.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Gray200.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.setTitleColor(DesignSystemColor.Gray600.value, for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(editprofile), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var ContectButton : UIButton = {
        let button = UIButton()
        button.setTitle("연락처 변경", for: .normal)
        
        button.setBackgroundColor(DesignSystemColor.Gray200.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Gray200.value.adjustBrightness(by: 0.8), for: .highlighted)
        
        button.setTitleColor(DesignSystemColor.Gray600.value, for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.addTarget(self, action: #selector(changephone), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        return button
    }()
    
    //MARK: - topView
    
    private lazy var topView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(sleeptimeStackView,pushnotiStackView)
        return view
    }()
    
    //MARK: - 취침 시간 알림
    private lazy var sleeptimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(sleeptimeLabel,sleeptimeLabel2,sleeptimeLabel3)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sleeptime))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var sleeptimeLabel : UILabel = {
        let label = UILabel()
        label.text = "취침 시간 알림"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var sleeptimeLabel3 : UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()

    private lazy var sleeptimeLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    //MARK: - 푸시 알림 설정
    private lazy var pushnotiStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(pushnotiLabel,pushnotiLabel2)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushnoti))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var pushnotiLabel : UILabel = {
        let label = UILabel()
        label.text = "푸시 알림 설정"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pushnotiLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    
    
    //MARK: - middleView
    private lazy var middleView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(noticeStackView,serviceStackView,privacyStackView)
        return view
    }()
    
    //MARK: - 공지사항
    private lazy var noticeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(noticeLabel,noticeLabel2)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notice))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var noticeLabel : UILabel = {
        let label = UILabel()
        label.text = "공지사항"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var noticeLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    //MARK: - 이용약관
    private lazy var serviceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(serviceLabel,serviceLabel2)
        stackView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(permTappedAction))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var serviceLabel : UILabel = {
        let label = UILabel()
        label.text = "이용약관"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var serviceLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    //MARK: - 개인정보 처리방침
    private lazy var privacyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(privacyLabel,privacyLabel2)
        stackView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyTappedAction))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var privacyLabel : UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리방침"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var privacyLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    //MARK: - bottomView
    private lazy var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(inquiryStackView,versionStackView)
        return view
    }()
    
    //MARK: - 문의하기
    private lazy var inquiryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(inquiryLabel,inquiryLabel2)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsButtonTapped))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var inquiryLabel : UILabel = {
        let label = UILabel()
        label.text = "문의하기"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var inquiryLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -4, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    //MARK: - 버전 정보
    private lazy var versionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(versionLabel,versionLabel2)
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private lazy var versionLabel : UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var versionLabel2 : UILabel = {
        let label = UILabel()
        label.text = "1.0.0"
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var logoutButton : UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Medium14.value
        button.setTitleColor(DesignSystemColor.Gray400.value, for: .normal)
        button.addTarget(self, action: #selector(logoutclick), for: .touchUpInside)
        return button
    }()
    
    private lazy var bar1 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var quitButton : UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Medium14.value
        button.setTitleColor(DesignSystemColor.Gray400.value, for: .normal)
        button.addTarget(self, action: #selector(quitclick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        popGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypage()
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    //MARK: - Autolayout
    
    func SetUI(){
        view.addSubviews(myPageLabel,popButton,mypageScrollView)
        
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        
        myPageLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(myPageLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(mypageScrollView.contentLayoutGuide)
        }
        
        mypageScrollView.snp.makeConstraints{
            $0.top.equalTo(myPageLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImage.snp.makeConstraints{
            $0.height.equalTo(profileImage.snp.width)
            $0.centerY.equalTo(editProfileButton.snp.top) //여기
            $0.trailing.equalTo(editProfileButton.snp.leading).offset(-16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nickNameLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(45.5)
            $0.leading.equalTo(editProfileButton.snp.leading)
            $0.trailing.equalTo(ContectButton.snp.trailing)
        }
        
        //MARK: - 버튼 두개
        editProfileButton.snp.makeConstraints{
            $0.trailing.equalTo(ContectButton.snp.leading).offset(-6)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(16)
            $0.height.equalTo(44)
            $0.width.equalTo(ContectButton.snp.width)
        }
        
        ContectButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(16)
            $0.height.equalTo(44)
            $0.width.equalTo(view.bounds.width/360*97)
        }
        
        topView.snp.makeConstraints{
            $0.top.equalTo(editProfileButton.snp.bottom).offset(37.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
            $0.width.equalTo(mypageScrollView.frameLayoutGuide)
        }
        sleeptimeStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        sleeptimeLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        sleeptimeLabel2.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        sleeptimeLabel3.snp.makeConstraints{
            $0.centerY.equalTo(sleeptimeLabel)
            $0.trailing.equalTo(sleeptimeLabel2.snp.leading).offset(-8)
        }
        
        pushnotiStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(sleeptimeStackView.snp.bottom).offset(20)
            $0.height.equalTo(24)
        }
        pushnotiLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        pushnotiLabel2.snp.makeConstraints{
            $0.trailing.equalToSuperview()
        }
        
        
        middleView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(152)
        }
        noticeStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        noticeLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        noticeLabel2.snp.makeConstraints{
            $0.trailing.equalToSuperview()
        }
        serviceStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(noticeStackView.snp.bottom).offset(20)
            $0.height.equalTo(24)
        }
        serviceLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        serviceLabel2.snp.makeConstraints{
            $0.trailing.equalToSuperview()
        }
        privacyStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(serviceStackView.snp.bottom).offset(20)
            $0.height.equalTo(24)
        }
        privacyLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        privacyLabel2.snp.makeConstraints{
            $0.trailing.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints{
            $0.top.equalTo(middleView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        inquiryStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        inquiryLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        inquiryLabel2.snp.makeConstraints{
            $0.trailing.equalToSuperview()
        }
        versionStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(inquiryStackView.snp.bottom).offset(20)
            $0.height.equalTo(24)
        }
        versionLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        versionLabel2.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        bar1.snp.makeConstraints{
            $0.width.equalTo(1)
            $0.height.equalTo(12)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomView.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().offset(-30)
        }
        logoutButton.snp.makeConstraints{
            $0.centerY.equalTo(bar1)
            $0.trailing.equalTo(bar1.snp.leading).offset(-16)
            $0.bottom.equalToSuperview().offset(-30)
        }
        quitButton.snp.makeConstraints{
            $0.centerY.equalTo(bar1)
            $0.leading.equalTo(bar1.snp.trailing).offset(16)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    //MARK: - objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editprofile(){
        LoadingIndicator.showLoading()
        let vc = EditprofileViewController()
        vc.nickname = self.nickname
        self.navigationController?.pushViewController(vc, animated: true)
        LoadingIndicator.hideLoading()
    }
    
    //취침시간
    @objc func sleeptime(){
        let vc = SleepTimeViewController()
        vc.selectedTime24 = self.bedtime
        vc.selectedDayOfWeek = self.dayOfWeekList
        vc.allowAlarm = self.noti
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //연락처 변경
    @objc func changephone(){
        let vc = RegisterViewController()
        vc.viewType = .changeNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - 설정으로 이동
    @objc func pushnoti(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @objc func notice(){
        if let url = URL(string: "https://www.instagram.com/with_morning.io/#") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    //MARK: - 이용약관
    @objc func permTappedAction(_ sender: UITapGestureRecognizer){
        let webViewVC = MypageWebViewController()
        webViewVC.url = .perm
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    //MARK: - 개인정보처리방침
    @objc func privacyTappedAction(_ sender: UITapGestureRecognizer){
        let webViewVC = MypageWebViewController()
        webViewVC.url = .privacy
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    //MARK: - 문의하기
    @objc func commentsButtonTapped(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                             이곳에 내용을 작성해주세요.
                             
                             오타 발견 문의 시 아래 양식에 맞춰 작성해주세요.
                             
                             <예시>
                             글귀 ID : 글귀 4 (글귀 클릭 시 상단에 표시)
                             수정 전 : 실수해도 되.
                             수정 후 : 실수해도 돼.
                             
                             -------------------
                             
                             Device Model : \(self.getDeviceIdentifier())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(self.getCurrentVersion())
                             
                             -------------------
                             """
            
            composeViewController.setToRecipients(["wit.morning12@gmail.com"])
            composeViewController.setSubject("<윗모닝> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - 로그아웃
    @objc func logoutclick(){
        logout()
    }
    
    //MARK: - 회원 탈퇴
    @objc func quitclick(){
        let alterVC = AlterUIView(alterType: .quit)
        alterVC.modalPresentationStyle = .overFullScreen
        alterVC.modalTransitionStyle = .crossDissolve
        present(alterVC, animated: true, completion: nil)
    }
    
    //MARK: - API
    var bedtime : String = ""
    var dayOfWeekList : [String] = []
    var noti : Bool = false
    var nickname : String = ""
    
    func getMypage(){
        LoadingIndicator.showLoading()
        APInetwork.getMypage(){ result in
            switch result{
            case.success(let mypage):
                
                self.nickNameLabel.text = mypage.nickname ?? "nickname"
                self.updateSleepTimeLabel(with: mypage.bedtime ?? "", dayOfWeekList: mypage.dayOfWeekList ?? [], bedtimeAlarm: mypage.isAllowBedTimeAlarm ?? false)
                self.bedtime = mypage.bedtime ?? ""
                self.dayOfWeekList = mypage.dayOfWeekList ?? []
                self.noti = mypage.isAllowBedTimeAlarm ?? false
                self.nickname = mypage.nickname ?? "nickname"
                
                if ((mypage.imageURL?.isEmpty) != nil) {
                    // 이미지 URL이 유효한 경우: 이미지 다운로드 처리
                    let url = URL(string: mypage.imageURL ?? "")
                    let placeholderImage = UIImage(named: "profile")
                    let processor = RoundCornerImageProcessor(cornerRadius: 29)
                    
                    self.profileImage.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
                    
                } else {
                    // imageURL이 nil 이거나 빈 문자열일 경우 기본 이미지 설정
                    self.profileImage.image = UIImage(named: "profile") // 기본 이미지로 설정
                }
                RegisterUserInfo.shared.profileImage = self.profileImage.image
                LoadingIndicator.hideLoading()
            case.failure(let error):
                LoadingIndicator.hideLoading()
                print(error)
            }
        }
    }
    
    //MARK: - 로그아웃
    func logout(){
        LoadingIndicator.showLoading()
        let refreshtoken = deletelogoutRequest(refreshToken: KeyChain.read(key: "refreshToken") ?? "")
        USERnetwork.deletelogout(refreshToken: refreshtoken){ result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.navigateToLoginViewController()
                    KeyChain.delete(key: "accessToken")
                    KeyChain.delete(key: "refreshToken")
                    UserDefaults.standard.set(true, forKey: "isExistingUser")
                    UserDefaults.setUserState("logout")
                    
                    NotificationCenter.default.post(name: NSNotification.Name("UserStateChanged"), object: nil)
                }
                LoadingIndicator.hideLoading()
                print(data)
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    //MARK: - 시간 형식 수정
    func updateSleepTimeLabel(with bedtime: String, dayOfWeekList: [String], bedtimeAlarm : Bool) {
        print(dayOfWeekList)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: bedtime) {
            dateFormatter.dateFormat = "hh:mm a"
            let formattedTime = dateFormatter.string(from: date)
            
            let weekdaysSet: Set = ["mon", "tue", "wed", "thu", "fri"]
            let weekendSet: Set = ["sat", "sun"]
            let allDaysSet: Set = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
            let dayOfWeekSet = Set(dayOfWeekList)
            
            // 한글로 요일 변환을 위한 딕셔너리
            let dayOfWeekDict: [String: String] = [
                "mon": "월", "tue": "화", "wed": "수", "thu": "목", "fri": "금",
                "sat": "토", "sun": "일"
            ]
            if bedtimeAlarm {
                if dayOfWeekSet.isEmpty {
                    sleeptimeLabel3.text = "\(formattedTime) 없음"
                } else if dayOfWeekSet == allDaysSet {
                    sleeptimeLabel3.text = "\(formattedTime) 매일"
                } else if weekdaysSet.isSubset(of: dayOfWeekSet) && dayOfWeekSet.intersection(weekendSet).isEmpty {
                    sleeptimeLabel3.text = "\(formattedTime) 평일"
                } else if dayOfWeekSet.isSubset(of: weekendSet) {
                    sleeptimeLabel3.text = "\(formattedTime) 주말"
                } else {
                    let koreanDays = dayOfWeekList.compactMap { dayOfWeekDict[$0] }.joined(separator: ", ")
                    sleeptimeLabel3.text = "\(formattedTime) \(koreanDays)"
                }
            } else {
                if dayOfWeekSet.isEmpty {
                    sleeptimeLabel3.text = "OFF"
                } else if dayOfWeekSet == allDaysSet {
                    sleeptimeLabel3.text = "OFF"
                } else if weekdaysSet.isSubset(of: dayOfWeekSet) && dayOfWeekSet.intersection(weekendSet).isEmpty {
                    sleeptimeLabel3.text = "OFF"
                } else if dayOfWeekSet.isSubset(of: weekendSet) {
                    sleeptimeLabel3.text = "OFF"
                } else {
                    let koreanDays = dayOfWeekList.compactMap { dayOfWeekDict[$0] }.joined(separator: ", ")
                    sleeptimeLabel3.text = "OFF"
                }
            }
        }
    }
    
    //MARK: - 모든 뷰가 사라지고 로그아웃, 탈퇴 시 이동
    func navigateToLoginViewController() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            keyWindow.rootViewController = navController
            keyWindow.makeKeyAndVisible()
        }
    }
}

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - extension

extension MyPageViewController : UIGestureRecognizerDelegate{
    
    func popGesture(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

//Preview code
#if DEBUG
import SwiftUI
struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        MyPageViewController()
    }
}
@available(iOS 13.0, *)
struct MyPageViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                MyPageViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 12pro"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
