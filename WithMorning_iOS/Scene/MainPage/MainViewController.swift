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

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    //MARK: - properties
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "HI, WithMorning"
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = DesignSystemColor.Black.value
        return label
    }()
    
    private lazy var profileButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.layer.cornerRadius = 18
        button.tintColor = .white
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(clickedprofile), for: .touchUpInside)
        return button
    }()
    
    private lazy var soundButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Volumeon"), for: .normal)
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
        button.setTitle("  새로운 알람설정", for: .normal)
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
    
    private lazy var floatingButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = DesignSystemColor.Black.value
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        return button
    }()
    
    private lazy var AlarmTableView : UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 8
        return tableView
    }()
    
    //리프레쉬컨트롤
//    private lazy var tableViewRefresh : UIRefreshControl = {
//        let refresh = UIRefreshControl()
//        refresh.endRefreshing()
//        refresh.addTarget(self, action: #selector(refreshControl), for: .valueChanged)
//        return refresh
//    }()
    
    
    //MARK: - Data Array
    
    var alarmData  : [AlarmModel] = [AlarmModel(isTurn: false,alarmTitle: "1번째 알람의 타이틀",Memo: "1번재 알람의 메모", memberCount: 4),AlarmModel(isTurn: false,alarmTitle: "2번째 알람의 타이틀",Memo: "2번째 알람의 메모", memberCount: 3)]
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        tableSetting()
        SetUI()
    }
    
    //MARK: - UI
    func SetUI(){
        view.addSubviews(nameLabel,profileButton,soundButton,AlarmTableView)
        
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
        
        //        floatingButton.snp.makeConstraints{
        //            $0.width.height.equalTo(50)
        //            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        //            $0.trailing.equalToSuperview().inset(16)
        //        }
        
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
        
        AlarmTableView.rowHeight = 108 //cell높이
        AlarmTableView.estimatedRowHeight = UITableView.automaticDimension
//        AlarmTableView.refreshControl = tableViewRefresh
        
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
    
    @objc func clickedprofile(){ //프로필버튼
        let vc = MyPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickedmakeAlarm(){ //새로운 알람설정
        let vc = MakeAlarmViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        showToast(message: "상하 좌우 16만큼 이동함용", delayTime: 0.9)
        AlarmTableView.reloadData()
    }
    
    @objc func clickedcode() { //참여코드입력
        let vc = CodeBtnViewController()
        vc.modalPresentationStyle = .formSheet
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
    
    @objc func soundclick(){
        let vc = AlarmSoundViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    @objc func refreshControl(){
//        print("refreshTable")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.AlarmTableView.reloadData()
//            self.tableViewRefresh.endRefreshing()
//        }
//    }
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = AlarmTableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {return UITableViewCell()}
        
        let alarm = alarmData[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.topViewLabel.text = alarm.alarmTitle
        cell.memoLabel.text = alarm.Memo
        cell.memberCount = alarm.memberCount
        
        // 토글의 상태를 데이터 모델로부터 가져와 설정
        cell.toggleButton.isOn = alarm.isTurn
        cell.bottomView.isHidden = !alarm.isTurn
        cell.bottomView.subviews.forEach { $0.isHidden = !alarm.isTurn }
        
        if cell.toggleButton.isOn == true{
            self.alarmData[indexPath.row].isTurn = true
            //            print(self.alarmData[indexPath.row])
            cell.bottomView.isHidden = false
            //월
            cell.MonLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.MonLabel.textColor = .white
            //화
            cell.TueLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.TueLabel.textColor = .white
            //수
            cell.WedLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.WedLabel.textColor = .white
            //목
            cell.ThuLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.ThuLabel.textColor = .white
            //금
            cell.FriLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.FriLabel.textColor = .white
            //토
            cell.SatLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.SatLabel.textColor = .white
            //일
            cell.SunLabel.backgroundColor = DesignSystemColor.Orange500.value
            cell.SunLabel.textColor = .white
            
        }else{
            self.alarmData[indexPath.row].isTurn = false
            //            print(self.alarmData[indexPath.row])
            cell.bottomView.isHidden = true
            
            cell.MonLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.MonLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.TueLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.TueLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.WedLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.WedLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.ThuLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.ThuLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.FriLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.FriLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.SatLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.SatLabel.textColor = DesignSystemColor.Gray300.value
            
            cell.SunLabel.backgroundColor = DesignSystemColor.Gray100.value
            cell.SunLabel.textColor = DesignSystemColor.Gray300.value
            
        }
        
        // togglebutton on,off closure
        cell.toggleclicked = {
            
            self.AlarmTableView.reloadData()
            
            if cell.toggleButton.isOn == true{
                self.alarmData[indexPath.row].isTurn = true
                //                print(self.alarmData[indexPath.row])
                cell.bottomView.isHidden = false
                
            }else{
                self.alarmData[indexPath.row].isTurn = false
                //                print(self.alarmData[indexPath.row])
                cell.bottomView.isHidden = true
                
            }
        }
        
        return cell
    }
    
    //cell의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let baseHeight: CGFloat = 132
        let extraHeight: CGFloat = 217
        
        if alarmData[indexPath.row].isTurn {
            return baseHeight + extraHeight
        } else {
            return baseHeight
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
