//
//  FollowerMenuViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/26/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class FollowerMenuViewController: UIViewController, AlterDelegate {
    
    //MARK: - dismiss closure
    var menuClicked: (() -> Void)?
    var groupId : Int?
    var participantCode : String?
    
    //MARK: - properties
    
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
    
    private lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("그룹 나가기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_SemiBold16.value
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(leavegroup), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.setBackgroundColor(DesignSystemColor.Black.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Black.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "닫기"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        SetUI()
        
        print("그룹아이디 : \(String(describing: groupId)),참여코드 :\(String(describing: participantCode))")
    }
    
    //MARK: - SetUI
    
    func SetUI(){
        view.addSubviews(copyButton,view1,deleteButton,closeButton)
        
        copyButton.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view1.snp.top)
        }
        
        view1.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.top.equalToSuperview().offset(70)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        deleteButton.snp.makeConstraints{
            $0.top.equalTo(view1.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        closeButton.snp.makeConstraints{
            $0.top.equalTo(deleteButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    //MARK: - @objc func
    @objc func copyClicked(){
        self.dismiss(animated: true){
            UIPasteboard.general.string = self.participantCode
        }
        showToast(message: "참여코드를 복사했습니다.")
    }
    
    @objc func leavegroup() {
        print("그룹 나가기 버튼 클릭")
        self.dismiss(animated: true) {
            guard let menuClicked = self.menuClicked else { return }
            menuClicked()
            print("Cellmenu의 groupId", self.groupId as Any)
        }
    }
    
    @objc func closeClicked(){
        dismiss(animated: true)
    }
    
    //MARK: - delegate Func
    
    func confirm() {
        self.dismiss(animated: true)
    }
    
    
    func cancel() {
        print("cancel")
    }
    
    
}





//Preview code
#if DEBUG
import SwiftUI
struct FollowerMenuViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        FollowerMenuViewController()
    }
}
@available(iOS 13.0, *)
struct FollowerMenuViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                FollowerMenuViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
