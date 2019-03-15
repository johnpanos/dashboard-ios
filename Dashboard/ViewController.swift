//
//  ViewController.swift
//  Dashboard
//
//  Created by John Panos on 3/12/19.
//  Copyright © 2019 John Panos. All rights reserved.
//

import UIKit
import SwiftSocket
import M13Checkbox
import RevealingSplashView

class DashboardViewController: UIViewController {
    weak var testView: UIFieldView!
    var topConstraint: NSLayoutConstraint?
    var centerYConstraint: NSLayoutConstraint?
    var fieldVisible = false
    var checkbox: M13Checkbox?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 1.0/255.0, green: 79.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        
        let checkbox = M13Checkbox()
        view.addSubview(checkbox)
        checkbox.setCheckState(.unchecked, animated: false)
        
        // Update the animation duration
        checkbox.animationDuration = 0.5
        
        // Change the animation used when switching between states.
        checkbox.stateChangeAnimation = .bounce(.stroke)
        
        //: Appearance
        //: ----------
        // The background color of the veiw.
        checkbox.backgroundColor = .clear
        
        checkbox.tintColor = UIColor.green
        
        // Whether or not to display a checkmark, or radio mark.
        checkbox.markType = .checkmark
        // The line width of the checkmark.
        checkbox.checkmarkLineWidth = 3.0
        
        // The line width of the box.
        checkbox.boxLineWidth = 3.0
        // The corner radius of the box if it is a square.
        checkbox.cornerRadius = 4.0
        // Whether the box is a square, or circle.
        checkbox.boxType = .circle
        // Whether or not to hide the box.
        checkbox.hideBox = false
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 75).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 75).isActive = true
        checkbox.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor, constant: 0).isActive = true
        checkbox.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: 20).isActive = true
        self.checkbox = checkbox
        
        let testView = UIFieldView(image: UIImage(named: "field"))
        
        self.view.addSubview(testView)
        
        testView.layer.cornerRadius = 8
        testView.alpha = 0.0
        
        testView.widthAnchor.constraint(equalTo: self.view!.widthAnchor, multiplier: 0.9).isActive = true
        testView.heightAnchor.constraint(equalTo: self.view!.widthAnchor, multiplier: (testView.image!.size.height/testView.image!.size.width) * 0.9).isActive = true
        testView.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor, constant: 0).isActive = true
        
        topConstraint = testView.topAnchor.constraint(equalTo: view!.bottomAnchor, constant: 10)
        topConstraint?.isActive = true
        
        self.testView = testView
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "mywb")!, iconInitialSize: CGSize(width: 152, height: 70), backgroundColor: UIColor(red: 1.0/255.0, green: 79.0/255, blue: 143/255, alpha: 1.0))
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Splash Animation Finished")
        }
        
        DashboardViewModel.init(viewController: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setBackgroundColorRed() {
        setBackgroundColor(color: UIColor.init(red: 153.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0))
    }
    
    func setBackgroundColorBlue() {
        setBackgroundColor(color: UIColor.init(red: 0.0, green: 0.0, blue: 201.0/255.0, alpha: 1.0))
    }
    
    func setBackgroundColor(color: UIColor) {
        DispatchQueue.main.async() {
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.view.backgroundColor = color
            }, completion: nil)
        }
    }
    
    func hideField(){
        DispatchQueue.main.async() {
            if !self.fieldVisible {
                return
            }
            self.checkbox?.setCheckState(.unchecked, animated: true)
            // do other task
            self.centerYConstraint?.isActive = false
            self.topConstraint?.isActive = true
            self.fieldVisible = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.testView.reset()
            })
        }
    }
    
    func showField() {
        DispatchQueue.main.async() {
            if self.fieldVisible {
                return
            }
            self.checkbox?.setCheckState(.checked, animated: true)
            self.testView.alpha = 1.0
            
            self.topConstraint?.isActive = false
            self.centerYConstraint = self.testView.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor, constant: 0)
            self.centerYConstraint?.isActive = true
            
    //        let topLeft = createPointForCoord(x: 217.0, y: 40.0, scaleFactor: scaleFactor)
    //        let bottomRight = createPointForCoord(x: 1372.0, y: 615.0, scaleFactor: scaleFactor)
    //
    //        topLeft.backgroundColor = UIColor.blue
    //        bottomRight.backgroundColor = UIColor.blue
    //
    //        self.testView.addSubview(topLeft)
    //        self.testView.addSubview(bottomRight)
            
            self.fieldVisible = true
            
            let points = [
                FieldPoint(x: 0, y: 0),
                FieldPoint(x: 0, y: 3.211716),
                FieldPoint(x: 0, y: 10.520763),
                FieldPoint(x: -51.8, y: 110),
                FieldPoint(x: -51.8, y: 120),
                FieldPoint(x: -51.8, y: 130),
                FieldPoint(x: -51.8, y: 135),
                FieldPoint(x: -51.8, y: 136),
                FieldPoint(x: -51.8, y: 131),
                FieldPoint(x: -45.561465, y: 131.728441),
                FieldPoint(x: -38.186881, y: 130.927606),
                FieldPoint(x: -25.241012, y: 128.438429),
                FieldPoint(x: -6.516056, y: 122.121066),
                FieldPoint(x: 15.799654, y: 109.752579),
                FieldPoint(x: 38.600518, y: 90.818301),
                FieldPoint(x: 59.696425, y: 67.062135),
                FieldPoint(x: 76.868319, y: 40.723772),
                FieldPoint(x: 88.037241, y: 14.476493),
                FieldPoint(x: 93.650591, y: -8.828362),
                FieldPoint(x: 95.521699, y: -10),
                FieldPoint(x: 95.521699, y: -15),
                FieldPoint(x: 95.521699, y: -18),
                FieldPoint(x: 95.267022, y: -21.124425),
                FieldPoint(x: 94.158554, y:-15.125752),
                FieldPoint(x: 91.230643, y: 4.266916),
                FieldPoint(x: 83.852024, y: 28.476564),
                FieldPoint(x: 69.303536, y: 53.969837),
                FieldPoint(x: 47.113621, y: 76.211246),
                FieldPoint(x: 20.898808, y: 92.976969),
                FieldPoint(x: -2.596718, y: 108.498998),
                FieldPoint(x: -18.767476, y: 115.545991),
                FieldPoint(x: -26.209281, y: 123.442865),
                FieldPoint(x: -28.958754, y: 127),
                FieldPoint(x: -28.958754, y: 131),
                FieldPoint(x: -28.958754, y: 136),
                FieldPoint(x: -28.958754, y: 136),
                FieldPoint(x: -28.958754, y: 131)
            ]
            
            self.testView.play(points: points, origin: FieldPoint(x: 60, y: 215), drawPath: true)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
