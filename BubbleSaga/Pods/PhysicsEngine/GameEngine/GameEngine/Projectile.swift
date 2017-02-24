//
//  Projectile.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

public class Projectile: Collidable {
    private var center: CGPoint
    private var radius: CGFloat
    private var velocity: CGVector
    private var isMoving: Bool
    
    public init() {
        self.center = CGPoint(x: 0, y: 0)
        self.radius = 0
        self.velocity = CGVector(dx: 0, dy: 0)
        self.isMoving = true
    }
    
    public init(center: CGPoint, radius: CGFloat, velocity: CGVector) {
        self.center = center
        self.radius = radius
        self.velocity = velocity
        self.isMoving = true
    }
    
    public func stop() {
        velocity = CGVector(dx: 0, dy: 0)
        isMoving = false
    }
    
    public func reflect() {
        velocity = CGVector(dx: -velocity.dx, dy: velocity.dy)
    }
    
    public func getRadius() -> CGFloat {
        return radius
    }
    
    public func getCenter() -> CGPoint {
        return center
    }
    
    public func getVelocity() -> CGVector {
        return velocity
    }
    
    public func setVelocity(velocity: CGVector) {
        self.velocity = velocity
    }
    
    public func isStopped() -> Bool {
        return !isMoving
    }
    
    public func advance(timeStep: CGFloat) {
        center = center.translate(vector: velocity.dot(scalar: timeStep))
    }
    
    public func willCollideWith(projectile: Projectile) -> Bool {
        let a = self.center
        let b = projectile.center
        let ab = b.subtract(a)
        let ba = a.subtract(b)
        if ab.dot(vector: velocity) <= 0 && ba.dot(vector: projectile.getVelocity()) <= 0 {
            return false
        }
        if ab.length() > self.radius + projectile.radius {
            return false
        }
        
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
        
        return true
    }

}
