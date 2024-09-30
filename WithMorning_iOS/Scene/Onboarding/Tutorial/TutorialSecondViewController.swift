//
//  TutorialSecondViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/25/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class TutorialSecondViewController : UIViewController {
    
    //MARK: - properties
    private lazy var timerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubview(timePicker)
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
    
    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
        setCurrentTimeOnPicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerviewUI()
    }
    
    //MARK: - autolayout

    func setUI(){
        view.addSubviews(timerView)

        timerView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(152)
        }
        timePicker.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
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
    
}


//MARK: - pickerView custom

extension TutorialSecondViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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


//Preview code
#if DEBUG
import SwiftUI
struct TutorialSecondViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        TutorialSecondViewController()
    }
}
@available(iOS 13.0, *)
struct TutorialSecondViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                TutorialSecondViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
