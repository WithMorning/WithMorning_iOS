//
//  WeekChoiceViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 7/7/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class WeekChoiceViewController : UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}


//Preview code
#if DEBUG
import SwiftUI
struct WeekChoiceViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController{
        WeekChoiceViewController()
    }
}
@available(iOS 13.0, *)
struct WeekChoiceViewControllerRepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 14.0, *) {
                WeekChoiceViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
                    .previewDevice(PreviewDevice(rawValue: "iPhone se3"))
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
} #endif
