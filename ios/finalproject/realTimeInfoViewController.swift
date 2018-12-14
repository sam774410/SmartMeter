//
//  realTimeInfoViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/10.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class realTimeInfoViewController: UIViewController,  WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func back_Btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        let url = URL(string: "https://www.taipower.com.tw/tc/news2.aspx?mid=225")
        let urlRequest = URLRequest(url: url!)
        
        webView.load(urlRequest)
    }
    



}
