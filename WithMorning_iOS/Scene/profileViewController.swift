//
//  profileViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 5/8/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class profileViewController : UIViewController {
    
    var colorclicked : ( () -> Void ) = {}
    
    private lazy var originalButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.mainColor.value
        button.layer.cornerRadius = 50
        button.addTarget(self, action: #selector(maintouch), for: .touchUpInside)
        return button
    }()
    
    private lazy var grayButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignSystemColor.settingGray.value
        button.layer.cornerRadius = 50
        button.addTarget(self, action: #selector(greytouch), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUI()
    }
    
    func SetUI(){
        view.addSubviews(originalButton,grayButton)
        
        originalButton.snp.makeConstraints{
            $0.height.width.equalTo(100)
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(50)
        }
        grayButton.snp.makeConstraints{
            $0.height.width.equalTo(100)
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().inset(50)
        }
    }
    @objc func maintouch(){
        print("메인컬러")
        colorclicked()
        
    }
    
    @objc func greytouch(){
        print("회색")
        colorclicked()
    }
    
}

