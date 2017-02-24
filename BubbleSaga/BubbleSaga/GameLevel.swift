//
//  GameLevel.swift
//  LevelDesigner
//
//  Created by dinhvt on 5/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class GameLevel: NSObject, NSCoding {
    
    private var bubbleCollection : [Int32]
    private var gameLevelName : String
    
    override init() {
        self.bubbleCollection = [Int32]()
        self.gameLevelName = ""
    }
    
    /// init value for properties in GameLevelModel
    init(name: String, bubbleList: [Int32]) {
        bubbleCollection = bubbleList
        gameLevelName = name
    }
    
    func getName() -> String {
        return gameLevelName
    }
    
    func getBubbleCollection() -> [Int32] {
        return bubbleCollection
    }
    
    func encode(with aCoder: NSCoder) {
        // This tells the archiver how to encode the object
        aCoder.encode(self.bubbleCollection, forKey: Constant.KEY_BUBBLE_COLLECTION)
        aCoder.encode(self.gameLevelName, forKey: Constant.KEY_GAME_LEVEL_NAME)
    }
    
    required init(coder aDecoder: NSCoder) {
        // This tells the unarchiver how to decode the object
        self.gameLevelName = aDecoder.decodeObject(forKey: Constant.KEY_GAME_LEVEL_NAME) as! String!
        self.bubbleCollection = aDecoder.decodeObject(forKey: Constant.KEY_BUBBLE_COLLECTION) as! [Int32]!
    }
}
