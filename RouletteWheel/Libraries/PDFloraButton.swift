//
//  PDFloraButton.swift
//  PDFloraButton
//
//  Created by Dhingra on 18/12/17.
//  Copyright � 2016 Priyam Dutta. All rights reserved.
//

import UIKit

enum ButtonPosition {
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case midTop
    case midBottom
    case midLeft
    case midRight
}

func getRadian(degree: CGFloat) -> CGFloat {
    return CGFloat(degree * .pi/180)
}

class PDFloraButton: UIButton {
    
    private let radius: CGFloat = 110.0
    private let childButtonSize: CGFloat = 30.0
    private let circumference: CGFloat = 360.0
    private let delayInterval = 0.0
    private let duration = 0.25
    private let damping: CGFloat = 0.9
    private let initialVelocity: CGFloat = 0.9
    private var anchorPoint: CGPoint!
    
    private var xPadding: CGFloat = 10.0
    private var yPadding: CGFloat = 10.0
    private var buttonSize: CGFloat = 0.0
    private var childButtons = 0
    private var buttonPosition: ButtonPosition = .center
    private var childButtonsArray = [UIButton]()
    private var degree: CGFloat = 0.0
    private var imageArray = [String]()
   
    //    var arr = [Int]()
    var isOpen = false
    var buttonActionDidSelected: ((_ indexSelected: Int)->())!
   // var view : UIView?
    
    convenience init(withPosition position : ButtonPosition , size: CGFloat, numberOfPetals: Int, images: [String], arr: [Int] , numberView : UIView?) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
       // self.frame = (numberView?.frame)!
       // self.init(frame : (numberView?.frame)!)
        self.layer.cornerRadius = size / 2.0
        childButtons = numberOfPetals
        buttonPosition = position
        imageArray = images
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.center = CGPoint(x: (numberView?.frame)!.midX, y: (numberView?.frame)!.midY)
            self.anchorPoint = self.center
            self.createButtons(numbers: numberOfPetals, arr: arr)
            }
            }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.addTarget(self, action: #selector(self.animateChildButtons(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create Buttons
    func createButtons(numbers: Int, arr: [Int]) {
        
        for index in 0..<numbers {
            let petal = UIButton(frame: CGRect(x: 0, y: 0, width: childButtonSize, height: childButtonSize))
            petal.center = self.center
            petal.layer.cornerRadius = childButtonSize/2.0
            petal.backgroundColor = UIColor.clear
            petal.setTitleColor(UIColor.white, for: UIControlState())
            petal.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            petal.tag = index
            if index < imageArray.count {
                petal.setImage(UIImage(named: imageArray[index]), for: UIControlState())
            }
            petal.setTitle(String(arr[index]), for: UIControlState())
            petal.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
            self.superview?.addSubview(petal)
            self.superview?.bringSubview(toFront: self)
            childButtonsArray.append(petal)
        }
        self.presentationForCenter()
    }
    
    // Present Buttons
    @IBAction func animateChildButtons(_ sender: UIButton) {
        scaleAnimate(sender)
        self.isUserInteractionEnabled = false
//        if !isOpen {
//            self.presentationForCenter()
//        }else{
//            closeButtons()
//        }
    }
    
    //Simple Scale
    private func scaleAnimate(_ sender: UIView) {
        UIView.animate(withDuration: self.duration, animations: {
        sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { (completion) in
            UIView.animate(withDuration: self.duration, animations: {
            sender.transform = CGAffineTransform.identity
            })
        })
    }
    
    // Center
    private func presentationForCenter() {
        for (index, item) in self.childButtonsArray.enumerated() {
        self.degree = getRadian(degree: (circumference/CGFloat(childButtons))*CGFloat(index))
        //            UIView.animate(withDuration: self.duration, delay: self.delayInterval+(Double(index)/10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
        item.center = CGPoint(x: self.anchorPoint.x+(self.radius*cos(self.degree)), y: self.anchorPoint.y+(self.radius*sin(self.degree)))
        //            }, completion: { (completion) in
        self.isOpen = true
        if index == self.childButtonsArray.count-1 {
            self.isUserInteractionEnabled = true
        }
        //            })
        }
    }
    
    
    func rotate() {
        self.transform = self.transform.rotated(by: CGFloat(
        Double.pi))
    }
    
    
    
    // Close Button
    private func closeButtons() {
        UIView.animate(withDuration: self.duration, animations: {
        for (_,item) in self.childButtonsArray.enumerated() {
            item.center = self.center
        }
        }, completion: { (completion) in
            self.isOpen = false
            self.isUserInteractionEnabled = true
        })
    }
    
    // Remove Buttons
    func removeButtons() {
        for item in childButtonsArray {
        item.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        scaleAnimate(sender)
        if buttonActionDidSelected != nil {
            buttonActionDidSelected(sender.tag)
        }
    }
}


