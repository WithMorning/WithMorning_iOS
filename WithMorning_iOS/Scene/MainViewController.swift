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

class MainViewController: UIViewController {

//MARK: - properties
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "HI, 율무엄마"
        label.font = DesignSystemFont.Pretendard_Bold20.value
        label.textColor = DesignSystemColor.fontBlack.value
        return label
    }()
    
    private lazy var settingButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.settingGray.value
        button.setTitle("설정", for: .normal)
        button.titleLabel?.font =  DesignSystemFont.Pretendard_Bold12.value
        button.setTitleColor(DesignSystemColor.fontBlack.value, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(clickedSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerView : UIView = {
       let view = UIView()
        return view
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var alarmButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.mainColor.value
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitle("  새로운 알람설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        button.addTarget(self, action: #selector(clickedmakeAlarm), for: .touchUpInside)
        return button
    }()
    
    private lazy var codeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("참여 코드 입력", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Bold14.value
        button.setTitleColor(DesignSystemColor.fontBlack.value, for: .normal)
        button.layer.cornerRadius = 8
        button.setImage(UIImage(named: "codebutton"), for: .normal)
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        button.addTarget(self, action: #selector(clickedcode), for: .touchUpInside)
        return button
    }()
    
    private lazy var AlarmTableView : UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 8
        return tableView
    }()
    
    var alarmCount : Int = 4 //셀 개수
    var alarmLabel  = [1,2,3,4]

//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.backgroundColor.value
        tableSetting()
        SetUI()
    }
    
//MARK: - UI

    func SetUI(){
        view.addSubviews(nameLabel,settingButton,AlarmTableView)
        headerView.addSubview(headerStackView)
        headerStackView.addSubviews(alarmButton,codeButton)
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            $0.leading.equalToSuperview().inset(16)
        }
        
        settingButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(45)
            $0.height.equalTo(30)
        }
        
        headerStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            //$0.height.equalTo(alarmButton.snp.height*2)
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
    }
//MARK: - tableSetting
    func tableSetting(){
        AlarmTableView.dataSource = self
        AlarmTableView.delegate = self
        AlarmTableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")
        //AlarmTableView.headerView(forSection: 1)
        AlarmTableView.translatesAutoresizingMaskIntoConstraints = false
        AlarmTableView.tableHeaderView = headerView
        AlarmTableView.backgroundColor = DesignSystemColor.backgroundColor.value
        AlarmTableView.separatorStyle = .none
        headerView.layoutIfNeeded()
        
        let alarmButtonHeight: CGFloat = 56
            let codeButtonHeight: CGFloat = 56
            let spacing: CGFloat = 8
            let headerStackViewHeight = alarmButtonHeight + codeButtonHeight + spacing
            
            // HeaderView의 크기 설정
            headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerStackViewHeight)
            
            // HeaderStackView의 크기 설정
            headerStackView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerStackViewHeight)
        
    }


//MARK: - objc func
    
    @objc func clickedSetting(){ //설정버튼
        print("세팅버튼 : 아왜요 시2ㅏ발")
    }
    
    @objc func clickedmakeAlarm(){ //새 알람설정
        print("알람생성버튼 : 아왜불러")
        alarmCount = alarmCount + 1
        alarmLabel.append(alarmCount)
        print(alarmCount)
        AlarmTableView.reloadData()
    }
    
    @objc func clickedcode(){ //참여코드입력
        print("참여코드버튼 : 아왜요")
    }

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = AlarmTableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {return UITableViewCell()}
        

        cell.selectionStyle = .none
        cell.cellLabel.text = String(alarmLabel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    
}

#if DEBUG
import SwiftUI
struct Preview3: UIViewControllerRepresentable {
    
    // 여기 ViewController를 변경해주세요
    func makeUIViewController(context: Context) -> UIViewController {
        MainViewController()
    }
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
}

struct ViewController_PreviewProvider3: PreviewProvider {
    static var previews: some View {
        Group {
            Preview3()
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Preview")
        }
    }
}
#endif
