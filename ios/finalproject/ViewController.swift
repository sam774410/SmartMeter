//
//  ViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/20.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import SwiftyBeaver
import BWWalkthrough

class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    //logging
    let log = SwiftyBeaver.self
    let logo = UIImageView()
    let backGround = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setLogging()

        
        backGround.image = UIImage(named: "15136")
        backGround.contentMode = .scaleAspectFill
        backGround.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backGround.center = view.center
        backGround.alpha = 0
        view.addSubview(backGround)
        
        logo.image = UIImage(named: "wenhe_single")
        logo.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        logo.center = view.center
        view.addSubview(logo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.backGround.alpha = 0.5
            
            self.logo.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.logo.center = self.view.center
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.logo.frame = CGRect(x: 0, y: 0, width: 20000, height: 20000)
                self.logo.center = self.view.center
                
                self.backGround.alpha = 1
            })
            
            //check if needed introduction
            if self.isAppAlreadyLaunchedOnce() {
                
                //print("no intro")
                
                //fot testing
                //self.showIntro()
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                
                self.present(loginVC, animated: true, completion: nil)
            } else {
                
                self.showIntro()
                //print("intro")
            }
        }
    }

    func setLogging() {
        
        let console = ConsoleDestination()
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
    }
    
    //introduction
    func showIntro(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as? BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "walk1") as? UIViewController
        let page_two = stb.instantiateViewController(withIdentifier: "walk2") as? UIViewController
        let page_three = stb.instantiateViewController(withIdentifier: "walk3") as? UIViewController
        
        // Attach the pages to the master
        walkthrough?.delegate = self
        walkthrough?.add(viewController:page_one!)
        walkthrough?.add(viewController:page_two!)
        walkthrough?.add(viewController:page_three!)
        
        self.present(walkthrough!, animated: true, completion: nil)
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            //print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //print("App launched first time")
            return false
        }
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        
        //print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")

        self.present(loginVC, animated: true, completion: nil)
    }
    
    
}

