//
//  ViewController.swift
//  RouletteWheel
//
//  Created by Shubham Dhingra  on 01/20/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import UIKit
import GLKit
import SpriteKit

class WheelVC : UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var imgInnerWheel : UIImageView?
    @IBOutlet weak var imgOuterWheel : UIImageView?
    @IBOutlet weak var imgBall : UIImageView?
    @IBOutlet weak var numberView : ButtonWheel?
    @IBOutlet weak var txtNumber : UITextField?
    @IBOutlet weak var btnRotate : UIButton?
 
    //MARK::- VARIABLES
    var numberArr = [Int]()
    
    /// Roulette Numbers
    var realNumbers :[Int] = CreateWheel.array
    var numberIndex = 0.0
    
    /// Number Of Rotations
    var numberOfRotation = 5.0
    var radianOfSector = 0.16929
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    //MARK: - Append Numbers
    func appendNumbers(){
        numberArr = []
        while index < 37 {
            numberArr.append(index)
            index += 1
        }
    }
    
    //MARK: - OnViewDidLoad
    func onViewDidLoad() {
        self.imgBall?.transform = (self.imgBall?.transform.rotated(by: -0.42345))!
        self.imgInnerWheel?.transform = (self.imgInnerWheel?.transform.rotated(by: 0.0174533))!
        self.appendNumbers()
        numberView?.transform = CGAffineTransform(rotationAngle: -0.0695)
        numberView?.setupWith(buttonPieces: CreateWheel.makeButtonArray(buttonArr: realNumbers), middleRadius: .medium)
    }
    
    //MARK: - Rotate button Action
    @IBAction func btnActionRotate(_ sender: Any) {
        
        if let number = Int(txtNumber?.text ?? "") {
            
            numberIndex = Double(self.getIndex(number))
            
            //when the entered number not in the list
            if numberIndex == -1 {
                txtNumber?.text = nil
                showAlert()
                return
            }
            self.imgBall!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.isUserInteractionEnabled = false
            btnRotate?.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 12.5, execute: {
                self.btnRotate?.isHidden = false
                self.view.isUserInteractionEnabled = true
            })
        }
        
        self.removeAllAnimations()
        CreateWheel.numberOfCollisions = 0
        rotateWheel()
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Alert", message: "Please choose number from wheel The entered number is not present in wheel", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Remove Animations
    func removeAllAnimations() {
        self.imgBall!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.imgInnerWheel?.layer.removeAllAnimations()
        self.imgBall?.layer.removeAnimation(forKey: AnimationTypes.animation.rawValue)
        self.numberView?.layer.removeAllAnimations()
    }
    
    //MARK: - Get Index of element
    func getIndex(_ chosenIndex: Int ) -> Int {
        return realNumbers.contains(chosenIndex) ? (realNumbers.index(of: chosenIndex) ?? -1) : -1
    }

    //MARK: - Rotate Wheel
    func rotateWheel() {
        self.numberView?.layer.add(self.animation(type: .Number), forKey: AnimationTypes.animation.rawValue)
        self.imgInnerWheel?.layer.add(self.animation(type: .BackImage), forKey: AnimationTypes.animation.rawValue)
        self.imgBall?.layer.add(self.ballanimation(), forKey: AnimationTypes.animation.rawValue)
        UIView.animate(withDuration: 15.5, delay: 0.0, options: .curveEaseOut, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.view.layoutIfNeeded()
                self.ballTransForm()
            })})
    }
    
    //MARK: - Scaling Ball
    func ballTransForm() {
        UIView.animate(withDuration: 4.0,delay: 1.0 , options: [.curveEaseIn , .curveEaseInOut ],animations: {
            let transform = CGAffineTransform(scaleX: 0.62, y: 0.62)
            self.imgBall?.transform = transform
        }){ finished in
            self.imgBall!.springAnimate()
        }
    }
}


//MARK::- CABasicAnimation
extension WheelVC {
   
    //MARK: - Ball Animation and Rotation
    func ballanimation() -> CABasicAnimation{
        let rotateView = CABasicAnimation(keyPath: AnimationTypes.zRotation.rawValue)
        rotateView.fromValue = -0.42345
        let angle = numberIndex != 0.0 ? ((((numberIndex * radianOfSector) / 2) * 3) - radianOfSector - 0.23316) :  -0.42345
        rotateView.toValue = NSNumber(value : -((numberOfRotation * Double.pi) - (angle)))
        rotateView.duration = 12.5
        rotateView.setUpAnimation()
        return rotateView
    }
    
    //MARK: -Inner Wheel Rotation
    func animation(type: AnimationObject) -> CABasicAnimation{
        let rotateView = CABasicAnimation(keyPath: AnimationTypes.zRotation.rawValue)
        let angle = (numberIndex * (radianOfSector / 2))
        let value = NSNumber(value : (numberOfRotation * Double.pi) + angle - (type == .BackImage ? 0.0 : 0.0695 ) )
        rotateView.toValue = value
        rotateView.duration = 10
        rotateView.setUpAnimation()
        return rotateView
    }
}


//MARK::- Textfield Delegate
extension WheelVC {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
