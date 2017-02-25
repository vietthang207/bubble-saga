//
//  Util.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class Util {
    static func getCenterForBubbleAt(row: Int, col: Int, radius: CGFloat) -> CGPoint {
        var x = radius + 2 * CGFloat(col) * radius
        let y = radius + sqrt(3) * CGFloat(row) * radius
        if row % 2 == 1 {
            x += radius
        }
        return CGPoint(x: x, y: y)
    }
    
    static func getRandomBubbleType() -> BubbleType {
        let randomInteger = arc4random_uniform(UInt32(Constant.NUMB_BUBBLE_COLOUR))
        return BubbleType(rawValue: Int(randomInteger))!
    }
    
    static func getImageForBubbleType(_ type: BubbleType) -> UIImage {
        switch type {
        case .blue:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_BLUE)!
        case .green:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_GREEN)!
        case .orange:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_ORANGE)!
        case .red:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_RED)!
        case .bomb:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_BOMB)!
        case .indestructible:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_INDESTRUCTIBLE)!
        case .lightning:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_LIGHTNING)!
        case .star:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_STAR)!
        case .empty:
            return drawCircle()
        }
    }
    
    /// draw a circle image for empty bubble
    private static func drawCircle() -> UIImage {
        let RADIUS = Constant.IMAGE_RADIUS
        
        let frameSize = CGSize(width: RADIUS * 2.0, height: RADIUS * 2.0)
        
        let circlePath = UIBezierPath(roundedRect:CGRect(x: 0, y: 0,
                                                         width: RADIUS * 2.0, height: RADIUS * 2.0), cornerRadius: RADIUS)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 0.0
        
        UIGraphicsBeginImageContext(frameSize)
        circleLayer.render(in: UIGraphicsGetCurrentContext()!)
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circleImage!
    }
}
