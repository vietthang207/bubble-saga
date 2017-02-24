//
//  HorizontalCollidable.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

public class HorizontalCollidable: Collidable {
    
    private let y: CGFloat
    
    public init(y: CGFloat) {
        self.y = y
    }
    
    public func willCollideWith(projectile: Projectile) -> Bool {
        if projectile.getCenter().y - projectile.getRadius() <= y {
            projectile.stop()
            return true
        }
        return false
    }
}
