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

class AlarmTableViewCell : UITableViewCell {
    
    //MARK: - properties
    
    let cellLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let toggleButton : UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = DesignSystemColor.mainColor.value
        toggle.addTarget(self, action: #selector(clicktoggle(sender:)), for: .touchUpInside)
        return toggle
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SetCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    func SetCell(){
        contentView.addSubviews(cellLabel,toggleButton)
        
        contentView.layer.cornerRadius = 8
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        cellLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - objc func
    @objc func clicktoggle(sender : UISwitch){

        if toggleButton.isOn {
            print("senderOn")
        } else {
            print("senderOFF")
        }
    
    }
    
    
}
