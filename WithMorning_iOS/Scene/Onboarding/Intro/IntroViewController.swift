//
//  IntroViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 9/17/24.
//

import UIKit
import SnapKit
import Then

class IntroViewController : UIViewController{
    
    //MARK: - properties
    
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
    
    public lazy var pages = [UIViewController]()
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = DesignSystemColor.Gray150.value
        page.currentPageIndicatorTintColor = DesignSystemColor.Gray150.value
        page.numberOfPages = 3
        page.currentPage = 0
        page.isUserInteractionEnabled = false
        return page
    }()
    
    private lazy var pageViewController : UIPageViewController = {
        let view = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.view.backgroundColor = DesignSystemColor.Gray150.value
        view.delegate = self
        view.dataSource = self
        
        let vc = [IntroFirstViewController()]
        
        view.setViewControllers(vc, direction: .reverse, animated: true)
        return view
    }()
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.addSubview(buttonLabel)
        button.setBackgroundColor(DesignSystemColor.Black.value, for: .normal)
        button.setBackgroundColor(DesignSystemColor.Black.value.adjustBrightness(by: 0.8), for: .highlighted)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
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
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemColor.Gray150.value
        self.navigationController?.navigationBar.isHidden = true
        setUI()
    }
    
    func setUI(){
        view.addSubviews(popButton,skipButton,pageViewController.view,nextButton)
        
//        popButton.snp.makeConstraints{
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            $0.leading.equalToSuperview().offset(16)
//            $0.height.width.equalTo(24)
//        }
        
        skipButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        pageViewController.view.snp.makeConstraints{
            $0.top.equalTo(skipButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            
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
    @objc func skip() {
        moveTutorial()
//        guard pageControl.currentPage != 2 else{
//            let vc = TutorialViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
//        let vc = IntroThridViewContoller()
//        pageViewController.setViewControllers([vc], direction: .forward, animated: true) { [weak self] _ in
//            self?.pageControl.currentPage = 2
//        }
        
    }
    
    
    
    @objc func nextbtn() {
        let currentPage = pageControl.currentPage
        if currentPage == pageControl.numberOfPages - 1 {
            // 현재 페이지가 IntroThridViewContoller일 때 새로운 뷰 컨트롤러로 푸시
            let tutorialViewController = TutorialViewController()
            navigationController?.pushViewController(tutorialViewController, animated: true)
        } else {
            // 마지막 페이지가 아니라면 다음 페이지로 이동
            pageControl.currentPage += 1
            
            let nextViewController: UIViewController?
            switch pageControl.currentPage {
            case 0:
                nextViewController = IntroFirstViewController()
            case 1:
                nextViewController = IntroSecondViewController()
            case 2:
                nextViewController = IntroThridViewContoller()
            default:
                nextViewController = nil
            }
            
            if let nextViewController = nextViewController {
                pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Tutorial로 이동

    func moveTutorial() {
        let tutorialVC = TutorialViewController()
        let navController = UINavigationController(rootViewController: tutorialVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            keyWindow.rootViewController = navController
            keyWindow.makeKeyAndVisible()
        }
    }
}






extension IntroViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case is IntroFirstViewController:
            return IntroSecondViewController()
        case is IntroSecondViewController:
            return IntroThridViewContoller()
        case is IntroThridViewContoller:
            return nil
        default:
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is IntroFirstViewController:
            return nil
        case is IntroSecondViewController:
            return IntroFirstViewController()
        case is IntroThridViewContoller:
            return IntroSecondViewController()
        default:
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first {
            switch currentViewController {
            case is IntroFirstViewController:
                pageControl.currentPage = 0
            case is IntroSecondViewController:
                pageControl.currentPage = 1
            case is IntroThridViewContoller:
                pageControl.currentPage = 2
            default:
                break
            }
        }
    }
    
    
}
//Preview code
#if DEBUG
import SwiftUI
struct IntroViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        IntroViewController()
    }
}
@available(iOS 13.0, *)
struct IntroViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                IntroViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
