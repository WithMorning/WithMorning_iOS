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

//MARK: - AlarmTableViewCell

class AlarmTableViewCell : UITableViewCell, UISheetPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
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
        view.addSubviews(topViewLabel,toggleButton,settingButton,timeLabel,noonLabel,WeekStackView)
        return view
    }()
    
    lazy var topViewLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_SemiBold14.value
        label.textColor = DesignSystemColor.Black.value
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
    
     lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "07:30"
        label.font = DesignSystemFont.Pretendard_Bold30.value
        return label
    }()
    
     lazy var noonLabel : UILabel = {
        let label = UILabel()
        label.text = "AM"
        label.font = DesignSystemFont.Pretendard_Bold18.value
        return label
    }()
    
    //MARK: - 날짜
    private lazy var WeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.addSubviews(MonLabel,TueLabel,WedLabel,ThuLabel,FriLabel,SatLabel,SunLabel)
        return stackView
    }()
    
    lazy var MonLabel : UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var TueLabel : UILabel = {
        let label = UILabel()
        label.text = "화"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var WedLabel : UILabel = {
        let label = UILabel()
        label.text = "수"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var ThuLabel : UILabel = {
        let label = UILabel()
        label.text = "목"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var FriLabel : UILabel = {
        let label = UILabel()
        label.text = "금"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var SatLabel : UILabel = {
        let label = UILabel()
        label.text = "토"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    lazy var SunLabel : UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var borderLine : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    //MARK: - 아랫 부분
    lazy var bottomView : UIView = {
        let view = UIView()
        view.addSubviews(borderLine,bottomViewLabel,memberCollectionView,memoView,memoLabel)
        view.isHidden = true
        return view
    }()
    
    lazy var bottomViewLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        
        let attributeLabel = NSMutableAttributedString(string: "프로필을 누르면 친구를 깨울 수 있어요!")
        let attachImage = NSTextAttachment()
        attachImage.image = UIImage(named: "Check")
        attachImage.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
        let imageString = NSAttributedString(attachment: attachImage)
        attributeLabel.insert(imageString, at: 0)
        label.attributedText = attributeLabel
        return label
    }()
    
    lazy var memberCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 62, height: 62)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(memberCollectioViewCell.self, forCellWithReuseIdentifier: "memberCollectioViewCell")
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var memoView : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray100.value
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var memoLabel : UILabel = {
        let label = UILabel()
        //        label.text = "아침에 하고 싶은 말 또는 패널티를 정해주세요."
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    func setCell(){
        contentView.addSubview(AlarmStackView)
        contentView.layer.cornerRadius = 8
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
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
        
        //날짜스택뷰
        WeekStackView.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(164)
        }
        MonLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
        }
        TueLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(MonLabel.snp.trailing).offset(4)
        }
        WedLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(TueLabel.snp.trailing).offset(4)
        }
        ThuLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(WedLabel.snp.trailing).offset(4)
        }
        FriLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(ThuLabel.snp.trailing).offset(4)
        }
        SatLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(FriLabel.snp.trailing).offset(4)
        }
        SunLabel.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalTo(SatLabel.snp.trailing).offset(4)
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
        
        memberCollectionView.snp.makeConstraints{
            $0.top.equalTo(bottomViewLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(87)
            $0.width.equalToSuperview().offset(-40)
        }
        
        memoView.snp.makeConstraints{
            $0.height.equalTo(49)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        memoLabel.snp.makeConstraints{
            $0.center.equalTo(memoView)
        }
    }
    
    //MARK: - 유저API 통신
    var userData : [UserList] = []
    var memberCount : Int = 0
    
    func ConfigureMember(_ userList: [UserList]) {
        self.memberCount = userList.count
        userData = userList
        self.memberCollectionView.reloadData()
    }
    
    //MARK: - 그룹API 통신
    var groupID : Int = 0
    
    
    //MARK: - objc func
    @objc func clicktoggle(sender : UISwitch){
        toggleclicked()
    }
    
    @objc func clickSetting(){
        guard let parentViewController = self.parentVC else {
            return
        }
        
        let vc = CellMenuViewController()
        vc.modalPresentationStyle = .formSheet
        parentViewController.present(vc, animated: true)
        print("groupID : ",groupID)
        
        if let vc = vc.sheetPresentationController{
            if #available(iOS 16.0, *) {
                vc.detents = [.custom { context in
                    return 245
                }]
                
                vc.delegate = self
                vc.prefersGrabberVisible = false
                vc.preferredCornerRadius = 16
            }
            
        }
        
        vc.Menuclicked = {
            vc.dismiss(animated: true) {
                let alterVC = AlterUIView(alterType: .deleteAlarm)
                alterVC.modalPresentationStyle = .overFullScreen
                alterVC.modalTransitionStyle = .crossDissolve
                parentViewController.present(alterVC, animated: true, completion: nil)
            }
        }
        
    }
    //MARK: - collectionView delegate func
    
    //그룹내의 멤버 숫자
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberCount
    }
    
    //그룹내의 셀 재사용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCollectioViewCell", for: indexPath) as! memberCollectioViewCell
        
        let userlistData = userData[indexPath.item]
        
        cell.memberLabel.text = userlistData.nickname
        
        return cell
    }
    
    //그룹내의 셀 크기 = 이미지 + 라벨
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 62, height: 84.5)
    }
    
    //그룹내의 셀 중앙정렬
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 62 * memberCount
        let totalSpacingWidth = 8 * (memberCount - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    //그룹내의 셀 클릭시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let parentViewController = self.parentVC else {
            return
        }
        
        let vc = UserStateViewController()
        vc.modalPresentationStyle = .formSheet
        parentViewController.present(vc, animated: true)
        
        vc.nicknameLabel.text = userData[indexPath.item].nickname
        vc.userphoneNum = userData[indexPath.item].phone
        
        print(userData[indexPath.item])
        
        if let vc = vc.sheetPresentationController{
            if #available(iOS 16.0, *) {
                vc.detents = [.custom { context in
                    return 330
                }]
                vc.delegate = self
                vc.prefersGrabberVisible = false
                vc.preferredCornerRadius = 16
            }
            
        }
    }
    
}

//MARK: - memberCollectionViewCell
class memberCollectioViewCell : UICollectionViewCell{
     lazy var memberImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = DesignSystemColor.Orange500.value
        view.image = UIImage(systemName: "person.circle.fill")
        view.layer.cornerRadius = 31
        view.tintColor = .white
        return view
    }()
    
     lazy var memberLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = DesignSystemFont.Pretendard_SemiBold12.value
        return label
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        contentView.addSubviews(memberImageView,memberLabel)
        
        memberImageView.snp.makeConstraints{
            $0.height.width.equalTo(62)
            
        }
        memberLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(memberImageView)
        }
    }
    
}

