//
//  pastInfoViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/10.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class pastInfoViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var back_Btn: UIBarButtonItem!
    @IBAction func back_BTN(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.taipower.com.tw/d006/loadGraph/loadGraph/load_supdem_his_.html")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    

    

}
