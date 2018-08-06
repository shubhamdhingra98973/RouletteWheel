//
//  CreateWheel.swift
//  RouletteWheelGame
//
//  Created by Shubham Dhingra  on 01/20/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import Foundation
import UIKit

class CreateWheel {
    
    static var numberOfCollisions :Int = 0
    
    static func makeButtonArray(buttonArr : [Int]) -> [ButtonPiece]{
        let buttonNames = buttonArr
        let myFont = UIFont(name: "Avenir", size: 10.0)
        let fontColor = UIColor.white
        let labelLength : CGFloat = 40.0
        var buttonArray : [ButtonPiece] = []
        
        for (index, aName) in buttonNames.enumerated(){
            
            var newButton = ButtonPiece(name: String(aName), color: .clear, centerOffset: CGPoint(x: 0, y: 0))
            if let myFont = myFont{
                newButton.setLabel(maxLabelWidth: labelLength, labelFont: myFont, textColor: fontColor , index : index)
            }
            else{
                print("Must use valid font")
            }
            
            buttonArray.append(newButton)
            
        }
        return buttonArray
    }
    
    static var array : [Int] = {
        return [0, 36, 65, 35, 199, 89, 133, 149, 73, 105, 125, 63, 99, 52, 55, 49, 175, 45, 195, 123, 59, 27, 189, 0, 85, 33, 78, 100, 93, 187, 69, 137, 25, 75, 41, 113, 120]
    }()
}

//MARK:- UITextField Delegate
extension WheelVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let nextTf = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else { textField.resignFirstResponder();  return true }
        nextTf.becomeFirstResponder()
        return false
    }
}

//MARK: - CABasicAnimation Extension
extension CABasicAnimation {
    func setUpAnimation() {
        self.repeatCount = 0
        self.isRemovedOnCompletion = false
        self.fillMode = kCAFillModeForwards
        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    }
}
