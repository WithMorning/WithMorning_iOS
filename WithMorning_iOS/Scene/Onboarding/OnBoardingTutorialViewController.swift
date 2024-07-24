//
//  OnBoardingTutorialViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/24/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class OnBoardingTutorialViewController : UIViewController{
    
    //MARK: - properties
    private lazy var mainLabel : UILabel = {
        let label = UILabel()
        label.text = "튜토리얼"
        label.tintColor = DesignSystemColor.Black.value
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    private lazy var popButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        //        button.addTarget(self, action: #selector(popclicked), for: .touchUpInside)
        return button
    }()
    
    var pages = [UIViewController]()
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = DesignSystemColor.Gray300.value
        page.currentPageIndicatorTintColor = DesignSystemColor.Orange500.value
        page.numberOfPages = 3
        page.currentPage = 0
        page.isUserInteractionEnabled = false
        return page
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    
    func setUI(){
        view.addSubviews(mainLabel,popButton,pageControl)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        pageControl.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
    }
}


//Preview code
#if DEBUG
import SwiftUI
struct OnBoardingTutorialViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        OnBoardingTutorialViewController()
    }
}
@available(iOS 13.0, *)
struct OnBoardingTutorialViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                OnBoardingTutorialViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
