//
//  AlarmSoundViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/5/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class AlarmSoundViewController : UIViewController {
    
    var volume :  ((Int)->Void)?
    
    //MARK: - 네비게이션 바
    private lazy var MainLabel : UILabel = {
        let label = UILabel()
        label.text = "알람음 설정"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclick), for: .touchUpInside)
        return button
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
        return view
    }()
    
    private lazy var DoneButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = DesignSystemColor.Orange500.value
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
        popGesture()
    }
    
    func setUI(){
        view.addSubviews(MainLabel,popButton,soundView,alarmView,DoneButton)
        
        MainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(MainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        soundView.snp.makeConstraints{
            $0.top.equalTo(MainLabel.snp.bottom).offset(20)
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
        DoneButton.snp.makeConstraints{
            $0.height.equalTo(92)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
    }
    
    @objc func popclick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sliderValueChanged(_ sender: CustomSlider){
        let roundedValue = roundf(sender.value / 10) * 10
        sender.value = roundedValue
        
        let value : Int = Int(sender.value)
        
        if value == 0 {
            sliderImage.image = UIImage(named: "Volumeoff")
            volume?(value)
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
    
    @objc func doneclick(){
        self.dismiss(animated: true)
    }
    
}

extension AlarmSoundViewController : UIGestureRecognizerDelegate{
    func popGesture(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

//Preview code
#if DEBUG
import SwiftUI
struct AlarmSoundViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        AlarmSoundViewController()
    }
}
@available(iOS 13.0, *)
struct AlarmSoundViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                AlarmSoundViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
