//
//  ViewController.swift
//  RevealingSplashViewSample
//
//  Created by Chris Jimenez on 2/25/16.
//  Copyright © 2016 Chris Jimenez. All rights reserved.
//

import UIKit
import RevealingSplashView

class ViewController: UIViewController {
    private var revealingLoaded = false
    
    override var shouldAutorotate: Bool {
        return revealingLoaded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(rgba:"#1D8FF1"))
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!, iconInitialSize: CGSize(width: 70, height: 70), backgroundImage: UIImage(named: "BackgroundImage")!)
        
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 4.0
        
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
    
        revealingSplashView.startAnimation(){
            self.revealingLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
            print("Completed")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return !UIApplication.shared.isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
}

