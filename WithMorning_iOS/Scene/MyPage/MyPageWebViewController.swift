//
//  MyPageWebViewController.swift
//  WithMorning_iOS
//
//  Created by 안세훈 on 8/21/24.
//

import UIKit
import Foundation
import WebKit
import SnapKit

class MypageWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: WebUrl = .perm
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webView.uiDelegate = self
        view = UIView()
        view.addSubview(webView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        openWebPage()
    }
    
    func openWebPage() {
        guard let url = URL(string: self.url.rawValue) else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }

    
}
