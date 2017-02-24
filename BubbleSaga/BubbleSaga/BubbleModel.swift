//
//  BubbleModel.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class BubbleModel: NSObject {
    private var type: BubbleType
    private var center: CGPoint
    private var radius: CGFloat
    
    /// default constructor
    override init() {
        type = .empty
        center = CGPoint(x: 0, y: 0)
        radius = CGFloat(1)
    }
    
    init(type: BubbleType, center: CGPoint, radius: CGFloat) {
        self.type = type
        self.center = center
        self.radius = radius
    }
    
    func setBubbleType(_ newType: BubbleType) {
        self.type = newType
    }
    
    func getNextType() -> BubbleType {
        return self.type.nextType()
    }
    
    func updateViewWithCenter(_ newCenter: CGPoint, newRadius: CGFloat) {
        self.center = newCenter
        self.radius = newRadius
    }
    
    func getBubbleType() -> BubbleType {
        return type
    }
    
    func getBubbleCenter() -> CGPoint {
        return center
    }
    
    func getBubbleRadius() -> CGFloat {
        return radius
    }
    
}
