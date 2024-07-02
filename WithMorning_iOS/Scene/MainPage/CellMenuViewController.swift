//
//  CellMenuViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 6/27/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class CellMenuViewController: UIViewController,AlterDelegate {
    
    private lazy var copyButton : UIButton = {
        let button = UIButton()
        button.setTitle("초대코드 복사하기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(copyClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var view1 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var editButton : UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(editClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var view2 : UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemColor.Gray200.value
        return view
    }()
    
    private lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton : UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 0, bottom: 40, trailing: 0) // 텍스트 위치 조정
        
        let titleTextAttributes = AttributeContainer([
            NSAttributedString.Key.font: DesignSystemFont.Pretendard_Bold16.value
        ])
        configuration.attributedTitle = AttributedString("닫기", attributes: titleTextAttributes)
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        SetUI()
    }
    
    //MARK: - SetUI
    
    func SetUI(){
        view.addSubviews(copyButton,view1,editButton,view2,deleteButton,closeButton)
        
        copyButton.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view1.snp.top)
        }
        
        view1.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.top.equalToSuperview().offset(70)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        editButton.snp.makeConstraints{
            $0.top.equalTo(view1.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view2.snp.bottom)
        }
        
        view2.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.top.equalTo(view1.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        deleteButton.snp.makeConstraints{
            $0.top.equalTo(view2.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        closeButton.snp.makeConstraints{
            $0.top.equalTo(deleteButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
            
        }
    }
    
    //MARK: - @objc func
    @objc func copyClicked(){
        print("초대코드 복사버튼")
    }
    @objc func editClicked(){
        print("수정하기 버튼")
    }
    @objc func deleteClicked(){
        print("삭제하기 버튼")
        show(alertType : .deleteAlarm )
    }
    @objc func closeClicked(){
        dismiss(animated: true)
        print("닫기버튼")
    }
    
    func confirm() {
        self.dismiss(animated: true){
            //알람 삭제 api
        }
    }
    
    func cancel() {
        print("cancel")
    }
    
    
}





//Preview code
#if DEBUG
import SwiftUI
struct CellMenuViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        CellMenuViewController()
    }
}
@available(iOS 13.0, *)
struct CellMenuViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                CellMenuViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
