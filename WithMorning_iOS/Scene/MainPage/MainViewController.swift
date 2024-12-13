//
//  MainViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import SnapKit
import Then
import Alamofire
import Kingfisher
import UserNotifications

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    let APInetwork = Network.shared
    
    //MARK: - properties
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = DesignSystemColor.Black.value
        return label
    }()
    
    private lazy var profileButton : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 18
        view.isUserInteractionEnabled = true
        view.clipsToBounds  = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedprofile))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
    }()
    
    private lazy var soundButton: UIButton = {
        let button = UIButton()
        let volume = UserDefaults.standard.float(forKey: "volume", default: 50.0)
        button.setImage(UIImage(named: volume == 0 ? "Volumeoff" : "Volumeon"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(soundclick), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - tableView
    private lazy var headerView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var alarmButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        
        button.setTitle("  새로운 알람 설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.setImage(UIImage(named: "plus"), for: .highlighted)
        
        button.tintColor = .white
        button.clipsToBounds = true
        
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(clickedmakeAlarm), for: .touchUpInside)
        return button
    }()
    
    private lazy var codeButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.setBackgroundColor(.white.adjustBrightness(by: 0.8), for: .highlighted)
        
        button.setTitle("   참여 코드 입력", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold14.value
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "codebutton"), for: .normal)
        button.setImage(UIImage(named: "codebutton"), for: .highlighted)
        button.clipsToBounds = true
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(clickedcode), for: .touchUpInside)
        return button
    }()
    
    lazy var AlarmTableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var tableViewRefresh : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.endRefreshing()
        refresh.addTarget(self, action: #selector(refreshControl), for: .valueChanged)
        return refresh
    }()
    
    //MARK: - 알람이 하나도 없을때 뜨는 뷰
    private lazy var emptyView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(emptyimage)
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyimage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "empty")
        return view
    }()
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        tableSetting()
        SetUI()
        emptycellcheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMainpage()
        updateSoundButtonImage()
        checkNotificationPermission()
    }
    
    //MARK: - UI
    func SetUI(){
        view.addSubviews(nameLabel,profileButton,soundButton,AlarmTableView,emptyView)
        
        headerView.addSubview(headerStackView)
        
        headerStackView.addSubviews(alarmButton,codeButton)
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().inset(16)
        }
        
        profileButton.snp.makeConstraints{
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        soundButton.snp.makeConstraints{
            $0.centerY.equalTo(profileButton)
            $0.height.width.equalTo(36)
            $0.trailing.equalTo(profileButton.snp.leading).offset(-16)
        }
        
        headerStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        alarmButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        codeButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(alarmButton.snp.bottom).offset(8)
            $0.height.equalTo(56)
        }
        
        AlarmTableView.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(27)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(AlarmTableView)
        }
        emptyimage.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        
    }
    
    //MARK: - tableSetting
    func tableSetting(){
        AlarmTableView.dataSource = self
        AlarmTableView.delegate = self
        
        AlarmTableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")
        
        AlarmTableView.translatesAutoresizingMaskIntoConstraints = false
        AlarmTableView.tableHeaderView = headerView
        AlarmTableView.backgroundColor = DesignSystemColor.Gray150.value
        AlarmTableView.separatorStyle = .none
        AlarmTableView.refreshControl = tableViewRefresh
        
        AlarmTableView.rowHeight = UITableView.automaticDimension
        
        headerView.layoutIfNeeded()
        
        let alarmButtonHeight: CGFloat = 56
        let codeButtonHeight: CGFloat = 56
        let spacing: CGFloat = 8 //headerview와 cell간격
        
        let headerStackViewHeight = alarmButtonHeight + codeButtonHeight + spacing + 8
        
        // HeaderView의 크기 설정
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerStackViewHeight)
        
        // HeaderStackView의 크기 설정
        headerStackView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerStackViewHeight)
        
    }
    
    //MARK: - 알람 권한 설정 유무
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    print("🔔 알림 권한 허용됨")
                case .denied:
                    print("🔕 알림 권한 거부됨")
                    self.presentSetting()
                case .notDetermined:
                    print("❓ 알림 권한 아직 결정되지 않음")
                    self.presentSetting()
                case .provisional:
                    print("📳 알림 권한 임시 허용")
                case .ephemeral:
                    print("⏳ 알림 권한 임시 허용 (앱 클립)")
                @unknown default:
                    print("❌ 알림 권한 상태 알 수 없음")
                    self.presentSetting()
                }
            }
        }
    }
    
    //MARK: - 알람권한 설정 present
    func presentSetting(){
        let vc = NotificationPermission()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        // 애니메이션과 함께 표시
        UIView.animate(withDuration: 0.3) {
            self.present(vc, animated: true)
        }
    }
    
    
    
    //MARK: - objc func
    @objc func refreshControl(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableViewRefresh.endRefreshing()
            self.getMainpage()
        }
    }
    
    @objc func clickedprofile(_ sender: UITapGestureRecognizer){
        let vc = MyPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickedmakeAlarm(){ //새로운 알람 설정
        let vc = MakeAlarmViewController()
        vc.mode = .createMode
        vc.username = UserDefaults.standard.string(forKey: "nickname") ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickedcode() { //참여코드입력
        let vc = CodeBtnViewController()
        vc.modalPresentationStyle = .formSheet
        
        vc.participantClosure = { [weak self] in
            self?.getMainpage()
            self?.showToast(message: "그룹에 참여하였습니다.")
        }
        
        self.present(vc, animated: true)
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { context in
                    return 245 //고정
                    
                }]
                
                sheet.delegate = self
                sheet.prefersGrabberVisible = false
                sheet.preferredCornerRadius = 16
            }
        }
    }
    
    func updateSoundButtonImage() {
        let volume = UserDefaults.standard.float(forKey: "volume", default: 50.0)
        soundButton.setImage(UIImage(named: volume == 0 ? "Volumeoff" : "Volumeon"), for: .normal)
    }
    
    @objc func soundclick() {
        let vc = AlarmSoundViewController()
        vc.volume = { [weak self] value in
            self?.handleVolumeChange(UserDefaults.standard.float(forKey: "volume"))
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleVolumeChange(_ value: Float) {
        if value == 0 {
            soundButton.setImage(UIImage(named: "Volumeoff"), for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "Volumeon"), for: .normal)
        }
    }
    
    
    //MARK: - API
    func getMainpage() {
        LoadingIndicator.showLoading()
        
        print("🔥키체인에 들어있는 refreshToken",KeyChain.read(key: "refreshToken") ?? "")
        print("🔥키체인에 들어있는 accessToken",KeyChain.read(key: "accessToken") ?? "")
        print("🔥키체인에 들어있는 fcmToken",KeyChain.read(key: "fcmToken") ?? "")
        
        UIView.performWithoutAnimation{
            APInetwork.getMainpage() { result in
                switch result {
                case .success(let mainpage):
                    self.MainpageUpdate(with: mainpage)
                    print(mainpage)
                    self.nameLabel.text = "Hi, \(mainpage.connectorNickname)"
                    if ((mainpage.connectorProfileURL?.isEmpty) != nil) {
                        // 이미지 URL이 유효한 경우: 이미지 다운로드 처리
                        let url = URL(string: mainpage.connectorProfileURL ?? "")
                        let placeholderImage = UIImage(named: "profile")
                        let processor = RoundCornerImageProcessor(cornerRadius: 29)
                        
                        self.profileButton.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
                        
                    } else {
                        self.profileButton.image = UIImage(named: "profile") // 기본 이미지로 설정
                    }
                    AlarmManager.shared.updateAlarm(from: self.alarmData)
                    self.AlarmTableView.reloadData()
                    self.emptycellcheck()
                    LoadingIndicator.hideLoading()
                    
                case .failure(let error):
                    self.AlarmTableView.reloadData()
                    LoadingIndicator.hideLoading()
                    self.showToast(message: "오류가 발생했습니다. 잠시후 다시 시도해주세요.")
                    print(error)
                    
                }
            }
        }
    }
    //MARK: - 텅 뷰
    func emptycellcheck(){
        emptyView.isHidden = !alarmData.isEmpty
    }
    
    //MARK: - Data Array
    var alarmData  : [GroupList] = []
    var isExpanded: Bool = false
    var isExpandedStates: [Int: Bool] = [:]  // indexPath.row를 키로 사용
    
    func MainpageUpdate(with mainpage: MainpageResponse){
        guard let groupList = mainpage.groupList else {
            return
        }
        self.alarmData = groupList
        DispatchQueue.main.async {
            self.AlarmTableView.reloadData()
        }
    }
    
    func checkIfCurrentUserIsLeader(userList: [UserList], currentUserNickname: String) -> Bool {
        // UserList에서 첫 번째 유저의 닉네임과 현재 유저의 닉네임을 비교
        guard let leader = userList.first else { return false }
        return leader.nickname == currentUserNickname
    }
    
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = alarmData.count
        self.emptycellcheck()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = AlarmTableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {return UITableViewCell()}
        
        let alarm = alarmData[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.topViewLabel.text = alarm.name
        
        cell.ConfigureMember(alarm.userList ?? [])
        cell.time24 = alarm.wakeupTime
        
        cell.groupId = alarm.groupID
        
        cell.participantcode = alarm.participationCode
        
        //알림이 설정되어있는 요일의 색
        let dayLabels = [cell.MonLabel, cell.TueLabel, cell.WedLabel, cell.ThuLabel, cell.FriLabel, cell.SatLabel, cell.SunLabel]
        
        let days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
        
        for (index, dayLabel) in dayLabels.enumerated() {
            if let dayOfWeekList = alarm.dayOfWeekList, dayOfWeekList.contains(days[index]) {
                dayLabel.backgroundColor = DesignSystemColor.Orange500.value
                dayLabel.textColor = .white
                cell.editweek = alarm.dayOfWeekList ?? []
                
            } else {
                dayLabel.backgroundColor = DesignSystemColor.Gray100.value
                dayLabel.textColor = DesignSystemColor.Gray300.value
            }
        }
        
        //알람 삭제 후 실행되는 클로저
        cell.onAlarmDelete = { [weak self] in
            self?.getMainpage()
            
        }
        //알람을 나간 후 실행되는 클로저
        cell.onAlarmLeave = { [weak self] in
            self?.getMainpage()
        }
        
        //토클 클릭시 실행되는 클로저
        cell.toggleclicked = { [weak self] in
            if alarm.isDisturbBanGroup{
                cell.bottomView.isHidden = true
                self?.getMainpage()
            }else{
                cell.bottomView.isHidden = false
                self?.getMainpage()
            }
        }
        
        
        //내가 리더인지 아닌지 체크
        cell.configureCell(with: alarm, currentUserNickname: UserDefaults.standard.string(forKey: "nickname") ?? "")
        
        let currentUserNickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        
        let isLeader = checkIfCurrentUserIsLeader(userList: alarm.userList ?? [], currentUserNickname: currentUserNickname)
        
        if isLeader {
            cell.isLeader = true
        } else {
            cell.isLeader = false
        }
        
        //메모 텍스트
        cell.setMemoText(alarm.memo)
        
        //더보기
        cell.Expandclosure = { [weak tableView] isExpanded in
            UIView.performWithoutAnimation {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        
        return cell
    }
    
    //MARK: - cell높이 지정
    // heightForRowAt에서 isExpanded 상태를 기반으로 셀 높이 계산
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let alarm = alarmData[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as? AlarmTableViewCell
        
        let baseHeight: CGFloat = 130  // 기본 높이
        let extraHeight: CGFloat = 250 // 멤버 컬렉션 뷰 등의 추가 높이
        
        // 메모가 없거나 방해 금지 모드인 경우 기본 처리
        guard let memo = alarm.memo as String?, !memo.isEmpty, !alarm.isDisturbBanGroup else {
            return baseHeight
        }
        
        let characterLimit = 19 //1줄 최대 글자 수
        let lines = memo.components(separatedBy: "\n")
        var actualNumberOfLines = lines.count
        
        // 각 줄이 characterLimit을 초과하는 경우 추가 줄 수 계산
        for line in lines {
            if line.count > characterLimit {
                let additionalLines = Int(ceil(Double(line.count) / Double(characterLimit))) - 1
                actualNumberOfLines += additionalLines
            }
        }
        
        // 접힌 상태에서는 추가 높이만
        if !(cell?.isExpanded ?? false) {
            return baseHeight + extraHeight
        }
        
        // 펼쳐진 상태에서 메모 높이 계산
        let memoHeight: CGFloat
        if actualNumberOfLines == 1 && (memo.count <= characterLimit) {
            memoHeight = 0  // 16글자 이하의 한 줄일 때는 추가 높이 없음
        } else {
            switch actualNumberOfLines {
            case 1:
                memoHeight = 20  // 16글자 초과하는 한 줄
            case 2:
                memoHeight = 23  // 두 줄
            case 3:
                memoHeight = 40  // 세 줄 이상
            default :
                memoHeight = CGFloat(15*actualNumberOfLines)
            }
        }
        return baseHeight + extraHeight + memoHeight
    }
    
    // 셀 확장/축소 처리
    func toggleExpansion(for indexPath: IndexPath) {
        // 해당 셀의 확장 상태를 토글
        isExpandedStates[indexPath.row] = !(isExpandedStates[indexPath.row] ?? false)
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let alarmCell = cell as? AlarmTableViewCell {
            alarmCell.isExpanded = false
        }
    }
}
//Preview code
#if DEBUG
import SwiftUI
struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        MainViewController()
    }
}
@available(iOS 13.0, *)
struct cabBarViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                MainViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
