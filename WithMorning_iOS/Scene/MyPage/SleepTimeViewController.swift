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
    
    let APInetwork = Network.shared
    
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
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    //MARK: - baseView
    private lazy var baseView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(timePicker,bar1,repeatStackView)
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
    
    private lazy var bar1 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var repeatStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(repeatLabel,repeatDayLabel,repeatDayLabel1)
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
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "forward")
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 24, height: 24)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        
        let label = UILabel()
        label.attributedText = attributedString1
        label.textAlignment = .right
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    private lazy var repeatDayLabel1 : UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        return label
    }()
    
    
    //MARK: - baseView2
    private lazy var baseView2 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(notiLabel,bedtimeToggle)
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
    
    //    private lazy var notiImage : UIButton = {
    //        let button = UIButton()
    //        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
    //        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
    //        button.addTarget(self, action: #selector(notisetting), for: .touchUpInside)
    //        return button
    //    }()
    
    private lazy var bedtimeToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = DesignSystemColor.Orange500.value
        toggle.tintColor = DesignSystemColor.Gray300.value
        toggle.backgroundColor = DesignSystemColor.Gray300.value
        toggle.addTarget(self, action: #selector(bedtimeToggleClick), for: .valueChanged)
        toggle.layer.cornerRadius = toggle.frame.height / 2
        toggle.layer.masksToBounds = true
        return toggle
    }()
    
    //MARK: - 저장 버튼
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
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
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        setSelectedTimeOnPicker()
        updateRepeatDayLabel()
        bedtimeToggleTintColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerviewUI()
    }
    
    //MARK: - setUI
    
    func SetUI(){
        view.addSubviews(mainLabel,popButton,baseView,baseView2,saveButton)
        
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
            $0.top.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bar1.snp.top)
        }
        
        bar1.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.bottom.equalTo(repeatStackView.snp.top).offset(-16)
        }
        
        repeatStackView.snp.makeConstraints{
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
        repeatDayLabel1.snp.makeConstraints{
            $0.centerY.equalTo(repeatDayLabel)
            $0.trailing.equalTo(repeatDayLabel.snp.leading).offset(-4)
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
        bedtimeToggle.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
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
    
    //MARK: - picker set
    func pickerviewUI(){
        timePicker.subviews[1].isHidden = true
        let colonLabel = UILabel()
        colonLabel.text = ":"
        colonLabel.font = DesignSystemFont.Pretendard_Bold30.value
        UIView.performWithoutAnimation {
            timePicker.addSubview(colonLabel)
            colonLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview().offset(-3)
                $0.centerX.equalToSuperview().offset(-16.5)
            }
            timePicker.layoutIfNeeded()
        }
        
    }
    
    func setSelectedTimeOnPicker() {
        // "HH:mm" 형식의 selectedTime24 파싱
        let components = selectedTime24.split(separator: ":")
        guard components.count == 2,
              let hour24 = Int(components[0]),
              let minute = Int(components[1]) else {
            return
        }
        
        // AM/PM 결정 (24시간제 기준)
        let isPM = hour24 >= 12
        
        // 12시간제로 변환
        let hour12: Int
        if hour24 == 0 {
            hour12 = 12  // 자정 (12 AM)
        } else if hour24 > 12 {
            hour12 = hour24 - 12  // PM
        } else {
            hour12 = hour24  // AM or 12 PM
        }
        
        print("Setting time - 24h: \(selectedTime24), 12h: \(hour12):\(minute) \(isPM ? "PM" : "AM")")
        
        // Picker 설정
        let hourIndex = (hour.count * 50) + (hour12 - 1)
        let minuteIndex = (min.count * 50) + minute
        let ampmIndex = isPM ? 1 : 0  // PM이면 1, AM이면 0으로 설정합니다.
        
        timePicker.selectRow(hourIndex, inComponent: 0, animated: false)
        timePicker.selectRow(minuteIndex, inComponent: 1, animated: false)
        timePicker.selectRow(ampmIndex, inComponent: 2, animated: false)
    }
    
    //MARK: - 요일 설정
    func updateRepeatDayLabel() {
        // 요일 집합 정의
        let weekdaysSet: Set = ["mon", "tue", "wed", "thu", "fri"]
        let weekendSet: Set = ["sat", "sun"]
        let allDaysSet: Set = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
        let selectedDaySet = Set(selectedDayOfWeek)
        
        // 한글 요일 변환 딕셔너리
        let dayOfWeekDict: [String: String] = [
            "mon": "월", "tue": "화", "wed": "수", "thu": "목",
            "fri": "금", "sat": "토", "sun": "일"
        ]
        
        // 조건에 따른 텍스트 설정
        if selectedDaySet.isEmpty {
            repeatDayLabel1.text = "없음"
        }
        // 모든 요일이 선택된 경우
        else if selectedDaySet == allDaysSet {
            repeatDayLabel1.text = "매일"
        }
        // 평일만 선택된 경우
        else if weekdaysSet.isSubset(of: selectedDaySet) && selectedDaySet.intersection(weekendSet).isEmpty {
            repeatDayLabel1.text = "평일"
        }
        // 주말만 선택된 경우
        else if selectedDaySet.isSubset(of: weekendSet) {
            repeatDayLabel1.text = "주말"
        }
        // 그 외의 경우 선택된 요일들을 나열
        else {
            let koreanDays = selectedDayOfWeek.compactMap { dayOfWeekDict[$0] }.joined(separator: ", ")
            repeatDayLabel1.text = koreanDays
        }
    }
    
    
    //MARK: - 호출 API
    var selectedDayOfWeek: [String] = []
    var selectedTime24: String = ""
    var allowAlarm : Bool = false
    
    func editBedtime(){
        LoadingIndicator.showLoading()
        let bedtime = BedtimeMaindata(bedTime: selectedTime24, bedDayOfWeekList: selectedDayOfWeek, isAllowBedTimeAlarm: allowAlarm)
        
        APInetwork.postBedtime(bedtimedata: bedtime){ result in
            switch result {
            case .success(let bed):
                print("취침시간",bed)
                self.navigationController?.popViewController(animated: true)
                LoadingIndicator.hideLoading()
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    //MARK: - objc func
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func repeatDay() {
        let vc = WeekChoiceViewController()
        vc.AlarmSelectedDays = selectedDayOfWeek
        vc.callerType = .sleepTime
        vc.weekClosure = { [weak self] selectedDays in
            self?.selectedDayOfWeek = selectedDays
            self?.updateRepeatDayLabel()
        }
        
        self.present(vc, animated: true)
        
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
    //MARK: - 알람받기
    @objc func bedtimeToggleClick(){
        if allowAlarm == false{
            bedtimeToggle.isOn = true
            allowAlarm = true
            bedtimeToggleTintColor()
        }else{
            bedtimeToggle.isOn = false
            allowAlarm = false
            bedtimeToggleTintColor()
        }
    }
    
    func bedtimeToggleTintColor(){
        if allowAlarm == true{
            bedtimeToggle.isOn = true
        }else{
            bedtimeToggle.isOn = false
        }
    }
    
    //MARK: - 저장 버튼
    @objc func saveclicked() {
        editBedtime()
    }
}

extension SleepTimeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            AMPMlabel.text = /*String(AMPM[row])*/AMPM[row % AMPM.count]
            
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hour[pickerView.selectedRow(inComponent: 0) % hour.count]
        let selectedMinute = min[pickerView.selectedRow(inComponent: 1) % min.count]
        let selectedAMPM = AMPM[pickerView.selectedRow(inComponent: 2) % AMPM.count]
        
        // 24시간제로 변환
        var hour24 = selectedHour
        if selectedAMPM == "PM" {
            if selectedHour != 12 {
                hour24 += 12
            }
        } else { // AM
            if selectedHour == 12 {
                hour24 = 0
            }
        }
        
        selectedTime24 = String(format: "%02d:%02d", hour24, selectedMinute)
        print("Selected time (24h): \(selectedTime24)")
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
