//
//  Math.swift
//  GameEngine
//
//  Created by dinhvt on 11/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

public extension CGVector {
    func dot(scalar: CGFloat) -> CGVector {
        return CGVector(dx: self.dx * scalar, dy: self.dy * scalar)
    }

    func dot(vector: CGVector) -> CGFloat {
        return self.dx * vector.dx + self.dy * vector.dy
    }
    
    func length() -> CGFloat {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    
}

public extension CGPoint {
    func translate(vector: CGVector) -> CGPoint {
        return CGPoint(x: self.x + vector.dx, y: self.y + vector.dy)
    }
    
    func subtract(_ otherPoint: CGPoint) -> CGVector {
        return CGVector(dx: self.x - otherPoint.x, dy: self.y - otherPoint.y)
    }
    
}
