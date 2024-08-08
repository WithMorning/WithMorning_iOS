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

class MakeAlarmViewController : UIViewController, UIScrollViewDelegate, UISheetPresentationControllerDelegate{
    
    
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
        view.addSubviews(timerView,groupView,memoView)
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
    
    private lazy var timePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .clear
        picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return picker
    }()
    
    var hour = Array(1...12)
    var min = Array(0...59)
    var AMPM = ["AM","PM"]
    
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
        textfield.attributedPlaceholder = NSAttributedString(string: "윗모닝 모임명을 적어주세요.", attributes: [NSAttributedString.Key.foregroundColor : DesignSystemColor.Gray400.value])
        textfield.tintColor = DesignSystemColor.Orange500.value
        textfield.backgroundColor = DesignSystemColor.Gray150.value
        textfield.font = DesignSystemFont.Pretendard_Medium14.value
        textfield.textColor = .black
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .left
        textfield.addleftPadding()
        
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
        view.addSubviews(memoLabel,memoTextView)
        return view
    }()
    
    private lazy var memoLabel : UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textColor = .black
        label.font = DesignSystemFont.Pretendard_Bold14.value
        return label
    }()
    
    private lazy var memoPlaceholder : UILabel = {
        let label = UILabel()
        label.text = "아침에 하고 싶은 말 또는 패널티를 정해주세요."
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray400.value
        return label
    }()
    
    
    private lazy var memoTextView : UITextView = {
        let view = UITextView()
        view.backgroundColor = DesignSystemColor.Gray150.value
        view.font = DesignSystemFont.Pretendard_Medium14.value
        view.textAlignment = .left
        view.textColor = .black
        view.layer.cornerRadius = 8
        view.tintColor = DesignSystemColor.Orange500.value
        
        view.textContainerInset = UIEdgeInsets(top: 16, left: 13, bottom: 0, right: 0)
        
        view.addSubview(memoPlaceholder)
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.autocapitalizationType = .none
        view.textContainer.maximumNumberOfLines = 3
        
        return view
    }()
    
    private lazy var notiLabel : UILabel = {
        let label = UILabel()
        label.text = "📢 알람음 설정은 메인홈 상단에서 할 수 있어요"
        label.textAlignment = .center
        label.textColor = DesignSystemColor.Gray500.value
        label.font = DesignSystemFont.Pretendard_Medium12.value
        return label
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
        label.text = "저장"
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
        setCurrentTimeOnPicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerviewUI()
    }
    
    //MARK: - Autolayout
    
    func SetUI(){
        groupTextfield.delegate = self
        memoTextView.delegate = self
        
        view.addSubviews(MainLabel,popButton,alarmScrollVeiw,notiLabel,saveButton)
        
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
            $0.top.equalToSuperview()
            $0.bottom.equalTo(bar1.snp.top)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        bar1.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.bottom.equalTo(alarmViewStackView.snp.top).offset(-16)
        }
        
        alarmViewStackView.snp.makeConstraints{
            $0.height.equalTo(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        repeatLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        repeatDayLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        groupView.snp.makeConstraints{
            $0.top.equalTo(timerView.snp.bottom).offset(8)
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
            $0.height.equalTo(152)
            $0.width.equalTo(alarmScrollVeiw.frameLayoutGuide)
            $0.bottom.equalToSuperview().inset(50)
        }
        memoLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(16)
        }
        memoTextView.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).inset(-8)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        memoPlaceholder.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(16)
        }
        notiLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(memoView.snp.bottom).offset(18)
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
    //MARK: - picker SET
    
    func pickerviewUI(){
        timePicker.subviews[1].isHidden = true
        
        let colonLabel = UILabel()
        colonLabel.text = ":"
        colonLabel.font = DesignSystemFont.Pretendard_Bold30.value
        timePicker.addSubview(colonLabel)
        
        colonLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-3)
            $0.centerX.equalToSuperview().offset(-16.5)
        }
    }
    
    func setCurrentTimeOnPicker() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        
        let hourForPicker: Int
        let ampm: Int
        
        if hour >= 12 {
            hourForPicker = hour == 12 ? 12 : hour - 12
            ampm = 1 // PM
        } else {
            hourForPicker = hour == 0 ? 12 : hour
            ampm = 0 // AM
        }
        
        let middleHour = self.hour.count * 50
        let middleMinute = min.count * 50
        let middleAMPM = AMPM.count * 50
        
        timePicker.selectRow(middleHour + hourForPicker - 1, inComponent: 0, animated: false)
        timePicker.selectRow(middleMinute + minute, inComponent: 1, animated: false)
        timePicker.selectRow(middleAMPM + ampm, inComponent: 2, animated: false)
    }
    
    //MARK: - @objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func repeatDay(){
        let vc = WeekChoiceViewController()
        self.present(vc, animated: true)
        
        //  let height = view.bounds.height * 0.65
        
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { context in
                    return 440
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
            
            let notiLabelBottom = notiLabel.frame.origin.y + notiLabel.frame.height
            let keyboardTop = self.view.frame.height - keyboardSize.height
            let offset = (notiLabelBottom - keyboardTop) + 10
            
            if offset > 0 && self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= offset
                self.saveButton.isHidden = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.saveButton.isHidden = false
        }
    }
}
//MARK: - pickerView custom

extension MakeAlarmViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    //휠 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    //컴포넌트의 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hour.count*100
        case 1:
            return min.count*100
        case 2:
            return AMPM.count
        default:
            return 0
        }
    }
    
    //컴포넌트 표시
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(format: "%02d", hour[row % hour.count])
        case 1:
            return String(format: "%02d", min[row % min.count])
        case 2:
            return "\(AMPM[row])"
        default:
            return ""
        }
    }
    
    //컴포넌트 표시
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if component == 0 || component == 1 {
            let timelabel = UILabel()
            timelabel.textAlignment = .center
            timelabel.font = DesignSystemFont.Pretendard_Bold30.value
            
            if component == 0 {
                timelabel.text = String(format: "%02d", hour[row % hour.count])
            } else {
                timelabel.text = String(format: "%02d", min[row % min.count])
            }
            return timelabel
            
        } else {
            let AMPMlabel = UILabel()
            AMPMlabel.textAlignment = .center
            AMPMlabel.font = DesignSystemFont.Pretendard_Bold18.value
            AMPMlabel.text = String(AMPM[row])
            
            return AMPMlabel
        }
    }
    
    //컴포넌트 위아래 간격
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 46 // 각 행의 높이를 조절합니다. 필요에 따라 이 값을 조정하세요.
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0, 1: // 시간과 분
            return 75.5
        case 2: // AM/PM
            return 29
        default:
            return 45
        }
    }
}

extension MakeAlarmViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = DesignSystemColor.Orange500.value.cgColor
        memoPlaceholder.isHidden = !memoTextView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        memoPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.layer.borderWidth = 0
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

