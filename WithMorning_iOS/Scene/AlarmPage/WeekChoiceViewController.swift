//
//  WeekChoiceViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/7/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class WeekChoiceViewController : UIViewController, UIScrollViewDelegate {
    
    //MARK: - properties
    
    private lazy var weekScrollVeiw : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.addSubview(contentView)
        scrollview.isScrollEnabled = true
        scrollview.delegate = self
        scrollview.showsVerticalScrollIndicator = false
        
        return scrollview
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.addSubviews(MonstackView,TuestackView,WedstackView,ThrstackView,FristackView,SatstackView,SunstackView,weekdayButton,weekendButton)
        return view
    }()
    
    //MARK: - 월요일

    private lazy var MonstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(MonLabel,MonIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(monclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()

    
    private lazy var MonLabel : UILabel = {
        let label = UILabel()
        label.text = "월요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var MonIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    //MARK: - 화요일

    private lazy var TuestackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(TueLabel,TueIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tueuclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        return stackView
    }()
    
    private lazy var TueLabel : UILabel = {
        let label = UILabel()
        label.text = "화요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var TueIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    //MARK: - 수요일
    private lazy var WedstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(WedLabel,WedIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wedclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        return stackView
    }()
    
    private lazy var WedLabel : UILabel = {
        let label = UILabel()
        label.text = "수요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var WedIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    //MARK: - 목요일
    private lazy var ThrstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(ThrLabel,ThrIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thrclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        return stackView
    }()
    
    private lazy var ThrLabel : UILabel = {
        let label = UILabel()
        label.text = "목요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var ThrIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    //MARK: - 금요일
    private lazy var FristackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(FriLabel,FriIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(friclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        return stackView
    }()
    
    private lazy var FriLabel : UILabel = {
        let label = UILabel()
        label.text = "금요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var FriIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    //MARK: - 토요일
    private lazy var SatstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(SatLabel,SatIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(satclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)

        return stackView
    }()
    
    private lazy var SatLabel : UILabel = {
        let label = UILabel()
        label.text = "토요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var SatIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value
        return view
    }()
    //MARK: - 일요일
    private lazy var SunstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addSubviews(SunLabel,SunIMG)
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sunclick))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var SunLabel : UILabel = {
        let label = UILabel()
        label.text = "일요일"
        label.textAlignment = .left
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        return label
    }()
    
    private lazy var SunIMG : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square.fill")
        view.tintColor = DesignSystemColor.Gray200.value

        return view
    }()
    
    //MARK: - 주중

    private lazy var weekdayButton : UIButton = {
        let button = UIButton()
        button.setTitle("주중", for: .normal)
        button.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
        button.backgroundColor = DesignSystemColor.Gray200.value
        button.layer.cornerRadius = 8
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.addTarget(self, action: #selector(weekdayclick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 주말
    private lazy var weekendButton : UIButton = {
        let button = UIButton()
        button.setTitle("주말", for: .normal)
        button.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
        button.backgroundColor = DesignSystemColor.Gray200.value
        button.layer.cornerRadius = 8
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.addTarget(self, action: #selector(weekendclick), for: .touchUpInside)
        return button
    }()

    //MARK: - 완료버튼
    private lazy var DoneButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
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


    //MARK: - Life Cycle

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    func setUI(){
        view.addSubviews(weekScrollVeiw,DoneButton)
        
        weekScrollVeiw.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(DoneButton.snp.top)
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(weekScrollVeiw.frameLayoutGuide)
        }
        
        //월요일
        MonstackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        MonLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        MonIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //화요일
        TuestackView.snp.makeConstraints{
            $0.top.equalTo(MonstackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        TueLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        TueIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //수요일
        WedstackView.snp.makeConstraints{
            $0.top.equalTo(TuestackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        WedLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        WedIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //목요일
        ThrstackView.snp.makeConstraints{
            $0.top.equalTo(WedstackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        ThrLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        ThrIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //금요일
        FristackView.snp.makeConstraints{
            $0.top.equalTo(ThrstackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        FriLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        FriIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //토요일
        SatstackView.snp.makeConstraints{
            $0.top.equalTo(FristackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        SatLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        SatIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //일요일
        SunstackView.snp.makeConstraints{
            $0.top.equalTo(SatstackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        SunLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
        }
        SunIMG.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        //주중
        weekdayButton.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.equalTo(SunstackView.snp.bottom).offset(16)
            $0.height.equalTo(52)
            $0.trailing.equalTo(view.snp.centerX).offset(-5)
        }
        //주말
        weekendButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.top.equalTo(SunstackView.snp.bottom).offset(16)
            $0.height.equalTo(52)
            $0.leading.equalTo(view.snp.centerX).offset(5)
        }
        DoneButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(weekdayButton.snp.bottom).offset(24)
        }
        buttonLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    //MARK: - 주중, 주말 색 변화
    func updateweeklycolor(){
        if [MonIMG, TueIMG, WedIMG, ThrIMG, FriIMG].allSatisfy({ $0.tintColor == DesignSystemColor.Orange500.value }) {
            weekdayButton.backgroundColor = DesignSystemColor.Orange500.value
            weekdayButton.setTitleColor(.white, for: .normal)
        }else{
            weekdayButton.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
            weekdayButton.backgroundColor = DesignSystemColor.Gray200.value
        }
        
        if [SatIMG,SunIMG].allSatisfy({$0.tintColor == DesignSystemColor.Orange500.value}) {
            weekendButton.backgroundColor = DesignSystemColor.Orange500.value
            weekendButton.setTitleColor(.white, for: .normal)
        }else{
            weekendButton.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
            weekendButton.backgroundColor = DesignSystemColor.Gray200.value
        }
        
        
    }
    
    
    //MARK: - objc func
    @objc func monclick(){
        if MonIMG.tintColor == DesignSystemColor.Gray200.value{
            MonIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            MonIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
        
    }
    @objc func tueuclick(){
        if TueIMG.tintColor == DesignSystemColor.Gray200.value{
            TueIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            TueIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func wedclick(){
        if WedIMG.tintColor == DesignSystemColor.Gray200.value{
            WedIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            WedIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func thrclick(){
        if ThrIMG.tintColor == DesignSystemColor.Gray200.value{
            ThrIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            ThrIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func friclick(){
        if FriIMG.tintColor == DesignSystemColor.Gray200.value{
            FriIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            FriIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func satclick(){
        if SatIMG.tintColor == DesignSystemColor.Gray200.value{
            SatIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            SatIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func sunclick(){
        if SunIMG.tintColor == DesignSystemColor.Gray200.value{
            SunIMG.tintColor = DesignSystemColor.Orange500.value
        }else{
            SunIMG.tintColor = DesignSystemColor.Gray200.value
        }
        updateweeklycolor()
    }
    @objc func doneclick(){
        self.dismiss(animated: true)
    }
    
    @objc func weekdayclick(){
        if weekdayButton.backgroundColor == DesignSystemColor.Gray200.value {
            weekdayButton.backgroundColor = DesignSystemColor.Orange500.value
            weekdayButton.setTitleColor(.white, for: .normal)
               [MonIMG, TueIMG, WedIMG, ThrIMG, FriIMG].forEach { $0.tintColor = DesignSystemColor.Orange500.value }
        }else{
            weekdayButton.backgroundColor = DesignSystemColor.Gray200.value
            weekdayButton.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
               [MonIMG, TueIMG, WedIMG, ThrIMG, FriIMG].forEach { $0.tintColor = DesignSystemColor.Gray200.value }
        }
    }
    @objc func weekendclick(){
        if weekendButton.backgroundColor == DesignSystemColor.Gray200.value {
            weekendButton.backgroundColor = DesignSystemColor.Orange500.value
            weekendButton.setTitleColor(.white, for: .normal)
               [SatIMG,SunIMG].forEach { $0.tintColor = DesignSystemColor.Orange500.value }
        }else{
            weekendButton.backgroundColor = DesignSystemColor.Gray200.value
            weekendButton.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
            [SatIMG,SunIMG].forEach { $0.tintColor = DesignSystemColor.Gray200.value }
        }

    }
}


//Preview code
#if DEBUG
import SwiftUI
struct WeekChoiceViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        WeekChoiceViewController()
    }
}
@available(iOS 13.0, *)
struct WeekChoiceViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                WeekChoiceViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
