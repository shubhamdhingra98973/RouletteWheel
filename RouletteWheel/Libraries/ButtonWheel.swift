//
//  ButtonWheel.swift
//  ButtonWheel
//
//  Created by Shubham Dhingra  on 01/20/17.
//

import Foundation
import UIKit
public protocol ButtonWheelDelegate{
    func didTapButtonWheelAtName(name : String)
}

public class ButtonWheel : UIView{
    
    //border color would be something to add
    var shapes = [CAShapeLayer]()
    var buttonPieces = [ButtonPiece]()
    var buttonNames = [String]()
    var numberOfSections = 0
    var dimensionSize : CGFloat = 0
    var backgroundView =  UIView()
    var delegate : ButtonWheelDelegate?
    var middleRadius : CGFloat = 0
    var middleRadiusSetting : MiddleRadiusSize = .medium


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBackgroundView()
        self.isUserInteractionEnabled = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureBackgroundView()
        self.isUserInteractionEnabled = true
    }
    
    func configureBackgroundView(){
       
        dimensionSize = self.frame.width < self.frame.height ? self.frame.width : self.frame.height
        self.middleRadius = dimensionSize * MiddleRadiusSize.medium.rawValue
        self.addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.frame.size = CGSize(width: dimensionSize, height: dimensionSize)
        backgroundView.frame.setCenter(CGPoint(x: frame.width / 2, y: frame.height / 2))
        backgroundView.layer.cornerRadius = dimensionSize / 2
        backgroundView.clipsToBounds = true
    
    }
    
    public func setupWith(buttonPieces : [ButtonPiece], middleRadius : MiddleRadiusSize){
        destroy()
        
        self.buttonPieces = buttonPieces
        self.middleRadiusSetting = middleRadius
        self.middleRadius = dimensionSize * middleRadiusSetting.rawValue
        self.numberOfSections = buttonPieces.count
        for aSubview in backgroundView.subviews{
            aSubview.removeFromSuperview()
        
        }
       
        for (index, aButtonPiece) in buttonPieces.enumerated(){
            let newPieceLayer = ButtonViewBuilder.createPiece(buttonWheel: self, color: aButtonPiece.color, sectionNumber: index)
            print("Indexx",index)
            backgroundView.layer.addSublayer(newPieceLayer)
            shapes.append(newPieceLayer)
            buttonNames.append(aButtonPiece.name)
            ButtonViewBuilder.addButtonBackgroundViewToButton(buttonWheel: self, buttonPiece: aButtonPiece, sectionNumber: index)
        }
    }
    
    func destroy(){
        for aPiece in buttonPieces{
            aPiece.backgroundView.removeFromSuperview()
        }
        
        buttonPieces = []
        
        for aShape in shapes{
            aShape.removeFromSuperlayer()
        }
        shapes = []
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let tappedPoint = touch.location(in: self)
        let buttonName = TouchManagement.getNameFromPoint(buttonWheel: self, tappedPoint: tappedPoint)
        
        guard let unwrappedButtonName = buttonName else {
            return
        }
        delegate?.didTapButtonWheelAtName(name: unwrappedButtonName)
    }  
}



