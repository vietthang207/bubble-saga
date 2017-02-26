//
//  ProjectileController.swift
//  GameEngine
//
//  Created by dinhvt on 23/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit
import PhysicsEngine

class ProjectileController: BubbleController {
    var physicalProjectile: Projectile
    
    init(model: BubbleModel, view: BubbleView, physicalProjectile: Projectile) {
        self.physicalProjectile = physicalProjectile
        super.init(model: model, view: view)
    }
    
    func updateState() {
        self.changeViewWithCenter(physicalProjectile.getCenter(), newRadius: physicalProjectile.getRadius())
    }
    
}
