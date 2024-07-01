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

class AlterViewController: UIViewController {
    
    private lazy var AlterView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubviews(MainLabel,SubLabel,confirmButton,cancelButton)
        return view
    }()
    
    private lazy var MainLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    private lazy var SubLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var confirmButton : UIButton = {
        let button = UIButton()
        return button
    }()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        SetUI()
    }
    
    func SetUI(){
        view.addSubview(AlterView)
    }
    
    
}
