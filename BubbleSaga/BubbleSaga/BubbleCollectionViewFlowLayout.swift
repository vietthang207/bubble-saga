//
//  GridViewController.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class BubbleCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let radius: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        self.radius = 1.0
        super.init(coder: aDecoder)
    }
    
    init(radius: CGFloat) {
        self.radius = radius
        super.init()
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        itemSize = CGSize(width: 2 * radius, height: 2 * radius)
        estimatedItemSize = CGSize(width: 2 * radius, height: 2 * radius)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForItem(at: indexPath)
        let center = Util.getCenterForBubbleAt(row: indexPath.section, col: indexPath.item, radius: radius)
        attribute?.center = center
        attribute?.frame = CGRect(x: center.x - radius,
                                  y: center.y - radius,
                                  width: 2 * radius,
                                  height: 2 * radius)
        return attribute
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else {
            return
        }
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        for attribute in attributesArray {
            if let newAttribute = layoutAttributesForItem(at: attribute.indexPath) {
                newAttributesArray.append(newAttribute)
            }
        }
        return newAttributesArray
    }
    
}
