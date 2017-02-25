//
//  Util.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class Util {
    static func getCenterForBubbleAt(row: Int, col: Int, radius: CGFloat) -> CGPoint {
        var x = radius + 2 * CGFloat(col) * radius
        let y = radius + sqrt(3) * CGFloat(row) * radius
        if row % 2 == 1 {
            x += radius
        }
        return CGPoint(x: x, y: y)
    }
    
    static func getRandomBubbleType() -> BubbleType {
        let randomInteger = arc4random_uniform(UInt32(Constant.NUMB_BUBBLE_COLOUR))
        return BubbleType(rawValue: Int(randomInteger))!
    }
}
