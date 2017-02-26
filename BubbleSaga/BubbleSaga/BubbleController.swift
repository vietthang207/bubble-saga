//
//  BubbleCell.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class BubbleController {
    
    var bubbleModel: BubbleModel
    var view: BubbleView
    
    init(model: BubbleModel, view: BubbleView) {
        self.bubbleModel = model
        self.view = view
        self.view.alpha = bubbleModel.getBubbleType() == .empty ? Constant.ALPHA_HALF : Constant.ALPHA_FULL
    }
    
    func getType() -> BubbleType {
        return bubbleModel.getBubbleType()
    }
    
    func getCenter() -> CGPoint {
        return bubbleModel.getBubbleCenter()
    }
    
    func changeType(_ newType: BubbleType) {
        bubbleModel.setBubbleType(newType)
        view.setNewImage(Util.getImageForBubbleType(newType))
        self.view.alpha = bubbleModel.getBubbleType() == .empty ? Constant.ALPHA_HALF : Constant.ALPHA_FULL
    }
    
    func cycleType() {
        changeType(bubbleModel.getNextType())
    }
    
    func changeViewWithCenter(_ newCenter: CGPoint, newRadius: CGFloat) {
        bubbleModel.updateViewWithCenter(newCenter, newRadius: newRadius)
        view.setCenterAndRadius(newCenter: newCenter, newRadius: newRadius)
    }
    
}
