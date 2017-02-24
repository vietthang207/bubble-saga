//
//  HorizontalCollidable.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class HorizontalCollidable: GameObject, Collidable {
    
    private let y: CGFloat
    
    init(y: CGFloat) {
        self.y = y
    }
    
    func willCollideWith(projectile: Projectile) -> Bool {
        if projectile.getCenter().y - projectile.getRadius() <= y {
            projectile.stop()
            return true
        }
        return false
    }
}
