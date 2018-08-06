//
//  ButtonPiece.swift
//  ButtonWheel
//
//  Created by Shubham Dhingra  on 01/20/17.
//

import Foundation
import UIKit

public struct ButtonPiece {
    
    var offsetFromDefaultCenter = CGPoint(x: 0, y: 0)
    var nameLabel : UILabel?
    var backgroundView : UIView
    var name : String
    var color : UIColor
    var numberOfSections : Int = 37
    
    public init(name : String, color : UIColor, centerOffset : CGPoint) {
        self.name = name
        self.color = color
        self.backgroundView = UIView()
        self.offsetFromDefaultCenter = centerOffset
    }

    public mutating func setLabel(maxLabelWidth : CGFloat, labelFont : UIFont, textColor : UIColor, index : Int){
        if let nameLabel = self.nameLabel{
            nameLabel.removeFromSuperview()
        }
        nameLabel = UILabel()
        nameLabel?.text = self.name
        nameLabel?.textColor = UIColor.white
        nameLabel?.font = UIFont.boldSystemFont(ofSize: 8.0)
        nameLabel?.numberOfLines = 0
        nameLabel?.frame.size = CGSize(width: maxLabelWidth, height: 0)
        nameLabel?.sizeToFit()
        configureSubviews(index: index)
    }
    
   
    
    func configureSubviews(index : Int){
        for aSubview in backgroundView.subviews{
            aSubview.removeFromSuperview()
        }
    
       if let nameLabel = nameLabel{
            nameLabel.frame = CGRect(origin: CGPoint(x: offsetFromDefaultCenter.x, y: offsetFromDefaultCenter.y), size: nameLabel.frame.size)
            //backgroundView.frame = CGRect(x: nameLabel.frame.origin.x, y:nameLabel.frame.origin.y, width: 14.0, height: 14.0)
            backgroundView.frame = nameLabel.frame
            nameLabel.transform =  CGAffineTransform(rotationAngle:  rotateLabelBy(index: index))
            backgroundView.addSubview(nameLabel)
        }
    }
    
    func rotateLabelBy(index : Int) -> CGFloat {
        var angle : CGFloat?
        var rotateIndex : Int? = 0
        switch index {
        
        case 0...17:
        rotateIndex = index + 1
        
        default:
        rotateIndex = index - numberOfSections + 1
       
        }
        angle = CGFloat(((Double.pi / 2) / 9.5) * Double(rotateIndex ?? 0))
        return angle  ?? 0.0
       }
    }

