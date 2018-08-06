//
//  UsefulExtensions.swift
//  ButtonWheel
//
//  Created by Shubham Dhingra  on 01/20/17.
//

import Foundation
import UIKit

extension CGRect {
    mutating func setCenter(_ point : CGPoint){
        self.origin = CGPoint(x: point.x - self.width / 2, y: point.y - self.height / 2)
    }
}

extension UIView {
    
    //MARK: - Bounce Animation
    func springAnimate() {
        
        self.transform = CGAffineTransform.identity
        self.transform = CGAffineTransform(scaleX: 0.58, y: 0.58)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut],
                       animations: {
                        self.transform = CGAffineTransform.identity
                        self.transform = CGAffineTransform(scaleX: 0.58, y: 0.58)
        },
                       completion: { finish in
                        if CreateWheel.numberOfCollisions < 2 {
                            self.springAnimate()
                        }
                        CreateWheel.numberOfCollisions += 1
        })
}
}
