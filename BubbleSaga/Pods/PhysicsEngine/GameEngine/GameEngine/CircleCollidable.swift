//
//  CircleCollidable.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class CircleCollidable: GameObject, Collidable {
    
    private let center: CGPoint
    private let radius: CGFloat
    
    init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }
    
    func willCollideWith(projectile: Projectile) -> Bool {
        let distance = (center.subtract(projectile.getCenter())).length()
        if distance < radius + projectile.getRadius() {
            projectile.stop()
            return true
        }
        return false
    }
}
