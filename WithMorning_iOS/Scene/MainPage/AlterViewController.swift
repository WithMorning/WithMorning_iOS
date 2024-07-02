//
//  AlterViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/1/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

protocol AlterDelegate {
    func confirm()
    func cancel()
}


enum Altertype {
    case deleteAlarm
    case outGroup
}

class AlterViewController: UIViewController {
    
    var alterType : Altertype
    var delegate : AlterDelegate?
    
    
    init(alterType: Altertype) {
        self.alterType = alterType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var AlterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubviews(MainLabel, SubLabel, confirmButton, cancelButton)
        return view
    }()
    
    private lazy var MainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_SemiBold16.value
        return label
    }()
    
    private lazy var SubLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DesignSystemColor.Gray600.value
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // 원하는 행간 간격을 설정
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(string: "삭제시 모든 메이트의 알람이 삭제처리됩니다. \n미리 전달해 주세요.",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = DesignSystemColor.Gray200.value
        button.setTitleColor(DesignSystemColor.Gray500.value, for: .normal)
        button.addTarget(self, action: #selector(cancelclicked), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = DesignSystemColor.Orange500.value
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirmclicked), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        SetUI()
        types()
    }
    
    func SetUI() {
        view.addSubview(AlterView)
        
        AlterView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(190)
            $0.width.equalTo(343)
        }
        
        MainLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        SubLabel.snp.makeConstraints{
            $0.top.equalTo(MainLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(52)
            $0.width.equalTo(146)
            
        }
        
        confirmButton.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(52)
            $0.width.equalTo(146)
            
        }
    }
    
    func types() {
        switch alterType {
            
        case .deleteAlarm:
            MainLabel.text = "해당 알람을 삭제하시겠습니까?"
//            SubLabel.text = "삭제시 모든 메이트의 알람이 삭제처리됩니다. \n미리 전달해 주세요."
            
        case .outGroup:
            MainLabel.text = "해당 모임에서 나가시겠습니까?"
            SubLabel.isHidden = true
        }
    }
    
    @objc func cancelclicked(){
        self.dismiss(animated: true) {
            self.delegate?.cancel()
            print("취소버튼")
        }
    }
    @objc func confirmclicked(){
        self.dismiss(animated: true) {
            self.delegate?.confirm()
            print("확인버튼")
        }
    }
}
extension AlterDelegate where Self: UIViewController {
    
    func show(alertType: Altertype) {
        let viewController = AlterViewController(alterType: alertType)
        viewController.delegate = self
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        self.present(viewController, animated: true, completion: nil)
    }
}
