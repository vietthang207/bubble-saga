//
//  VerticalCollidable.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class VerticalCollidable: GameObject, Collidable {
    
    private let x: CGFloat
    
    init(x: CGFloat) {
        self.x = x
    }
    
    func willCollideWith(projectile: Projectile) -> Bool {
        let center = projectile.getCenter()
        let radius = projectile.getRadius()
        let vx = projectile.getVelocity().dx
        if (center.x > x && center.x - radius < x && vx < 0) || (center.x < x && center.x + radius > x && vx > 0) {
            projectile.reflect()
            return true
        }
        return false
    }
}
