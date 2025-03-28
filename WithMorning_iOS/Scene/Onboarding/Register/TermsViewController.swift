//
//  TermsViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/17/24.
//

import UIKit
import Then
import SnapKit

class TermsViewController: UIViewController{
    
    private let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "서비스 이용 동의"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var view1 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(ageLabel,agecheckButton,serviceLabel,serviceButton,infoLabel,infoButton)
        return view
    }()
    
    //MARK: - (필수) 만 14세입니다. 텍스트 탭시 약관사이트로 이동
    private let ageLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 만 14세입니다."
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var agecheckButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(agebtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - (필수) 서비스 이용 약관
    private let serviceLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 서비스 이용 약관"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var serviceButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(servicebtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - (필수) 개인정보 처리방침
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "(필수) 개인정보 처리방침"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var infoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(infobtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - (선택) 마케팅 정보 수신 동의
    private let maketingLabel : UILabel = {
        let label = UILabel()
        label.text = "(선택) 마케팅 정보 수신 동의"
        label.font = DesignSystemFont.Pretendard_Medium14.value
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var maketingButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.addTarget(self, action: #selector(maketingbtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 전체 동의
    private lazy var view2 : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(allagreeLabel,subLabel,allagreeButton)
        return view
    }()
    
    private let allagreeLabel : UILabel = {
        let label = UILabel()
        label.font = DesignSystemFont.Pretendard_Bold14.value
        label.textColor = .black
        
        let attributeLabel = NSMutableAttributedString(string: "  약관 전체 동의")
        let attachImage = NSTextAttachment()
        attachImage.image = UIImage(named: "Check")
        attachImage.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
        let imageString = NSAttributedString(attachment: attachImage)
        attributeLabel.insert(imageString, at: 0)
        label.attributedText = attributeLabel
        return label
    }()
    
    private let subLabel : UILabel = {
        let label = UILabel()
        label.text = "서비스 이용을 위해 약관에 모두 동의합니다."
        label.font = DesignSystemFont.Pretendard_Medium12.value
        label.textColor = DesignSystemColor.Gray500.value
        label.textAlignment = .left
        return label
    }()
    
    private lazy var allagreeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxgray"), for: .normal)
        button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        button.tintColor = DesignSystemColor.Gray200.value
        button.addTarget(self, action: #selector(allbtn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 다음 버튼
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = DesignSystemColor.Gray300.value
        button.addTarget(self, action: #selector(nextbtn), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "다음"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.isNavigationBarHidden = true
        setUI()
    }
    
    func setUI(){
        view.addSubviews(mainLabel,nextButton,view1,view2)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        view1.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(164)
        }
        ageLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(26)
            $0.height.equalTo(20)
        }
        agecheckButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(ageLabel)
        }
        serviceLabel.snp.makeConstraints{
            $0.top.equalTo(ageLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        serviceButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(serviceLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(serviceLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        infoButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(infoLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        view2.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top).inset(-16)
            $0.height.equalTo(95)
        }
        allagreeLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(24)
        }
        subLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        allagreeButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(92)
        }
        buttonLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    //MARK: - 모두 동의 함수
    func setallagree(){
        if [agecheckButton, serviceButton, infoButton].allSatisfy({ $0.currentImage == UIImage(named: "checkboxorange") }) {
            allagreeButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        } else {
            allagreeButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Gray300.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Gray300.value, for: .highlighted)
        }
    }
    
    //MARK: - @objc func
    @objc func agebtn(){
        if agecheckButton.image(for: .normal) == UIImage(named: "checkboxgray") {
            agecheckButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            agecheckButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        } else {
            agecheckButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            agecheckButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        }
        setallagree()
    }
    
    @objc func servicebtn(){
        if serviceButton.image(for: .normal) == UIImage(named: "checkboxgray") {
            serviceButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            serviceButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        } else {
            serviceButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            serviceButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        }
        setallagree()
    }
    
    @objc func infobtn(){
        if infoButton.image(for: .normal) == UIImage(named: "checkboxgray") {
            infoButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            infoButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        } else {
            infoButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            infoButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        }
        setallagree()
    }
    
    @objc func maketingbtn(){
        if maketingButton.image(for: .normal) == UIImage(named: "checkboxgray") {
            maketingButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            maketingButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
        } else {
            maketingButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            maketingButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
        }
        setallagree()
    }
    
    @objc func allbtn() {
        if allagreeButton.image(for: .normal) == UIImage(named: "checkboxgray") { //모두 동의
            [agecheckButton, serviceButton, infoButton, maketingButton].forEach { button in
                button.setImage(UIImage(named: "checkboxorange"), for: .normal)
                button.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
            }
            allagreeButton.setImage(UIImage(named: "checkboxorange"), for: .normal)
            allagreeButton.setImage(UIImage(named: "checkboxorange"), for: .highlighted)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Orange500.value.adjustBrightness(by: 0.8), for: .highlighted)
        } else {//모두동의 해제
            [agecheckButton, serviceButton, infoButton, maketingButton].forEach { button in
                button.setImage(UIImage(named: "checkboxgray"), for: .normal)
                button.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
            }
            allagreeButton.setImage(UIImage(named: "checkboxgray"), for: .normal)
            allagreeButton.setImage(UIImage(named: "checkboxgray"), for: .highlighted)
            nextButton.setBackgroundColor(DesignSystemColor.Gray300.value, for: .normal)
            nextButton.setBackgroundColor(DesignSystemColor.Gray300.value, for: .highlighted)
        }
        setallagree()
    }
    
    @objc func nextbtn() {
        let requiredButtons = [agecheckButton, serviceButton, infoButton]
        
        let allRequiredButtonsSelected = requiredButtons.allSatisfy { $0.currentImage == UIImage(named: "checkboxorange")}
        
        if allRequiredButtonsSelected {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showToast(message: "약관에 모두 동의해주세요.")
        }
    }
}



//Preview code
#if DEBUG
import SwiftUI
struct TermsViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        TermsViewController()
    }
}
@available(iOS 13.0, *)
struct TermsViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                TermsViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif

