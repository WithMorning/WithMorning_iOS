//
//  AlterUIView.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/1/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

let APInetwork = Network.shared
let USERnetwork = UserNetwork.shared

//MARK: - 취소,확인을 위한 델리게이트
protocol AlterDelegate {
    func confirm()
    func cancel()
}

//MARK: - 알림창의 타입을 위한 enum
enum Altertype {
    case deleteAlarm
    case outGroup
    case quit
}

class AlterUIView: UIViewController {
    
    var alterType : Altertype
    var delegate : AlterDelegate?
    
    
    var confirmAction: (() -> Void)?
    
    
    init(alterType: Altertype) {
        self.alterType = alterType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var AlterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubviews(MainLabel, SubLabel, confirmButton, cancelButton)
        return view
    }()
    
    private lazy var MainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_SemiBold16.value
        return label
    }()
    
    private lazy var SubLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DesignSystemColor.Gray600.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // 원하는 행간 간격을 설정
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(string: "삭제시 모든 메이트의 알람이 삭제처리됩니다. \n미리 전달해 주세요.",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = DesignSystemColor.Gray200.value
        button.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
        button.addTarget(self, action: #selector(cancelclicked), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirmclicked), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        SetUI()
        types()
    }
    
    //MARK: - UI
    
    func SetUI() {
        view.addSubview(AlterView)
        
        AlterView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(190)
            $0.width.equalTo(343)
        }
        
        SubLabel.snp.makeConstraints{
            $0.top.equalTo(MainLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(52)
            $0.width.equalTo(146)
            
        }
        
        confirmButton.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(52)
            $0.width.equalTo(146)
            
        }
    }
    
    func types() {
        switch alterType {
            
        case .deleteAlarm:
            MainLabel.text = "해당 알람을 삭제하시겠습니까?"
            
            MainLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(20)
                $0.centerX.equalToSuperview()
            }
            
        case .outGroup:
            MainLabel.text = "해당 모임에서 나가시겠습니까?"
            SubLabel.isHidden = true
            MainLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(44)
                $0.centerX.equalToSuperview()
            }
            
        case .quit:
            MainLabel.text = "정말 윗모닝을 탈퇴하시겠습니까? 🥲"
            SubLabel.text = "탈퇴시 모든 개인정보는 바로 삭제 처리됩니다."
            
            AlterView.snp.makeConstraints{
                $0.center.equalToSuperview()
                $0.height.equalTo(170)
                $0.width.equalTo(343)
            }
            
            MainLabel.snp.makeConstraints{
                $0.top.equalToSuperview().inset(20)
                $0.centerX.equalToSuperview()
            }
            SubLabel.snp.makeConstraints{
                $0.centerX.equalToSuperview().offset(12)
                
            }
        }
    }
    //MARK: - objc func
    //취소클릭
    @objc func cancelclicked(){
        self.dismiss(animated: true) {
            self.delegate?.cancel()
            print("취소버튼")
        }
    }
    
    //확인클릭
    @objc func confirmclicked() {
        switch alterType {
        case .deleteAlarm:
            handleDeleteAlarm()
        case .outGroup:
            handleOutGroup()
        case .quit:
            handleQuit()
        }
        
        self.dismiss(animated: true) {
            self.delegate?.confirm()
            
            switch self.alterType {
                
            case .deleteAlarm:
                self.deleteAlarm()
            case .outGroup:
                self.leaveAlarm()
            case .quit:
                self.quitaccount()
                break
            }
        }
    }
    
    //MARK: - API handling
    
    private func handleDeleteAlarm() {
        print("알람 삭제 로직 실행")
        
    }
    
    private func handleOutGroup() {
        print("모임 나가기 로직 실행")

    }
    
    private func handleQuit() {
        print("윗모닝 탈퇴 로직 실행")
        
    }
    
    //MARK: - 알람 삭제를 위한 groupId
    var groupId : Int?
    
    //MARK: - 알람삭제 API
    private func deleteAlarm(){
        LoadingIndicator.showLoading()
        
        guard let groupId = groupId else{return}
        APInetwork.deleteGroup(groupId: groupId){ result in
            switch result {
            case.success(let data):
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.confirmAction?()
                    }
                    print(data)
                    print("알람 삭제 성공")
                }
                LoadingIndicator.hideLoading()
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print("알람 삭제 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // 에러 메시지를 사용자에게 표시
                    let alert = UIAlertController(title: "오류", message: "알람 삭제에 실패했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    //MARK: - 그룹 나가기
    private func leaveAlarm(){
        LoadingIndicator.showLoading()
        guard let groupId = groupId else{return}
        APInetwork.deleteleaveGroup(groupId: groupId){ result in
            
            switch result{
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.confirmAction?()
                    }
                    print(data)
                }
                LoadingIndicator.hideLoading()
            case .failure(let error):
                print("알람 나가기 실패: \(error.localizedDescription)")
                LoadingIndicator.hideLoading()
            }
        }
        
    }
    
    //MARK: - 회원 탈퇴
    func quitaccount(){
        LoadingIndicator.showLoading()
        USERnetwork.deleteaccount(){ result in
           
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.navigateToLoginViewController()
                }
                
                func deleteAccount() {
                    KeyChain.delete(key: "accessToken")
                    KeyChain.delete(key: "refreshToken")
                    RegisterUserInfo.shared.loginState = .logout
                    KeyChain.delete(key: "fcmToken")
                }

                
                UserDefaults.standard.removeObject(forKey: "isFirstTime")
                UserDefaults.standard.removeObject(forKey: "nickname")
                UserDefaults.standard.removeObject(forKey: "volume")
                UserDefaults.standard.removeObject(forKey: "vibrate")
                UserDefaults.standard.removeObject(forKey: "isRegistered")
                
                LoadingIndicator.hideLoading()
                
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
                LoadingIndicator.hideLoading()
            }
            
        }
    }
    
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




