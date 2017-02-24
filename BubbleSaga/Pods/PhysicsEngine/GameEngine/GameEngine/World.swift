//
//  World.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

public class World {
    
    private var projectiles: [Projectile]
    private var borders: [Collidable]
    private var bubbles: [Index: CircleCollidable]
    
    public init() {
        projectiles = [Projectile]()
        borders = [Collidable]()
        bubbles = [Index: CircleCollidable]()
    }
    
    public func simulate(timeStep: CGFloat) -> Bool {
        var willCollide = false
        outer: for projectile in projectiles {
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
    
    public func getProjectiles() -> [Projectile] {
        return projectiles
    }
    
    public func addProjectile(_ projectile: Projectile) {
        projectiles.append(projectile)
    }
    
    public func removeProjectileAtIndex(_ index: Int) {
        projectiles.remove(at: index)
    }
    
    public func addBorder(_ border: Collidable) {
        borders.append(border)
    }
    
    public func deleteBubbleAtIndex(_ index: Index) {
        bubbles[index] = nil
    }
    
    public func addBubbleAtIndex(_ index: Index, bubble: CircleCollidable) {
        bubbles[index] = bubble
    }
    
}

public struct Index: Hashable {
    public var row: Int
    public var col: Int
    
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    public var hashValue: Int {
        return row.hashValue ^ col.hashValue
    }
    
    public static func ==(lhs: Index, rhs: Index) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
}
