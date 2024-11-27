//
//  AlarmViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/25/24.
//

import UIKit
import SnapKit
import Alamofire
import Then

class AlarmViewController: UIViewController {
    
    let APInetwork = Network.shared
    
    //MARK: - 스택뷰
    private lazy var backgroundView : UIImageView = {
        let view = UIImageView()
        view.addSubviews(timeStackView, dayLabel, messageLabel, messagetextLabel)
        return view
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold70.value
        label.textColor = .white
        return label
    }()
    
    private lazy var AMPMLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = .white
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium18.value
        label.textColor = .white
        return label
    }()
    
    //MARK: - 메세지
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 메시지 💬"
        label.font = DesignSystemFont.Pretendard_Bold16.value
        label.textColor = .white
        return label
    }()
    
    lazy var messagetextLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    //MARK: - 저장 버튼
    private lazy var turnoffButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(turnoffalarm), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "알람 끄기"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setRandomBackgroundImage()
        setupUI()
        updateTimeAndDate()
        alarmMessage()
    }
    
    func setupUI() {
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveGroupId(_:)), name: Notification.Name("PassGroupId"), object: nil)
        
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(AMPMLabel)
        
        view.addSubviews(backgroundView, turnoffButton)
        
        timeStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        timeLabel.snp.makeConstraints{
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview()
        }
        AMPMLabel.snp.makeConstraints{
            $0.bottom.equalTo(timeLabel.snp.bottom)
            $0.height.equalTo(35)
        }
        
        
        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timeStackView.snp.bottom).offset(16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayLabel.snp.bottom).offset(100)
        }
        messagetextLabel.snp.makeConstraints{
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            
        }
        turnoffButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(62)
            $0.bottom.equalToSuperview().inset(100)
        }
        buttonLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - 랜덤 배경화면
    func setRandomBackgroundImage() {
        let randomImageNumber = Int.random(in: 1...9)
        backgroundView.image = UIImage(named: "alarmIMG\(randomImageNumber)")
    }
    
    //MARK: - 오늘의 메시지 랜덤
    func alarmMessage(){
        let textArray = ["당신의 가능성은 무한해요! 믿고 도전해보세요!","실패는 끝이 아니에요. 새로운 시작이니 계속 나아가요!","작은 한 걸음이 큰 변화를 만들어요. 오늘부터 시작해보세요!","당신은 이미 충분히 훌륭한 사람이에요. 자신감을 가져요!","어제의 당신과 비교하면 오늘의 당신이 더 나아졌어요!","성공은 준비된 사람에게 찾아와요. 항상 준비해 두세요!","당신의 꿈은 당신이 만든 현실이에요. 꿈꾸고 행동해보세요!","매일 조금씩 성장하는 당신을 느껴보세요. 그게 진짜 성공이에요.","당신의 감정을 존중해 주세요. 당신의 목소리는 정말 중요해요!","당신은 당신의 이야기를 쓸 수 있는 작가예요. 원하는 대로 만들어가세요!","어려운 순간이 와도 그게 당신을 더 강하게 만들어줄 거예요.","자신에게 친절해져요. 당신은 당신의 가장 큰 지지자예요.","당신의 한 마디가 누군가의 하루를 밝힐 수 있어요. 긍정적으로 말해보세요!","과거는 지나갔어요. 지금부터 시작하세요!","당신의 열정이 당신을 이끌 거예요. 그 열정을 따라가세요!","변화는 두려운 게 아니에요. 새로운 기회니까요!","당신의 강점을 찾아서 최대한 활용해보세요.","오늘이 당신의 인생을 바꿀 수 있는 날이에요. 행동해보세요!","당신이 할 수 있다고 믿는 그 순간이 시작이에요.","작은 성취도 큰 의미가 있어요. 매일매일 자신을 격려하세요!","당신의 노력은 결코 헛되지 않아요. 성과는 반드시 따라올 거예요.","당신의 한계를 넘어서는 게 진짜 성장이에요. 도전해보세요!","당신은 혼자가 아니에요. 주변의 지지에 감사하세요!","당신의 가치와 가능성을 스스로 인정해요!","인생은 한 번뿐이에요. 후회 없는 선택을 하세요!","어떤 일이든 시작하는 게 가장 중요해요. 지금 시작해보세요!","당신의 꿈을 향해 나아가는 여정이 소중해요. 즐겨보세요!","긍정적인 에너지가 당신의 길을 밝힐 거예요!","자신을 믿고, 당신의 길을 가세요! 당신은 할 수 있어요!"]
        
        let randomMessage = textArray.randomElement() ?? "성공은 준비된 사람에게 찾아와요. 항상 준비해 두세요!"
        
        messagetextLabel.applyDesignFont(.Pretendard_Medium14, text: randomMessage, color: .white)
        messagetextLabel.numberOfLines = 0
        messagetextLabel.textAlignment = .center
    }
    
    func updateTimeAndDate() {
        let date = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        // 시간 업데이트
        dateFormatter.dateFormat = "h:mm"
        timeLabel.text = dateFormatter.string(from: date)
        
        // AM/PM 업데이트
        AMPMLabel.text = calendar.component(.hour, from: date) < 12 ? "AM" : "PM"
        
        // 날짜 업데이트
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dayLabel.text = dateFormatter.string(from: date)
        
    }
    
    //MARK: - 일어나기 API
    func Wakeup(groupId: String){
        LoadingIndicator.showLoading()
        print("🚀 API 호출 전 groupId: \(groupId)")
        APInetwork.patchWakeup(groupId: Int(groupId) ?? 0){ result in
            switch result{
            case .success(let data):
                LoadingIndicator.hideLoading()
                print(data)
                UserDefaults.standard.removeObject(forKey: "groupId")
            case .failure(let error):
                print(error.localizedDescription)
                UserDefaults.standard.removeObject(forKey: "groupId")
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    
    //MARK: - @objc func
    @objc func turnoffalarm() {
        // UserDefaults에서 groupId를 가져오기
        guard let groupId = UserDefaults.standard.string(forKey: "groupId") else {
            print("❌ 저장된 groupId가 없습니다.")
            return
        }
        Wakeup(groupId: groupId)
        mainViewController()
    }

    
    func mainViewController() {
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


//Preview code
#if DEBUG
import SwiftUI
struct AlarmViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        AlarmViewController()
    }
}
@available(iOS 13.0, *)
struct AlarmViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                AlarmViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
