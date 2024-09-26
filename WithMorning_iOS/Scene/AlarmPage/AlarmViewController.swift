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
        label.textColor = .black
        return label
    }()
    
    private lazy var AMPMLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = .black
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium18.value
        return label
    }()
    
    //MARK: - 메세지

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 메시지 💬"
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var messagetextLabel : UILabel = {
        let label = UILabel()
        label.text = "나에게 불가능은 없다.\n나는 모든걸 실현할 수 있는 힘이 있다."
        label.font = DesignSystemFont.Pretendard_Medium16.value
        label.textColor = DesignSystemColor.Gray600.value
        label.numberOfLines = 0
        label.textAlignment = .center
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
        label.text = "알람끄기"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        setupUI()
        updateTimeAndDate()
    }
    
    func setupUI() {
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(AMPMLabel)
        
        view.addSubviews(timeStackView, dayLabel, messageLabel, messagetextLabel, turnoffButton)
        
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
    var groupId : Int = 0
    
    func Wakeup(){
        APInetwork.patchWakeup(groupId: groupId){ result in
            switch result{
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    

    
    //MARK: - @objc func
    @objc func turnoffalarm(){
        print("turnoff")
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
