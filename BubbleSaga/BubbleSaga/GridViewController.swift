//
//  GridViewController.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDataSource {
    private var bubbleControllers = [[BubbleController]]()
    private var levelName: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(radius: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        loadEmptyGrid(radius: radius)
    }
    
    func setName(_ name: String) {
        levelName = name
    }
    
    private func loadEmptyGrid(radius: CGFloat) {
        bubbleControllers = [[BubbleController]]()
        for row in 0..<Constant.NUMB_ROWS {
            var bubbleInRow = [BubbleController]()
            var numberBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numberBubbles -= 1
            }
            
            for col in 0..<numberBubbles {
                let newBubbleController = createEmptyBubble(radius: radius, row: row, col: col)
                bubbleInRow.append(newBubbleController)
            }
            bubbleControllers.append(bubbleInRow)
        }
    }
    
    func reset() {
        for row in 0..<Constant.NUMB_ROWS {
            var numberBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numberBubbles -= 1
            }
            
            for col in 0..<numberBubbles {
                bubbleControllers[row][col].changeType(.empty)
            }
        }
    }
    
    private func createEmptyBubble(radius: CGFloat, row: Int, col: Int) -> BubbleController{
        let center = Util.getCenterForBubbleAt(row: row, col: col, radius: radius)
        let bubbleModel = BubbleModel(type: .empty,
                                      center: CGPoint(x: center.x, y: center.y),
                                      radius: radius)
        let bubbleView = BubbleView(image: Util.getImageForBubbleType(.empty),
                                    center: CGPoint(x: center.x, y: center.y),
                                    radius: radius)
        bubbleView.alpha = CGFloat(Constant.ALPHA_FULL)
        
        let bubbleController = BubbleController(model: bubbleModel, view: bubbleView)
        return bubbleController
    }
    
    func changeBubbleByIndexPath(_ indexPath: IndexPath,paletteState: PaletteState) {
        let row = indexPath.section
        let col = indexPath.item
        
        let bubble = bubbleControllers[row][col]
        switch paletteState {
        case .blue:
            bubble.changeType(.blue)
        case .green:
            bubble.changeType(.green)
        case .orange:
            bubble.changeType(.orange)
        case .red:
            bubble.changeType(.red)
        case .erase:
            bubble.changeType(.empty)
        case .bomb:
            bubble.changeType(.bomb)
        case .indestructible:
            bubble.changeType(.indestructible)
        case .lightning:
            bubble.changeType(.lightning)
        case .star:
            bubble.changeType(.star)
        case .noneSelected:
            break
        }
    }
    
    func cycleBubbleTypeByIndexPath(_ indexPath: IndexPath) {
        let row = indexPath.section
        let col = indexPath.item
        
        let bubble = bubbleControllers[row][col]
        bubble.cycleType()
    }
    
    func getBubbleData() -> [[BubbleType]] {
        var list = [[BubbleType]]()
        for row in 0..<Constant.NUMB_ROWS {
            var numberBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numberBubbles -= 1
            }
            list.append([])
            for col in 0..<numberBubbles {
                let bubbleType = bubbleControllers[row][col].getType()
                list[row].append(bubbleType)
            }
        }
        return list
    }
    
    func getSavableGameLevelObj() -> GameLevel {
        var list = [Int32]()
        for row in 0..<Constant.NUMB_ROWS {
            var numberBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numberBubbles -= 1
            }
            
            for col in 0..<numberBubbles {
                let bubbleType = bubbleControllers[row][col].getType()
                list.append(Int32(bubbleType.rawValue))
            }
        }
        return GameLevel(name: levelName!, bubbleList: list)
    }
    
    func loadGameLevel(gameLevel: GameLevel) {
        levelName = gameLevel.getName()
        let list = gameLevel.getBubbleCollection()
        var counter = 0
        for row in 0..<Constant.NUMB_ROWS {
            var numBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numBubbles -= 1
            }
            for col in 0..<numBubbles {
                bubbleControllers[row][col].changeType(BubbleType(rawValue: Int(list[counter]))!)
                counter += 1
            }
        }
    }
    
    // implement UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constant.NUMB_ROWS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return Constant.NUMB_COLUMNS
        }
        return Constant.NUMB_COLUMNS - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.REUSE_IDENTIFIER, for: indexPath)
        let row = indexPath.section
        let col = indexPath.item
        
        let bubbleController = bubbleControllers[row][col]
        let radius = bubbleController.bubbleModel.getBubbleRadius()
        bubbleController.view.frame = CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)
        cell.addSubview(bubbleController.view)
        return cell
    }
    
}
