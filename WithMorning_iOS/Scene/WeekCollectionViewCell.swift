//
//  WeekCollectionViewCell.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/26/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class WeekCollectionViewCell : UICollectionViewCell {
    
    static let id = "WeekCollectionViewCell"
    
    let weekLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_SemiBold10.value
        label.textColor = DesignSystemColor.White.value
        label.backgroundColor = DesignSystemColor.Orange500.value
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    func setUI(){
        contentView.addSubviews(weekLabel)
        
        weekLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
}
