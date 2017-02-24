//
//  BubbleCell.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class BubbleController: UIViewController {
    
    var bubbleModel: BubbleModel
    
    required init?(coder aDecoder: NSCoder) {
        self.bubbleModel = BubbleModel()
        super.init(coder: aDecoder)
    }
    
    init(model: BubbleModel, view: BubbleView) {
        self.bubbleModel = model
        super.init(nibName: nil, bundle: nil)
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
        
        let bubbleView = self.view as! BubbleView
        bubbleView.setNewImage(BubbleView.getImageForBubbleType(newType))
        self.view = bubbleView
        self.view.alpha = bubbleModel.getBubbleType() == .empty ? Constant.ALPHA_HALF : Constant.ALPHA_FULL
    }
    
    func cycleType() {
        changeType(bubbleModel.getNextType())
    }
    
    func changeViewWithCenter(_ newCenter: CGPoint, newRadius: CGFloat) {
        guard let bubbleView = self.view as? BubbleView else {
            return
        }
        bubbleModel.updateViewWithCenter(newCenter, newRadius: newRadius)
        bubbleView.setCenterAndRadius(newCenter: newCenter, newRadius: newRadius)
    }
    
}
