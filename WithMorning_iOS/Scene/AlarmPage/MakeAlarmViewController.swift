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

class MakeAlarmViewController : UIViewController, UIScrollViewDelegate, UISheetPresentationControllerDelegate {
    
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
        scrollview.addSubview(contentView)
        scrollview.isScrollEnabled = true
        scrollview.delegate = self
        scrollview.showsVerticalScrollIndicator = false
        
        return scrollview
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.addSubviews(timerView,soundView,groupView,memoView)
        return view
    }()
    
    //MARK: - 알람 설정 뷰
    private lazy var timerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(timePicker,bar1,alarmViewStackView)
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
    
    //MARK: - 반복 요일 스택뷰
    private lazy var alarmViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(repeatLabel,repeatDayLabel)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(repeatDay))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
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
        let attributedString1 = NSMutableAttributedString(string: "없음   ")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(systemName: "greaterthan")
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 10, height: 16)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    //MARK: - 알림음
    private lazy var soundView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(SoundViewStackView,bar2,sliderImage,volumeSlider,sliderLabel,vibrateLabel,vibrateImage)
        return view
    }()
    
    private lazy var bar2 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    
    //MARK: - 알림음 스택뷰
    private lazy var SoundViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.addSubviews(alarmsoundLabel,alarmsoundLabel2)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(soundsetting))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    
    private lazy var alarmsoundLabel : UILabel = {
        let label = UILabel()
        label.text = "알림음"
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var alarmsoundLabel2 : UILabel = {
        let attributedString1 = NSMutableAttributedString(string: "기본   ")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(systemName: "greaterthan")
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 10, height: 16)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
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
    
    
    //MARK: - 진동 버튼
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
    
    //MARK: - 모임명
    private lazy var groupView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(groupLabel,groupTextfield)
        return view
    }()
    
    private lazy var groupLabel : UILabel = {
        let label = UILabel()
        label.text = "모임명"
        label.textColor = .black
        label.font = DesignSystemFont.Pretendard_Bold14.value
        return label
    }()
    
    private lazy var groupTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "윗모닝 모임명을 적어주세요."
        textfield.backgroundColor = DesignSystemColor.Gray150.value
        textfield.font = DesignSystemFont.Pretendard_Medium14.value
        textfield.textColor = .black
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .center
        
        //텍스트 필드 교정 메서드
        textfield.autocorrectionType = .no
        textfield.spellCheckingType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    
    //MARK: - 메모
    private lazy var memoView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(memoLabel,memoTextfield)
        return view
    }()
    
    private lazy var memoLabel : UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textColor = .black
        label.font = DesignSystemFont.Pretendard_Bold14.value
        return label
    }()
    
    private lazy var memoTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = " 아침에 하고 싶은 말 또는 패널티를 정해주세요."
        textfield.backgroundColor = DesignSystemColor.Gray150.value
        textfield.font = DesignSystemFont.Pretendard_Medium14.value
        textfield.textColor = .black
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .left
        
        //텍스트 필드 교정 메서드
        textfield.autocorrectionType = .no
        textfield.spellCheckingType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    
    //MARK: - 저장 버튼
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.addTarget(self, action: #selector(saveclicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "다음"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        hideKeyboardWhenTappedAround()
        setUpKeyboard()
    }
    
    
    func SetUI(){
        groupTextfield.delegate = self
        memoTextfield.delegate = self
        
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
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(alarmScrollVeiw.contentLayoutGuide)
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
            
        }
        timePicker.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(83)
            $0.height.equalTo(120)
        }
        bar1.snp.makeConstraints{
            $0.top.equalTo(timePicker.snp.bottom).offset(16)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        alarmViewStackView.snp.makeConstraints{
            $0.top.equalTo(bar1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        repeatLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        repeatDayLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        soundView.snp.makeConstraints{
            $0.top.equalTo(timerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
        }
        SoundViewStackView.snp.makeConstraints{
            $0.center.equalToSuperview().multipliedBy(0.5)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        bar2.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        alarmsoundLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        alarmsoundLabel2.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        sliderImage.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(vibrateImage)
        }
        volumeSlider.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(sliderImage.snp.trailing).offset(4)
            $0.width.equalTo(160)
        }
        sliderLabel.snp.makeConstraints{
            $0.centerY.equalTo(sliderImage)
            $0.leading.equalTo(volumeSlider.snp.trailing).offset(8)
        }
        vibrateLabel.snp.makeConstraints{
            $0.trailing.equalTo(vibrateImage.snp.leading).offset(-4)
            $0.bottom.equalToSuperview().inset(18)
        }
        vibrateImage.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(vibrateLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        groupView.snp.makeConstraints{
            $0.top.equalTo(soundView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
        }
        groupLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(16)
        }
        groupTextfield.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(52)
        }
        
        memoView.snp.makeConstraints{
            $0.top.equalTo(groupView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
            $0.bottom.equalToSuperview().inset(30)
        }
        memoLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(16)
        }
        memoTextfield.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(52)
        }
        
        saveButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(92)
        }
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
    }
    //MARK: - @objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func repeatDay(){
        let vc = WeekChoiceViewController()
        self.present(vc, animated: true)
        
        let height = view.bounds.height * 0.65
        
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { context in
                    
                    return height //고정
                }]
                
                sheet.delegate = self
                sheet.prefersGrabberVisible = false
                sheet.preferredCornerRadius = 16
            }
        }
    }
    
    @objc func soundsetting(){
        print("알림설정")
    }
    
    @objc func vibratesetting(){
        if vibrateImage.tintColor == DesignSystemColor.Gray200.value{
            vibrateImage.tintColor = DesignSystemColor.Orange500.value
        }else{
            vibrateImage.tintColor = DesignSystemColor.Gray200.value
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
    @objc func saveclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - 키보드 세팅, textfield세팅
extension MakeAlarmViewController : UITextFieldDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MakeAlarmViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DesignSystemColor.Orange500.value.cgColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        
    }
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

//MARK: - 슬라이더 두께 조절
class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // 원하는 두께로 조절하세요. 여기서는 10으로 설정했습니다.
        let customTrackRect = CGRect(
            x: 0,
            y: bounds.origin.y + bounds.size.height/2 - 3,
            width: bounds.width,
            height: 6
        )
        super.trackRect(forBounds: customTrackRect)
        return customTrackRect
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

