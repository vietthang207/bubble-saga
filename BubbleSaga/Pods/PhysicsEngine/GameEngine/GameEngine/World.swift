//
//  World.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class World {
    
    private var projectiles: [Projectile]
    private var borders: [Collidable]
    private var bubbles: [Index: CircleCollidable]
    
    init() {
        projectiles = [Projectile]()
        borders = [Collidable]()
        bubbles = [Index: CircleCollidable]()
    }
    
    func simulate(timeStep: CGFloat) -> Bool {
//        print("proj count")
//        print(projectiles.count)
        var willCollide = false
        outer: for projectile in projectiles {
//            print(projectile.getVelocity())
            projectile.advance(timeStep: timeStep)
            for (_, b) in bubbles {
                if b.willCollideWith(projectile: projectile) {
                    willCollide = true
                    continue outer
                }
            }
            for b in borders {
                if b.willCollideWith(projectile: projectile) {
                    willCollide = true
                    continue outer
                }
            }
            for otherProjectile in projectiles {
                if projectile === otherProjectile {
                    continue
                }
                if otherProjectile.willCollideWith(projectile: projectile) {
                    willCollide = true
                }
            }
        }
        return willCollide
    }
    
    func getProjectiles() -> [Projectile] {
        return projectiles
    }
    
    func addProjectile(_ projectile: Projectile) {
        projectiles.append(projectile)
        //print(projectiles.last?.getVelocity())
    }
    
    func removeProjectileAtIndex(_ index: Int) {
        projectiles.remove(at: index)
    }
    
    func addBorder(_ border: Collidable) {
        borders.append(border)
    }
    
    func deleteBubbleAtIndex(_ index: Index) {
        bubbles[index] = nil
    }
    
    func addBubbleAtIndex(_ index: Index, bubble: CircleCollidable) {
        bubbles[index] = bubble
    }
    
}

struct Index: Hashable {
    var row: Int
    var col: Int
    
    var hashValue: Int {
        return row.hashValue ^ col.hashValue
    }
    
    static func ==(lhs: Index, rhs: Index) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
