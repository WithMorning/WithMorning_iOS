//
//  TutorialViewController.swift.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/24/24.
//

import UIKit
import SnapKit
import Then

class TutorialViewController : UIViewController{
    
    
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
    
    private lazy var skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.titleLabel?.font = DesignSystemFont.Pretendard_Medium16.value
        button.setTitleColor(DesignSystemColor.Gray400.value, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 온보딩 페이지 컨트롤러
    lazy var pages = [UIViewController]()
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = DesignSystemColor.Gray300.value
        page.currentPageIndicatorTintColor = DesignSystemColor.Orange500.value
        page.numberOfPages = 3
        page.currentPage = 0
        page.isUserInteractionEnabled = false
        //        page.backgroundColor = .gray
        return page
    }()
    
    private lazy var firstpage : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7.69/2
        view.backgroundColor = DesignSystemColor.Orange500.value
        return view
    }()
    
    
    private lazy var pageViewController : UIPageViewController = {
        let view = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        
        let vc = [TutorialFirstViewController()]
        
        view.setViewControllers(vc, direction: .reverse, animated: true)
        return view
    }()
    
    //MARK: - 다음 버튼
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(nextbtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonLabel : UILabel = {
        let label = UILabel()
        label.text = "다음"
        label.textColor = .white
        label.font = DesignSystemFont.Pretendard_Bold16.value
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemColor.Gray150.value
        setUI()
    }
    
    //MARK: - Autolayout
    
    func setUI(){
        view.addSubviews(mainLabel,popButton,skipButton,pageControl,firstpage,pageViewController.view,nextButton)
        
        mainLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        popButton.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(24)
        }
        skipButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(mainLabel)
        }
        
        pageControl.snp.makeConstraints{
            $0.top.equalTo(mainLabel.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
        }
        firstpage.snp.makeConstraints{
            $0.width.height.equalTo(7.69)
            $0.centerY.equalTo(pageControl).offset(-0.2)
            $0.centerX.equalTo(pageControl).offset(-18)
        }
        
        pageViewController.view.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            $0.top.equalTo(pageControl.snp.bottom).offset(16)
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
    //MARK: - objc func
    
    @objc func nextbtn(){
        if pageControl.currentPage < pageControl.numberOfPages - 1 {
            pageControl.currentPage += 1
            
            let nextViewController: UIViewController?
            switch pageControl.currentPage {
            case 0:
                nextViewController = TutorialFirstViewController()
            case 1:
                nextViewController = TutorialSecondViewController()
            case 2:
                nextViewController = TutorialThirdViewController()
            default:
                nextViewController = nil
            }
            if let nextViewController = nextViewController {
                
                pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    @objc func skip(){
        let vc = TutorialThirdViewController()
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = 2
        
    }
    
    private var visitedPages: [Int] = []
}

//MARK: - 온보딩 페이지

extension TutorialViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is TutorialFirstViewController:
            return nil
        case is TutorialSecondViewController:
            return TutorialFirstViewController()
        case is TutorialThirdViewController:
            return TutorialSecondViewController()
        default:
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is TutorialFirstViewController:
            return TutorialSecondViewController()
        case is TutorialSecondViewController:
            return TutorialThirdViewController()
        case is TutorialThirdViewController:
            return nil
        default:
            return nil
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed, let currentViewController = pageViewController.viewControllers?.first {
            var currentPage: Int?
            if currentViewController is TutorialFirstViewController {
                currentPage = 0
            } else if currentViewController is TutorialSecondViewController {
                currentPage = 1
            } else if currentViewController is TutorialThirdViewController {
                currentPage = 2
            }
            
            if let currentPage = currentPage {
                pageControl.currentPage = currentPage
                updatePageControlIndicatorColor(currentPage: currentPage)
            }
        }
    }
    
    
    private func updatePageControlIndicatorColor(currentPage: Int) {
        for _ in 0...currentPage {
            pageControl.pageIndicatorTintColor = DesignSystemColor.Orange500.value
        }
        for _ in currentPage+1..<pageControl.numberOfPages {
            pageControl.pageIndicatorTintColor = DesignSystemColor.Gray300.value
        }
        pageControl.currentPageIndicatorTintColor = DesignSystemColor.Orange500.value
    }
}







//Preview code
#if DEBUG
import SwiftUI
struct TutorialViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        TutorialViewController()
    }
}
@available(iOS 13.0, *)
struct TutorialViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                TutorialViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
