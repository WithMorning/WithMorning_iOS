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
    
    private lazy var tutorialLabel : UILabel = {
        let label = UILabel()
        label.text = "반복하고 싶은 요일을 선택해 주세요!"
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = DesignSystemColor.Gray500.value
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUI()
    }
    
    func setUI(){
        view.addSubviews(tutorialLabel)
        
        tutorialLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
}
