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

class SleepTimeViewController : UIViewController {
    
    //MARK: - properties
    
    private lazy var timeLabel : UILabel = {
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
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        SetUI()
        
    }
    //MARK: - setUI
    
    func SetUI(){
        view.addSubviews(timeLabel,popButton)
        
        timeLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(timeLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
    }
    
    //MARK: - objc func
    
    @objc func popclicked(){
        self.navigationController?.popViewController(animated: true)
        print("pop")
    }
    
}

