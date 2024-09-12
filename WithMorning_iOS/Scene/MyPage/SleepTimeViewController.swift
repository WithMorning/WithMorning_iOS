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
    
    let sleepNoti = PushNotificationHelper.shared
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
        button.addTarget(self, action: #selector(notisetting), for: .touchUpInside)
        return button
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
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        setCurrentTimeOnPicker()
        updateRepeatDayLabel()
        allowAlarmTintColor()
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
            $0.trailing.equalTo(repeatDayLabel.snp.leading).offset(-12)
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
    
    //MARK: - 요일 설정
    func updateRepeatDayLabel() {
        if selectedDayOfWeek.isEmpty {
            repeatDayLabel1.text = "없음"
        } else {
            let dayNames = selectedDayOfWeek.map { day -> String in
                switch day {
                case "mon": return "월"
                case "tue": return "화"
                case "wed": return "수"
                case "thu": return "목"
                case "fri": return "금"
                case "sat": return "토"
                case "sun": return "일"
                default: return ""
                }
            }
            repeatDayLabel1.text = dayNames.joined(separator: ", ")
        }
    }
    //MARK: - API
    var selectedDayOfWeek: [String] = []
    var selectedTime24: String = ""
    var allowAlarm : Bool = false
    
    func editBedtime(completion: @escaping (Bool) -> Void){
        let bedtime = BedtimeMaindata(bedTime: selectedTime24, bedDayOfWeekList: selectedDayOfWeek, isAllowBedTimeAlarm: allowAlarm)
        
        APInetwork.postBedtime(bedtimedata: bedtime){ result in
            switch result {
            case .success(let bed):
                print("취침시간",bed)
            case .failure(let error):
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
    @objc func notisetting(){
        if allowAlarm == false{
            notiImage.tintColor = DesignSystemColor.Gray200.value
            allowAlarm = true
            allowAlarmTintColor()
        }else{
            notiImage.tintColor = DesignSystemColor.Orange500.value
            allowAlarm = false
            allowAlarmTintColor()
        }
    }
    
    func allowAlarmTintColor(){
        if allowAlarm == true{
            notiImage.tintColor = DesignSystemColor.Orange500.value
        }else{
            notiImage.tintColor = DesignSystemColor.Gray200.value
        }
    }
    //MARK: - 저장 버튼
    
    @objc func saveclicked() {
        editBedtime{[weak self] success in
            DispatchQueue.main.async {
            if success {
                self?.navigationController?.popViewController(animated: true)
            } else {
                // API 호출 실패 시 사용자에게 알림
                print("그룹 생성 실패")
            }
        }
        }
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hour[pickerView.selectedRow(inComponent: 0) % hour.count]
        let selectedMinute = min[pickerView.selectedRow(inComponent: 1) % min.count]
        let selectedAMPM = AMPM[pickerView.selectedRow(inComponent: 2)]
        
        var hour24 = selectedHour
        if selectedAMPM == "PM" && selectedHour != 12 {
            hour24 += 12
        } else if selectedAMPM == "AM" && selectedHour == 12 {
            hour24 = 0
        }
        
        selectedTime24 = String(format: "%02d:%02d", hour24, selectedMinute)
        
        print("설정된 시간 (24시간제): \(selectedTime24)")
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
