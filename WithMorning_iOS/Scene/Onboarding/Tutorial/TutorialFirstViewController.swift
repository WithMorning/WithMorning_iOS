//
//  TutorialFirstViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/25/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class TutorialFirstViewController : UIViewController {
    
    private lazy var tutorialLabel : UILabel = {
        let label = UILabel()
        label.text = "마지막으로 진동과 알람음을 설정해 볼까요?"
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    //MARK: - 알림음
    private lazy var soundView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(alarmsoundLabel,sliderImage,volumeSlider,sliderLabel,vibrateLabel,vibrateImage)
        return view
    }()
    
    private lazy var alarmsoundLabel : UILabel = {
        let label = UILabel()
        label.text = "볼륨"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - 알림음 슬라이더
    private lazy var sliderImage : UIImageView = {
        let img = UIImageView()
        img.tintColor = .black
        img.image = UIImage(named: "Volumeon")
        return img
    }()
    
    private lazy var volumeSlider : CustomSlider = {
        let slider = CustomSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.tintColor = DesignSystemColor.Orange500.value
        slider.isUserInteractionEnabled = true
        slider.thumbTintColor = .white
        slider.value = 50
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        return slider
    }()
    
    private lazy var sliderLabel : UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()

    private lazy var vibrateLabel : UILabel = {
        let label = UILabel()
        label.text = "진동"
        label.textAlignment = .right
        label.textColor = .black
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(vibratesetting))
        label.addGestureRecognizer(tapGestureRecognizer)
        return label
    }()
    
    private lazy var vibrateImage : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor = DesignSystemColor.Gray200.value
        
        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(alarmtitleLabel,alarm1Label,alarm1Image)
        return view
    }()
    
    private lazy var alarmtitleLabel : UILabel = {
        let label = UILabel()
        label.text = "알람음"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var alarm1Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 1"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm1Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        button.tintColor =  DesignSystemColor.Orange500.value
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUI()
    }
    
    func setUI(){
        view.addSubviews(tutorialLabel,soundView,alarmView)
        
        tutorialLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        soundView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(92)
        }
        alarmsoundLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        volumeSlider.snp.makeConstraints{
            $0.centerY.equalTo(vibrateImage)
            $0.leading.equalTo(sliderImage.snp.trailing).offset(4)
            $0.trailing.equalTo(sliderLabel.snp.leading).offset(-8)
        }
        
        vibrateLabel.snp.makeConstraints{
            $0.centerY.equalTo(vibrateImage)
            $0.trailing.equalTo(vibrateImage.snp.leading).offset(-4)
        }
        vibrateImage.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        sliderLabel.snp.makeConstraints{
            $0.centerY.equalTo(vibrateLabel)
            $0.trailing.equalTo(vibrateLabel.snp.leading).offset(-40)
        }
        sliderImage.snp.makeConstraints{
            $0.leading.bottom.equalToSuperview().inset(16)
        }
        
        alarmView.snp.makeConstraints{
            $0.top.equalTo(soundView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(332)
        }
        alarmtitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm1Label.snp.makeConstraints{
            $0.top.equalTo(alarmtitleLabel.snp.bottom).offset(19.5)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm1Image.snp.makeConstraints{
            $0.centerY.equalTo(alarm1Label)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc func sliderValueChanged(_ sender: CustomSlider){
        
        let roundedValue = roundf(sender.value / 10) * 10
        sender.value = roundedValue
        
        let value : Int = Int(sender.value)
        
        if value == 0 {
            sliderImage.image = UIImage(named: "Volumeoff")
            
        }else{
            sliderImage.image = UIImage(named: "Volumeon")
        }
        sliderLabel.text = "\(value)" + "%"
        
    }
    
    @objc func vibratesetting(){
        if vibrateImage.tintColor == DesignSystemColor.Gray200.value{
            vibrateImage.tintColor = DesignSystemColor.Orange500.value
        }else{
            vibrateImage.tintColor = DesignSystemColor.Gray200.value
        }
    }
    
    @objc func alarm1set(){
        self.showToast(message: "새로운 알람음이 업데이트 될 예정입니다 !")
    }
    
}
//Preview code
#if DEBUG
import SwiftUI
struct TutorialFirstViewControllerRepresentable: UIViewControllerRepresentable {

    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        TutorialFirstViewController()
    }
}
@available(iOS 13.0, *)
struct TutorialFirstViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                TutorialFirstViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }

    }
} #endif
