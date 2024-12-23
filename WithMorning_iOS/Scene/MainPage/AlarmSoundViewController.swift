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

class AlarmSoundViewController: UIViewController {
    
    var volume: ((Int) -> Void)?
    
    // 기본값 설정
    let defaultVolumeValue: Float = 50.0
    let defaultVibrateState: Bool = false
    
    // 임시 저장 변수
    var selectedVolume: Float = 50.0 // 기본값
    var isVibrateOn: Bool = false    // 기본값
    
    //MARK: - 네비게이션 바
    private lazy var MainLabel: UILabel = {
        let label = UILabel()
        label.text = "알람음 설정"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var popButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.addTarget(self, action: #selector(popclick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 알림음
    private lazy var soundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(alarmsoundLabel, sliderImage, volumeSlider, sliderLabel, vibrateLabel, vibrateImage)
        return view
    }()
    
    private lazy var alarmsoundLabel: UILabel = {
        let label = UILabel()
        label.text = "볼륨"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - 알림음 슬라이더
    private lazy var sliderImage: UIImageView = {
        let img = UIImageView()
        img.tintColor = .black
        img.image = UIImage(named: UserDefaults.standard.float(forKey: "volume", default: defaultVolumeValue) == 0 ? "Volumeoff" : "Volumeon")
        return img
    }()
    
    private lazy var volumeSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.tintColor = DesignSystemColor.Orange500.value
        slider.thumbTintColor = .white
        slider.value = UserDefaults.standard.float(forKey: "volume", default: defaultVolumeValue)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var sliderLabel: UILabel = {
        let volumeValue = UserDefaults.standard.float(forKey: "volume", default: defaultVolumeValue)
        let label = UILabel()
        label.text = "\(Int(volumeValue))%"
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var vibrateLabel: UILabel = {
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
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(vibratesetting), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 알람 선택
    private lazy var alarmView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(alarmtitleLabel,alarm1Label,alarm1Image,alarm2Label,alarm2Image,alarm3Label,alarm3Image,alarm4Label,alarm4Image,alarm5Label,alarm5Image,alarm6Label,alarm6Image,alarm7Label,alarm7Image)
        return view
    }()
    
    private lazy var alarmtitleLabel : UILabel = {
        let label = UILabel()
        label.text = "알람음"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        return label
    }()
    
    //MARK: - 알람음 선택
    private lazy var alarm1Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 1"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm1Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxorange"), for: .normal)
        button.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm2Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 2"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm2Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm3Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 3"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm3Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm4Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 4"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm4Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm5Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 5"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm5Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm6Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 6"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm6Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarm7Label : UILabel = {
        let label = UILabel()
        label.text = "알람벨 7"
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var alarm7Image: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(alarm1set), for: .touchUpInside)
        return button
    }()
    
    private lazy var DoneButton: UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.addTarget(self, action: #selector(doneclick), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        
        // UserDefaults에서 초기값 불러오기
        selectedVolume = UserDefaults.standard.float(forKey: "volume", default: defaultVolumeValue)
        isVibrateOn = UserDefaults.standard.bool(forKey: "vibrate", default: defaultVibrateState)
        
        setUI()
        popGesture()
    }
    
    func setUI() {
        view.addSubviews(MainLabel, popButton, soundView, alarmView, DoneButton)
        
        MainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints {
            $0.centerY.equalTo(MainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        
        soundView.snp.makeConstraints {
            $0.top.equalTo(MainLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(92)
        }
        alarmsoundLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        volumeSlider.snp.makeConstraints {
            $0.centerY.equalTo(vibrateImage)
            $0.leading.equalTo(sliderImage.snp.trailing).offset(4)
            $0.trailing.equalTo(sliderLabel.snp.leading).offset(-8)
        }
        
        vibrateLabel.snp.makeConstraints {
            $0.centerY.equalTo(vibrateImage)
            $0.trailing.equalTo(vibrateImage.snp.leading).offset(-4)
        }
        vibrateImage.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        sliderLabel.snp.makeConstraints {
            $0.centerY.equalTo(vibrateLabel)
            $0.trailing.equalTo(vibrateLabel.snp.leading).offset(-40)
        }
        sliderImage.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(16)
        }
        
        alarmView.snp.makeConstraints {
            $0.top.equalTo(soundView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(332)
        }
        alarmtitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        //MARK: - 알람음 선택
        alarm1Label.snp.makeConstraints{
            $0.top.equalTo(alarmtitleLabel.snp.bottom).offset(19.5)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm1Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm1Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm2Label.snp.makeConstraints{
            $0.top.equalTo(alarm1Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm2Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm2Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm3Label.snp.makeConstraints{
            $0.top.equalTo(alarm2Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm3Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm3Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm4Label.snp.makeConstraints{
            $0.top.equalTo(alarm3Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm4Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm4Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm5Label.snp.makeConstraints{
            $0.top.equalTo(alarm4Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm5Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm5Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm6Label.snp.makeConstraints{
            $0.top.equalTo(alarm5Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm6Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm6Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        alarm7Label.snp.makeConstraints{
            $0.top.equalTo(alarm6Label.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(16)
        }
        alarm7Image.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(alarm7Label)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        
        
        DoneButton.snp.makeConstraints {
            $0.height.equalTo(92)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        buttonLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    @objc func popclick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sliderValueChanged(_ sender: CustomSlider) {
        let roundedValue = roundf(sender.value / 10) * 10
        sender.value = roundedValue
        
        let value: Int = Int(sender.value)
        
        if value == 0 {
            sliderImage.image = UIImage(named: "Volumeoff")
        } else {
            sliderImage.image = UIImage(named: "Volumeon")
        }
        
        sliderLabel.text = "\(value)%"
        
        // 임시 변수에 저장 (UserDefaults X)
        selectedVolume = sender.value
    }
    
    @objc func vibratesetting() {
        if vibrateImage.currentImage == UIImage(named: "checkboxorange") {
            vibrateImage.setImage(UIImage(named: "checkboxgray"), for: .normal)
            vibrateImage.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        } else {
            vibrateImage.setImage(UIImage(named: "checkboxorange"), for: .normal)
            vibrateImage.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        }
    }
    
    @objc func alarm1set(){
        self.showToast(message: "새로운 알람음이 업데이트 될 예정입니다 !")
    }
    
    @objc func doneclick() {
        // 최종적으로 doneclick 호출 시 UserDefaults에 저장
        UserDefaults.standard.set(selectedVolume, forKey: "volume") //볼륨
        UserDefaults.standard.set(isVibrateOn, forKey: "vibrate") //진동
        
        print("설정이 저장되었습니다 - 볼륨: \(selectedVolume), 진동: \(isVibrateOn)")
        self.navigationController?.popViewController(animated: true)
    }
}

extension AlarmSoundViewController: UIGestureRecognizerDelegate {
    func popGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

//Preview code
#if DEBUG
import SwiftUI
struct AlarmSoundViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
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
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            } else {
                // Fallback on earlier versions
            }
        }
    }
} #endif
