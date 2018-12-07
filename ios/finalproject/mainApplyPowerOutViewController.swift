//
//  mainApplyPowerOutViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import LocalAuthentication
import StepProgressView

class mainApplyPowerOutViewController: UIViewController {

    let log = MYLOG().log
    
    @IBOutlet weak var applyContainerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var stepView: StepProgressView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.containerView.isHidden = true
        stepViewSetUp(curretStep: 2)
        
       
    }
    func stepViewSetUp(curretStep: Int){

        stepView.steps = ["First", "Second", "Third", "Last"]
        stepView.details = [0: "The beginning", 3: "The end"] // appears below step title

        stepView.stepShape = .circle
        stepView.firstStepShape = .downTriangle
        stepView.lastStepShape = .triangle

        stepView.lineWidth = 2.5
        stepView.verticalPadding = 50 // between steps (0 => default based on textFont)
        stepView.horizontalPadding =  8 // between shape and text (0 => default based on textFont)

        stepView.currentStep = curretStep
    }

    
    
    
}
