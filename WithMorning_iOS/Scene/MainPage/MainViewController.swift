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
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitle("  새로운 알람 설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.addTarget(self, action: #selector(clickedmakeAlarm), for: .touchUpInside)
        return button
    }()
    
    private lazy var codeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("   참여 코드 입력", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitleColor(DesignSystemColor.Black.value, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "codebutton"), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.addTarget(self, action: #selector(clickedcode), for: .touchUpInside)
        return button
    }()
    
    lazy var AlarmTableView : UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 8
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
    
    //메인페이지
    func getMainpage() {
        LoadingIndicator.showLoading()
        
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
                self.AlarmTableView.reloadData()
                self.emptycellcheck()
                
                LoadingIndicator.hideLoading()
            case .failure(let error):
                
                self.AlarmTableView.reloadData()
                LoadingIndicator.hideLoading()
                print(error)
                
            }
        }
    }
    //MARK: - 텅 뷰
    
    func emptycellcheck(){
        emptyView.isHidden = !alarmData.isEmpty
    }
    
    //MARK: - Data Array
    var alarmData  : [GroupList] = []
    
    //API뿌려주기.
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
            //            cell.isDisturbBanGroup = alarm.isDisturbBanGroup
            //            self?.AlarmTableView.beginUpdates()
            //            self?.AlarmTableView.endUpdates()
            //            self?.getMainpage()
            
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
        
        //메모 크기
        cell.setMemoText(alarm.memo)
        
        cell.memoExpand = { [weak self] in
            self?.AlarmTableView.beginUpdates()
            cell.expandMemo()
            self?.AlarmTableView.endUpdates()
        }
        
        return cell
    }
    
    //cell의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let alarm = alarmData[indexPath.row]
        
        let baseHeight: CGFloat = 130  // 기본 높이
        let extraHeight: CGFloat = 217 // 멤버 컬렉션 뷰 등의 추가 높이
        
        // 셀의 isDisturbBanGroup 상태에 따라 높이를 다르게 설정
        if alarm.isDisturbBanGroup {
            return baseHeight // 방해 금지 모드가 켜져있으면 기본 높이만 반환
        } else {
            return baseHeight + extraHeight // 방해 금지 모드가 꺼져있으면 추가 높이를 포함한 값을 반환
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
