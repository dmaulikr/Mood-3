//
//  PressureKitView.swift
//  Mood
//
//  Created by Tung on 15/9/22.
//  Copyright © 2015年 Tung. All rights reserved.
//

import UIKit

class PressureKitView: UIView {
    
    var pressure: CGFloat = 0.0  {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        MyPressure.drawPressureKit(self.pressure)
    }
}
