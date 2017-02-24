//
//  Collidable.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

protocol Collidable {
    
    /**
     Detect whether a projectile will collide with this collidable object.
     
     - Parameter projectile:   The projectile
     
     - Returns: A boolean indicate whether the projectile will collide with this object or not.
     
     - Effects: Alter the projectile state if it collide with this object.
     */
    
    func willCollideWith(projectile: Projectile) -> Bool
    
}
