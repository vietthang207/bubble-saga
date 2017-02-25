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
    
}
