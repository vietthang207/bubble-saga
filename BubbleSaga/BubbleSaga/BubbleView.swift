//
//  BubbleView.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class BubbleView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage, center: CGPoint, radius: CGFloat) {
        super.init(frame: CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius))
        self.image = image
    }
    
    func setNewImage(_ newImage: UIImage) {
        self.image = newImage
    }
    
    func setCenterAndRadius(newCenter: CGPoint, newRadius: CGFloat) {
        self.frame = CGRect(x: newCenter.x - newRadius, y: newCenter.y - newRadius, width: 2.0 * newRadius, height: 2.0 * newRadius)
    }
    
    static func getImageForBubbleType(_ type: BubbleType) -> UIImage {
        switch (type) {
        case BubbleType.blue:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_BLUE)!
        case BubbleType.green:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_GREEN)!
        case BubbleType.orange:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_ORANGE)!
        case BubbleType.red:
            return UIImage(named: Constant.IMAGE_NAME_BUBBLE_RED)!
        case BubbleType.empty:
            return drawCicle()
        }
    }
    
    /// draw a circle image for empty bubble
    private static func drawCicle() -> UIImage {
        let RADIUS = CGFloat(100)
        
        let frameSize = CGSize(width: RADIUS * 2.0, height: RADIUS * 2.0)
        
        let circlePath = UIBezierPath(roundedRect:CGRect(x: 0, y: 0,
                                                         width: RADIUS * 2.0, height: RADIUS * 2.0), cornerRadius: RADIUS)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.lightGray.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 0.0
        
        UIGraphicsBeginImageContext(frameSize)
        circleLayer.render(in: UIGraphicsGetCurrentContext()!)
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circleImage!
    }
}
