//
//  TutorialThirdViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/25/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class TutorialThirdViewController : UIViewController {
    
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
        return view
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
    
}
