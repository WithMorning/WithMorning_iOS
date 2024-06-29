//
//  codeBtnViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/29/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class codeBtnViewController: UIViewController {
    
//MARK: - properties
    private lazy var codeLabel : UILabel = {
        let label = UILabel()
        label.text = "참여 코드 입력"
        label.textColor = .black
        label.textAlignment = .center
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()

    private lazy var codeTextfield : UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "코드를 입력해 주세요"
        textfield.backgroundColor = DesignSystemColor.Gray150.value
        textfield.font = DesignSystemFont.Pretendard_Medium14.value
        textfield.textColor = DesignSystemColor.Gray400.value
        textfield.layer.cornerRadius = 8
        textfield.textAlignment = .center
        return textfield
    }()

    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        SetUI()
        
    }
    
    func SetUI(){
        view.addSubviews(codeLabel,codeTextfield)
        
        codeLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        codeTextfield.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(codeLabel.snp.bottom).offset(10)
            $0.height.equalTo(52)
        }
    }
    
}


//Preview code
#if DEBUG
import SwiftUI
struct codeBtnViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        codeBtnViewController()
    }
}
@available(iOS 13.0, *)
struct codeBtnViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                codeBtnViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
