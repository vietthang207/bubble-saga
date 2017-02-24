//
//  Projectile.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class Projectile: GameObject, Collidable {
    private var center: CGPoint
    private var radius: CGFloat
    private var velocity: CGVector
    var isMoving: Bool
    
    override init() {
        self.center = CGPoint(x: 0, y: 0)
        self.radius = 0
        self.velocity = CGVector(dx: 0, dy: 0)
        self.isMoving = true
    }
    
    init(center: CGPoint, radius: CGFloat, velocity: CGVector) {
        self.center = center
        self.radius = radius
        self.velocity = velocity
        self.isMoving = true
    }
    
    func stop() {
        velocity = CGVector(dx: 0, dy: 0)
        isMoving = false
    }
    
    func reflect() {
        velocity = CGVector(dx: -velocity.dx, dy: velocity.dy)
    }
    
    func getRadius() -> CGFloat {
        return radius
    }
    
    func getCenter() -> CGPoint {
        return center
    }
    
    func getVelocity() -> CGVector {
        return velocity
    }
    
    func setVelocity(velocity: CGVector) {
        self.velocity = velocity
    }
    
    func isStopped() -> Bool {
        return !isMoving
    }
    
    func advance(timeStep: CGFloat) {
        center = center.translate(vector: velocity.dot(scalar: timeStep))
    }
    
    func willCollideWith(projectile: Projectile) -> Bool {
        let a = self.center
        let b = projectile.center
        let ab = b.subtract(a)
//        if ab.dot(vector: velocity) <= 0 {
//            return false
//        }
        let ba = a.subtract(b)
        if ab.dot(vector: velocity) <= 0 && ba.dot(vector: projectile.getVelocity()) <= 0 {
            return false
        }
        if ab.length() > self.radius + projectile.radius {
            return false
        }
//        print("before")
//        print(self.velocity)
//        print(projectile.velocity)
        
        let d = ab.length()
        let n = ab.dot(scalar: 1/d)
        let va = self.velocity
        let vb = projectile.velocity
        let p = va.dx * n.dx + va.dy * n.dy - vb.dx * n.dx - vb.dy * n.dy
        
        let vxa = va.dx - p * n.dx
        let vya = va.dy - p * n.dy
        let vxb = vb.dx + p * n.dx
        let vyb = vb.dy + p * n.dy
        self.velocity = CGVector(dx: vxa, dy: vya)
        projectile.velocity = CGVector(dx: vxb, dy: vyb)
//        print("after")
//        print(self.velocity)
//        print(projectile.velocity)
        return true
    }

}
