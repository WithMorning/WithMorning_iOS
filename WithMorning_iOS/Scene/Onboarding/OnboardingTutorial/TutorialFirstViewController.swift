//
//  TutorialFirstViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/25/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class TutorialFirstViewController : UIViewController {
    
    private lazy var tutorialLabel : UILabel = {
        let label = UILabel()
        label.text = "기상하고 싶은 시간이 언제인가요?"
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
