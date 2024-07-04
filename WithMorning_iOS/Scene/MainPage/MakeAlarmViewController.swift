//
//  MakeAlarmViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/22/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MakeAlarmViewController : UIViewController, UIScrollViewDelegate {
    
    //MARK: - 네비게이션 바
    private lazy var MainLabel : UILabel = {
        let label = UILabel()
        label.text = "알람 생성"
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
    //MARK: - 스크롤 뷰
    private lazy var alarmScrollVeiw : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.addSubviews(timerView,soundView,groupView,memoView)
        scrollview.isScrollEnabled = true
        scrollview.backgroundColor = .gray
        scrollview.delegate = self
        return scrollview
    }()
    
    //MARK: - 알람 설정 뷰
    private lazy var timerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(timePicker,bar1,alarmStackView)
        return view
    }()
    
    private lazy var bar1 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .clear
        return picker
    }()
    
    private lazy var alarmStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    //MARK: - 알림음
    private lazy var soundView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        //        view.addSubviews()
        return view
    }()
    //MARK: - 모임명
    private lazy var groupView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        //        view.addSubviews()
        return view
    }()
    //MARK: - 메모
    private lazy var memoView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        //        view.addSubviews()
        return view
    }()
    
    //MARK: - 저장 버튼
    
    private lazy var saveButton : UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = DesignSystemColor.Orange500.value
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 0, bottom: 40, trailing: 0) // 텍스트 위치 조정
        
        let titleTextAttributes = AttributeContainer([
            NSAttributedString.Key.font: DesignSystemFont.Pretendard_Bold16.value
        ])
        configuration.attributedTitle = AttributedString("저장", attributes: titleTextAttributes)
        
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        saveButton.isHidden = true
    }
    
    func SetUI(){
        view.addSubviews(MainLabel,popButton,alarmScrollVeiw,saveButton)
        
        MainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(MainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        alarmScrollVeiw.snp.makeConstraints{
            $0.top.equalTo(MainLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(saveButton.snp.top)
            
        }
        
        
        timerView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(208)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
        }
        timePicker.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(83)
            $0.height.equalTo(100)
        }
        bar1.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        soundView.snp.makeConstraints{
            $0.top.equalTo(timerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
        }
        
        groupView.snp.makeConstraints{
            $0.top.equalTo(soundView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
        }
        
        memoView.snp.makeConstraints{
            $0.top.equalTo(groupView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
        }
        
        saveButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
    }
    //MARK: - @objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//Preview code
#if DEBUG
import SwiftUI
struct MakeAlarmViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        MakeAlarmViewController()
    }
}
@available(iOS 13.0, *)
struct MakeAlarmViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                MakeAlarmViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif

