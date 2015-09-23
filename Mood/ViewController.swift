//
//  ViewController.swift
//  Mood
//
//  Created by Tung on 15/9/22.
//  Copyright © 2015年 Tung. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let pressureKit = PressureKitView()
    
    let button = SwiftButton()
    
    var audioPlayer = AVAudioPlayer()
    
    var endMoving: Bool = false {
        didSet {
            if self.pressureKit.pressure > 0.7 && endMoving {
                audioPlayer.play()
            }
        }
    }
    
    // Animation Constants
    
    let fadeDuration = 1.0
    let appearDuration = 0.4
    
    // View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        // Add pressureKit view
        pressureKit.center = self.view.center
        pressureKit.frame = CGRectMake(-10, 0, 400, 600)
        pressureKit.backgroundColor = self.view.backgroundColor
        self.view.addSubview(pressureKit)
        
        // Add a label to guide user
        let userLabel = UILabel(frame: CGRectMake(125, 500, 300, 40))
        userLabel.text = "大拇指向右划动👉"
        userLabel.sizeToFit()
        self.view.addSubview(userLabel)
        
        // Prepare for playing sound
        let alerSound = NSURL.fileURLWithPath(
                NSBundle.mainBundle().pathForResource("alert", ofType: "mp3")!)
        do {
           try audioPlayer = AVAudioPlayer(contentsOfURL: alerSound)
        } catch _ {
            print("It seems doesn't work.")
        }
        audioPlayer.numberOfLoops = 1
        
        // Add Pan Gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: "didPan:")
        self.view.addGestureRecognizer(pan)
        
        //Add start agian button
        button.frame = CGRectMake(150, 550, 80, 40)
        button.tintColor = UIColor.whiteColor()
        button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func sliderDidMoved(slider: UISlider) {
        let amount = CGFloat(slider.value)
        self.pressureKit.pressure = amount
    }
    
    func didPan(pan:UIPanGestureRecognizer) {
        let state = pan.state
        switch state {
        case .Began:
            fallthrough
        case .Changed:
            let distance = pan.translationInView(self.view).x
            self.pressureKit.pressure = max(min(distance / 100.0, 1.0), 0)
            print(distance)
        case .Ended:
            endMoving = true
        default:
            break
        }
    }
    
    func buttonTapped(sender: UIButton) {
        self.button.enabled = false
        UIView.animateWithDuration(fadeDuration, animations: {
            self.pressureKit.alpha = 0.0
        }){ finished in
            self.pressureKit.pressure = 0.0
            
            UIView.animateWithDuration(self.appearDuration, animations: {
                self.pressureKit.alpha = 1.0
            }){ finished in
                self.button.enabled = true
            }
            
        }
    }
}

