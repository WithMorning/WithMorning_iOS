//
//  AlarmTableViewCell.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/13/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class AlarmTableViewCell : UITableViewCell{
    
    //MARK: - closure
    var toggleclicked : ( () -> Void ) = {}
    
    lazy var AlarmStackView : UIStackView = {
        let view = UIStackView()
        view.addSubviews(topView,bottomView)
        view.axis = .vertical
        return view
    }()
    //MARK: - 윗부분
    
    lazy var topView : UIView = {
        let view = UIView()
        view.addSubviews(topViewLabel,toggleButton,settingButton,timeLabel,noonLabel,WeekCollectionView)
        return view
    }()
    
    let topViewLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_SemiBold12.value
        label.textColor = DesignSystemColor.Black.value
        label.text = "우리 같이 조깅하고 출근하쟈 🏃‍♀"
        return label
    }()
    
    let toggleButton : UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = DesignSystemColor.Orange500.value
        toggle.addTarget(self, action: #selector(clicktoggle(sender:)), for: .touchUpInside)
        return toggle
    }()
    
    lazy var settingButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(.black)
        button.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "07:30"
        label.font = DesignSystemFont.Pretendard_Bold30.value
        return label
    }()
    
    private lazy var noonLabel : UILabel = {
        let label = UILabel()
        label.text = "AM"
        label.font = DesignSystemFont.Pretendard_Bold18.value
        return label
    }()
    
//MARK: - 날짜 StackView
    let weeks = ["월","화","수","목","금","토","일"]
    
    private lazy var WeekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: "WeekCollectionViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - 아랫 부분
    
    lazy var bottomView : UIView = {
        let view = UIView()
        view.addSubviews(borderLine,bottomViewLabel,memoView)
        view.isHidden = true
        return view
    }()
    
    private lazy var borderLine : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    lazy var bottomViewLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        label.text = "프로필을 누르면 친구를 깨울 수 있어요!"
        return label
    }()
    
    private lazy var memoView : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray100.value
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SetCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    func SetCell(){
        contentView.addSubview(AlarmStackView)
        
        contentView.layer.cornerRadius = 8
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = true
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        //stackview
        AlarmStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        //윗부분 시작
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(129)
        }
        topViewLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(settingButton)
        }
        toggleButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(57.5)
            $0.trailing.equalToSuperview().inset(16)
        }
        settingButton.snp.makeConstraints{
            $0.height.width.equalTo(24)
            $0.top.trailing.equalToSuperview().inset(16)
        }
        timeLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(topViewLabel.snp.bottom).offset(8)
        }
        noonLabel.snp.makeConstraints{
            $0.centerY.equalTo(timeLabel)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
        }
        
        WeekCollectionView.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.leading)
            $0.top.equalTo(timeLabel.snp.bottom).offset(9)
            $0.height.equalTo(20)
            $0.width.equalTo(164)
        }
        
        
        //아랫부분 시작
        bottomView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
        borderLine.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bottomViewLabel.snp.makeConstraints{
            $0.top.equalTo(borderLine.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        memoView.snp.makeConstraints{
            $0.height.equalTo(63)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    
    //MARK: - objc func
    
    @objc func clicktoggle(sender : UISwitch){
        toggleclicked()
        
    }
    @objc func clickSetting(){
        print("나는야 셀의 메뉴버튼 ! ")
    }
    
    
}
extension AlarmTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count
    }
    
    //셀 재사용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as? WeekCollectionViewCell else {return UICollectionViewCell()}
        
        
        return cell
    }
    
    //셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 4 
        }

}
