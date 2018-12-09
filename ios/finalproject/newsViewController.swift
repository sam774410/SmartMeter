//
//  newsViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/8.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class newsViewController: UIViewController, WKNavigationDelegate {

    @IBAction func back_Btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    // loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    //loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        if let url = URL(string: "https://www.taipower.com.tw/tc/news2.aspx?mid=225"){
            let request = URLRequest(url: url)
            webView.load(request)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
    }
    


}
