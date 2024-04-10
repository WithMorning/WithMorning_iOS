//
//  MainViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 4/9/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MainViewController: UIViewController {
    
    private lazy var Label : UILabel = {
        let label = UILabel()
        label.text = "소정이 귀여움"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUI()

    }
    
    func SetUI(){
        view.addSubview(Label)
        
        Label.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
}



#if DEBUG
import SwiftUI
struct Preview3: UIViewControllerRepresentable {
    
    // 여기 ViewController를 변경해주세요
    func makeUIViewController(context: Context) -> UIViewController {
        MainViewController()
    }
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
}

struct ViewController_PreviewProvider3: PreviewProvider {
    static var previews: some View {
        Group {
            Preview3()
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Preview")
        }
    }
}
#endif
