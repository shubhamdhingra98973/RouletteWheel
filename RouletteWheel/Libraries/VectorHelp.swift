//
//  VectorHelp.swift
//  ButtonWheel
//
//  Created by Shubham Dhingra on 01/20/17.
//

import Foundation
import UIKit

class VectorHelp {
    
    static let twoPi = Double.pi * 2
    
    
    static func angleFromPoints(centerPoint : CGPoint, tappedPoint : CGPoint) -> Double{
        let translatedX = Double(tappedPoint.x - centerPoint.x)
        let translatedY = -1 * Double(tappedPoint.y - centerPoint.y) // the negative is to flip it since y in math increases as you go up
        
        var messedUpResult = atan(translatedY / translatedX)
        if translatedX < 0{
            messedUpResult += Double.pi
        }
        else if translatedY < 0{
            messedUpResult += twoPi
        }
        //messUpResult now follows math convention for radians
        //However for our purposes, we want it to increase clockwise and start with 0 radians on top, which is the next step
        var translatedResult = twoPi - messedUpResult //flips it to increase angle clockwise
        translatedResult += Double.pi / 2
        if translatedY > 0 && translatedX > 0 {
            translatedResult -= twoPi
        }
        return translatedResult
    }
    
    
    static func distanceFromCenter(centerPoint : CGPoint, tappedPoint : CGPoint) -> Double{
        let xdiff = centerPoint.x - tappedPoint.x
        let ydiff = centerPoint.y - tappedPoint.y
        let squaredDistance = xdiff * xdiff + ydiff * ydiff
        
        
        return sqrt(Double(squaredDistance))
    }
    
    static func getCenterOfPiece(buttonWheel : ButtonWheel, sectionNumber : Int) -> CGPoint{
        var distance : Double = 0
        
        //This doesn't give the true middle for wheels with a small center radius. Instead it looks for a point closer to the outside
        //where there's more space. More space is ideal for placing the labels and images
        if buttonWheel.middleRadiusSetting == .small{
            distance = Double(buttonWheel.dimensionSize / 2 - (buttonWheel.dimensionSize / 2 - buttonWheel.middleRadius) / 2.5)

        }
        else{
            //distance = Double(buttonWheel.dimensionSize / 2 - (buttonWheel.dimensionSize / 2 - buttonWheel.middleRadius) / 2)
             distance = Double(buttonWheel.dimensionSize / 1.75 - (buttonWheel.dimensionSize / 1.75 - buttonWheel.middleRadius) / 1.75)
        }
        
        
        let ratioOfCircleToCenterOfPiece = Double(sectionNumber) / Double(buttonWheel.numberOfSections) + 0.5 / Double(buttonWheel.numberOfSections)
        let angle = twoPi * ratioOfCircleToCenterOfPiece
        let tranformedAngle = angle * -1 + Double.pi / 2 //need to transform sincr we defined a polar coordinate system that starts at the top and advances clockwise
        
        let uncorrectedCenter = CGPoint(x: cos(tranformedAngle) * distance , y: sin(tranformedAngle) * distance * -1)
        
        //Now we need to add in the mid point coordinates to correct
        return CGPoint(x: uncorrectedCenter.x + buttonWheel.backgroundView.frame.midX, y: uncorrectedCenter.y + buttonWheel.backgroundView.frame.midY)
    }
    
    
    
    


    
}
