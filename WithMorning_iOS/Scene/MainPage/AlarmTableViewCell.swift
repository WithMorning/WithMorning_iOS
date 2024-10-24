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
import Kingfisher

//MARK: - AlarmTableViewCell

class AlarmTableViewCell : UITableViewCell, UISheetPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    //MARK: - closure
    var toggleclicked : ( () -> Void ) = {} //토클 온 오프
    
    var onEditAlarm: ((Int) -> Void)?
    
    //알람삭제후 실행되는 클로저
    var onAlarmDelete: (() -> Void)?
    //알람나가기 누른 후 실행되는 클로저
    var onAlarmLeave: (()->Void)?
    
    var APInetwork = Network.shared
    
    var time24: String = ""
    
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
        toggle.onTintColor = DesignSystemColor.Orange500.value
        toggle.tintColor = DesignSystemColor.Gray300.value
        toggle.addTarget(self, action: #selector(clicktoggle), for: .touchUpInside)
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
        label.font = DesignSystemFont.Pretendard_Bold30.value
        return label
    }()
    
    lazy var noonLabel : UILabel = {
        let label = UILabel()
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
        view.addSubviews(borderLine,bottomViewLabel,memberCollectionView,memoView)
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
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(memberCollectioViewCell.self, forCellWithReuseIdentifier: "memberCollectioViewCell")
        view.isScrollEnabled = false
        
        return view
    }()
    
    private lazy var memoView : UIView = {
        let view = UIView()
        view.addSubviews(memoLabel,moreButton)
        view.backgroundColor = DesignSystemColor.Gray100.value
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystemColor.Gray400.value
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byTruncatingTail
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(memoLabelTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Medium12.value
        button.setTitleColor(DesignSystemColor.Gray600.value, for: .normal)
        return button
    }()
    
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCell()
        memoLabel.preferredMaxLayoutWidth = memoLabel.frame.width
        
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
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
        }
        
        memberCollectionView.snp.makeConstraints {
            $0.top.equalTo(bottomViewLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            self.collectionViewHeightConstraint = $0.height.equalTo(collectionViewHeight).constraint
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(memberCollectionView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        memoLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 48, bottom: 16, right: 48))
        }
        
    }
    
    //MARK: - 방해금지 모드 API
    var disturb : Bool = false
    
    func patchDisturb(newDisturbMode: Bool) {
        LoadingIndicator.showLoading()
        
        let data = DisturbMaindata(isDisturbBanMode: newDisturbMode)
        
        APInetwork.patchDisturb(groupId: self.groupId, DisturbData: data) { result in
            
            switch result {
            case .success(_):
                self.disturb = newDisturbMode
                self.toggleclicked()
                LoadingIndicator.hideLoading()
                
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print(error.localizedDescription)
            }
        }
    }
    //MARK: - 24시간을 12시간으로 포멧
    
    func convertTimeTo12HourFormat(_ time24: String) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        // "HH:mm" 형태의 24시간제를 Date 객체로 변환
        if let time = dateFormatter.date(from: time24) {
            // 시간 형식: "h:mm" (12시간제)
            dateFormatter.dateFormat = "h:mm"
            let time12Hour = dateFormatter.string(from: time)
            
            // AM/PM 형식
            dateFormatter.dateFormat = "a"
            let amPm = dateFormatter.string(from: time)
            
            return (time12Hour, amPm)  // 시간을 AM/PM과 함께 반환
        }
        
        // 만약 변환에 실패하면 원래의 값을 반환
        return (time24, "")
    }
    
    
    func configureCell(with alarm: GroupList, currentUserNickname: String) {
        
        if let currentUser = alarm.userList?.first(where: { $0.nickname == currentUserNickname }) {
            
            disturb = currentUser.isDisturbBanMode
            
            toggleButton.isOn = !disturb
            //            self.bottomView.isHidden = self.disturb
            
            DispatchQueue.main.async {
                self.bottomView.isHidden = self.disturb
                let (time, amPm) = self.convertTimeTo12HourFormat(alarm.wakeupTime)
                
                // timeLabel 에는 시간만, noonLabel 에는 AM/PM을 넣음
                self.timeLabel.text = time
                self.noonLabel.text = amPm
                
                let dayLabels = [self.MonLabel, self.TueLabel, self.WedLabel, self.ThuLabel, self.FriLabel, self.SatLabel, self.SunLabel]
                
                for label in dayLabels {
                    if self.disturb {
                        label.backgroundColor = DesignSystemColor.Gray100.value
                        label.textColor = DesignSystemColor.Gray300.value
                    }
                }
                
            }
            
        }
    }
    
    //MARK: - 멤버
    var groupId : Int = 0 //그룹 아이디 (방해금지모드에도 사용)
    
    var participantcode : String = ""
    
    private var userData : [UserList] = [] //유저 데이터
    private var memberCount : Int = 0
    private var collectionViewHeight: CGFloat = 90
    private var updateTask: DispatchWorkItem?
    
    //제약조건 업데이트를 위해 var로 설정
    private var collectionViewHeightConstraint: Constraint?
    
    func ConfigureMember(_ userList: [UserList]) {
        self.memberCount = userList.count
        userData = userList
        
        let maxHeight = calculateMaxCellHeight()
        self.collectionViewHeight = maxHeight
        
        DispatchQueue.main.async {
            self.memberCollectionView.reloadData()
            self.updateCollectionViewHeight()
            self.layoutIfNeeded()
            
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    //MARK: - collectionview 높이계산
    func updateCollectionViewHeight() {
        collectionViewHeightConstraint?.update(offset: collectionViewHeight)
        setNeedsLayout()
    }
    
    //MARK: - collectionviewcell 높이계산
    func calculateMaxCellHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        
        for i in 0..<memberCount {
            let text = userData[i].nickname
            let font = DesignSystemFont.Pretendard_SemiBold12.value
            let maxWidth: CGFloat = 62
            
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [NSAttributedString.Key.font: font],
                context: nil
            ).size
            
            let labelHeight = ceil(textSize.height)
            let imageHeight: CGFloat = 64
            let spacing: CGFloat = 8
            
            let cellHeight: CGFloat
            if labelHeight > font.lineHeight {
                // 2줄 이상일 경우
                cellHeight = imageHeight + spacing + (font.lineHeight * 2)
            } else {
                // 1줄일 경우
                cellHeight = imageHeight + spacing + font.lineHeight
            }
            
            maxHeight = max(maxHeight, cellHeight)
        }
        
        return maxHeight
    }
    
    //MARK: - 메모LabelUI 높이계산
    // 메모라벨의 텍스트와 상태를 저장할 변수
    
    private var memoViewHeightConstraint: Constraint?
    var fullText: String = ""
    var isExpanded : Bool = false
    var memoExpand : (() -> Void)?
    
    // 메모 라벨 초기 설정
    func setMemoText(_ text: String) {
        fullText = text
        memoLabel.numberOfLines = 1
        
        if isExpanded {
            memoLabel.numberOfLines = 0
        }else{
            memoLabel.numberOfLines = 1
        }
    }
    
    func expandMemo() {
        isExpanded.toggle()
        memoLabel.numberOfLines = isExpanded ? 0 : 1
        setNeedsLayout()
    }
    
    func updateConstarints() {
        super.updateConstraints()
        if memoViewHeightConstraint == nil {
            memoView.snp.makeConstraints { make in
                memoViewHeightConstraint = make.height.equalTo(calculateMemoViewHeight()).constraint
            }
        } else {
            memoViewHeightConstraint?.update(offset: calculateMemoViewHeight())
        }
        
        super.updateConstraints()
        
    }
    
    private func calculateMemoViewHeight() -> CGFloat {
        let labelSize = memoLabel.sizeThatFits(CGSize(width: memoView.bounds.width, height: .greatestFiniteMagnitude))
        return min(labelSize.height + 20, isExpanded ? .greatestFiniteMagnitude : 44)
    }
    
    //MARK: - 메모 더 보기
    @objc func memoLabelTapped() {
        memoExpand?()
    }
    
    
    //MARK: - objc func
    // 방해금지모드
    @objc func clicktoggle() {
        patchDisturb(newDisturbMode: !disturb)
    }
    
    //수정하기 버튼 클릭시
    var editweek: [String] = []
    
    var selectedTime24 : String = ""
    
    var isLeader : Bool = false
    
    @objc func clickSetting() {
        guard let parentViewController = self.parentVC else {
            return
        }
        
        var vc: UIViewController
        
        if isLeader {
            let leaderVC = LeaderMenuViewController()
            leaderVC.groupId = self.groupId
            leaderVC.participantCode = self.participantcode
            vc = leaderVC
            print("리더 메뉴")
            
            leaderVC.menuClicked = { [weak self] in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    // AlterUIView 알람 삭제 설정
                    let alterVC = AlterUIView(alterType: .deleteAlarm)
                    alterVC.groupId = self.groupId
                    alterVC.modalPresentationStyle = .overFullScreen
                    alterVC.modalTransitionStyle = .crossDissolve
                    
                    alterVC.confirmAction = { [weak self] in
                        self?.onAlarmDelete?()
                    }
                    
                    parentViewController.present(alterVC, animated: true, completion: nil)
                }
            }
            
            leaderVC.onEdit = { [weak self] in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    let makeVC = MakeAlarmViewController()
                    makeVC.groupId = self.groupId
                    makeVC.mode = .editMode
                    makeVC.groupTextfield.text = self.topViewLabel.text
                    makeVC.memoTextView.text = self.fullText
                    makeVC.memoPlaceholder.isHidden = true
                    
                    makeVC.selectedDayOfWeek = self.editweek
                    makeVC.editTime = self.time24
                    
                    
                    parentViewController.navigationController?.pushViewController(makeVC, animated: true)
                }
            }
            
            
            leaderVC.modalPresentationStyle = .formSheet
            parentViewController.present(vc, animated: true)
            
            if let sheetVC = leaderVC.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheetVC.detents = [.custom { context in return 260 }]
                    sheetVC.delegate = self
                    sheetVC.prefersGrabberVisible = false
                    sheetVC.preferredCornerRadius = 16
                }
            }
            
        } else {
            // 방장이 아닐 때 FollowerMenuViewController 생성
            let followerVC = FollowerMenuViewController()
            followerVC.groupId = self.groupId
            followerVC.participantCode = self.participantcode
            vc = followerVC
            print("팔로워 메뉴")
            
            followerVC.menuClicked = { [weak self] in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    let alterVC = AlterUIView(alterType: .outGroup)
                    alterVC.groupId = self.groupId
                    alterVC.modalPresentationStyle = .overFullScreen
                    alterVC.modalTransitionStyle = .crossDissolve
                    
                    alterVC.confirmAction = { [weak self] in
                        self?.onAlarmLeave?()
                    }
                    
                    parentViewController.present(alterVC, animated: true, completion: nil)
                }
            }
            
            followerVC.modalPresentationStyle = .formSheet
            parentViewController.present(vc, animated: true)
            
            if let sheetVC = followerVC.sheetPresentationController {
                if #available(iOS 16.0, *) {
                    sheetVC.detents = [.custom { context in return 200 }]
                    sheetVC.delegate = self
                    sheetVC.prefersGrabberVisible = false
                    sheetVC.preferredCornerRadius = 16
                }
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
        
        cell.backgroundColor = .clear
        
        let userlistData = userData[indexPath.item]
        
        cell.configureMember(with: userlistData.nickname,imageURL: userlistData.imageURL ?? "",isDisturbBanMode: userlistData.isDisturbBanMode,isWakeup: userlistData.isWakeup)
        
        return cell
    }
    
    //그룹내의 셀 크기 = 이미지 + 라벨
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 62, height: collectionViewHeight)
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
        
        let selectedUser = userData[indexPath.item]
        vc.nicknameLabel.text = selectedUser.nickname
        vc.userphoneNum = selectedUser.phone
        vc.userId = selectedUser.userID
        vc.isagree = selectedUser.isAgree
        
        // 유저 이미지 설정
        if let imageURLString = selectedUser.imageURL, !imageURLString.isEmpty, let url = URL(string: imageURLString) {
            // Kingfisher를 사용하여 이미지 다운로드 및 둥근 모서리 적용 처리
            let placeholderImage = UIImage(named: "profile")
            let processor = RoundCornerImageProcessor(cornerRadius: 50) // 둥근 모서리
            
            // Kingfisher 이미지 설정
            vc.userImage.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)]) {
                result in
                switch result {
                case .success(let value):
                    print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                case .failure( _):
                    vc.userImage.image = placeholderImage
                }
            }
        } else {
            // imageURL이 nil이거나 빈 문자열일 경우 기본 이미지 설정
            vc.userImage.image = UIImage(named: "profile")
        }
        
        
        
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

class memberCollectioViewCell: UICollectionViewCell {
    
    lazy var memberView: UIView = {
        let view = UIImageView()
        //        view.backgroundColor = DesignSystemColor.Orange500.value
        view.layer.cornerRadius = 31
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.addSubview(memberIMG)
        return view
    }()
    
    lazy var memberIMG : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "profile")
        view.layer.cornerRadius = 29
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var memberLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_SemiBold12.value
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - 나에요
    
    private lazy var meView : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Orange500.value
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.addSubview(meLabel)
        return view
    }()
    
    private lazy var meLabel : UILabel = {
        let label = UILabel()
        label.text = "ME"
        label.font = DesignSystemFont.Pretendard_Bold8.value
        label.textColor = .white
        return label
    }()
    
    
    //MARK: - 자는중 일 경우 view
    private lazy var sleepView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 31
        view.addSubview(sleepLabel)
        return view
    }()
    
    private lazy var sleepLabel : UILabel = {
        let label = UILabel()
        label.text = "자는 중..."
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.textColor = .white
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubviews(memberView, memberLabel, meView, sleepView)
        
        memberView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(62)
        }
        
        memberIMG.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.width.equalTo(58)
        }
        
        memberLabel.snp.makeConstraints {
            $0.top.equalTo(memberView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        meView.snp.makeConstraints{
            $0.height.equalTo(14)
            $0.width.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(memberView.snp.bottom).offset(4)
        }
        meLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        sleepView.snp.makeConstraints{
            $0.height.width.equalTo(62)
            $0.center.equalTo(memberView)
        }
        
        sleepLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        
    }
    
    //MARK: - 닉네임, 유저 스테이트 설정
    func configureMember(with nickname: String, imageURL: String, isDisturbBanMode: Bool, isWakeup: Bool) {
        
        memberLabel.text = nickname
        
        //이미지URL 다운
        if imageURL == imageURL, !imageURL.isEmpty {
            let url = URL(string: imageURL)
            let placeholderImage = UIImage(named: "profile")
            let processor = RoundCornerImageProcessor(cornerRadius: 29)
            memberIMG.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
            
        } else {
            memberIMG.image = UIImage(named: "profile")
        }
        
        //meView
        if nickname == UserDefaults.standard.string(forKey: "nickname"){
            meView.isHidden = false
        } else {
            meView.isHidden = true
        }
        
        
        if isDisturbBanMode{ //방해금지모드가 켜져있음
            memberView.backgroundColor = DesignSystemColor.Gray300.value
            memberLabel.textColor = DesignSystemColor.Gray500.value
            meView.backgroundColor = DesignSystemColor.Gray150.value
        }else{              //방해금지모드가 꺼져있음
            meView.backgroundColor = DesignSystemColor.Orange500.value
            memberView.backgroundColor = DesignSystemColor.Orange500.value
            
            if isWakeup{ //일어남
                sleepView.isHidden = true
                memberLabel.textColor = .black
                memberView.backgroundColor = DesignSystemColor.Orange500.value
            } else {     //자는 중
                sleepView.isHidden = false
                memberView.backgroundColor = .white
                memberLabel.textColor = .black
            }
            
        }
        
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

