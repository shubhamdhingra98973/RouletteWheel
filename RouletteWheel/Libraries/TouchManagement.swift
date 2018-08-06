//
//  TouchManagement.swift
//  ButtonWheel
//
//  Created by Shubham Dhingra on 01/20/17.
//

import Foundation
import UIKit

struct TouchManagement{
    
    
    static func getNameFromPoint(buttonWheel : ButtonWheel, tappedPoint : CGPoint) -> String?{
        let centerPoint = CGPoint(x: buttonWheel.frame.width / 2, y: buttonWheel.frame.height / 2)
        
        let angle = VectorHelp.angleFromPoints(centerPoint: centerPoint, tappedPoint: tappedPoint)
        let distance = CGFloat(VectorHelp.distanceFromCenter(centerPoint: centerPoint, tappedPoint: tappedPoint))
        let numberOfButtons = buttonWheel.buttonNames.count
        
        if distance > buttonWheel.dimensionSize || distance < buttonWheel.middleRadius{
            return nil
        }
        
        let index = Int(angle * Double(numberOfButtons) / VectorHelp.twoPi)
        
        return buttonWheel.buttonNames[index]
    }
}
