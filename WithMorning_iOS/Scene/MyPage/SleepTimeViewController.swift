//
//  SleepTimeViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/14/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class SleepTimeViewController : UIViewController, UISheetPresentationControllerDelegate {
    
    //MARK: - properties
    
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "취침 시간 알림"
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
    
    //MARK: - baseView
    private lazy var baseView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(timePicker,bar1,repeatLabel,repeatDayLabel)
        return view
    }()
    
    private lazy var timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .clear
        return picker
    }()
    
    private lazy var bar1 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var repeatLabel : UILabel = {
        let label = UILabel()
        label.text = "반복 요일"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var repeatDayLabel : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "평일   ")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(systemName: "greaterthan")
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 10, height: 16)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(repeatDay))
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    
    //MARK: - baseView2
    private lazy var baseView2 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(notiLabel,notiImage)
        return view
    }()
    
    private lazy var notiLabel : UILabel = {
        let label = UILabel()
        label.text = "알림 받기"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var notiImage : UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
        button.addTarget(self, action: #selector(notisetting), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
    }
    //MARK: - setUI
    
    func SetUI(){
        view.addSubviews(mainLabel,popButton,baseView,baseView2)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        baseView.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(208)
        }
        timePicker.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(120)
            $0.width.equalTo(177)
        }
        bar1.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.top.equalTo(timePicker.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        repeatLabel.snp.makeConstraints{
            $0.top.equalTo(bar1.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        repeatDayLabel.snp.makeConstraints{
            $0.top.equalTo(bar1.snp.bottom).offset(18)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        
        baseView2.snp.makeConstraints{
            $0.top.equalTo(baseView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        notiLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        notiImage.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
    }
    
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
    
    @objc func repeatDay(){
        let vc = WeekChoiceViewController()
        self.present(vc, animated: true)
        
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { context in
                    return 472 //고정
                }]
                
                sheet.delegate = self
                sheet.prefersGrabberVisible = false
                sheet.preferredCornerRadius = 16
            }
        }
    }
    
    @objc func notisetting(){
        if notiImage.tintColor == DesignSystemColor.Gray200.value{
            notiImage.tintColor = DesignSystemColor.Orange500.value
        }else{
            notiImage.tintColor = DesignSystemColor.Gray200.value
        }
    }
    
}

//Preview code
#if DEBUG
import SwiftUI
struct SleepTimeViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        SleepTimeViewController()
    }
}
@available(iOS 13.0, *)
struct SleepTimeViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                SleepTimeViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
