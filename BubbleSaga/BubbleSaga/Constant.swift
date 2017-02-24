//
//  Constant.swift
//  LevelDesigner
//
//  Created by dinhvt on 3/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

struct Constant {
    
    static let IMAGE_NAME_BACKGROUND = "background.png"
    static let IMAGE_NAME_BUBBLE_BLUE = "bubble-blue.png"
    static let IMAGE_NAME_BUBBLE_GREEN = "bubble-green.png"
    static let IMAGE_NAME_BUBBLE_ORANGE = "bubble-orange.png"
    static let IMAGE_NAME_BUBBLE_RED = "bubble-red.png"
    static let IMAGE_NAME_ERASER = "erase.png"
    
    static let BUTTON_NAME_BLUE = "blue"
    static let BUTTON_NAME_GREEN = "green"
    static let BUTTON_NAME_ORANGE = "orange"
    static let BUTTON_NAME_RED = "red"
    static let BUTTON_NAME_ERASE = "erase"
    
    static let REUSE_IDENTIFIER = "BubbleCell"
    
    static let NUMB_COLUMNS = 12
    static let NUMB_ROWS = 9
    
    static let ALPHA_HALF = CGFloat(0.5)
    static let ALPHA_FULL = CGFloat(1.0)
    
    static let NUMB_BUBBLE_TYPE = 4
    
    static let ALERT_MSG_RESET = "You are about to reset the level, are you sure?"
    static let ALERT_MSG_OVERWRITE = "This will overwrite current game level, are you sure?"
    static let ALERT_MSG_SAVED = "Game level saved as "
    static let ALERT_MSG_SAVE_NEW_GAME = "Do you want to save as a new game level"
    static let ALERT_MSG_INVALID_NAME = "Game level name cannot be empty or spaces only!"
    static let ALERT_MSG_ASK_NAME = "Enter game level name!"
    static let ALERT_MSG_OVERWRITE_OR_NOT = "Do you want to overwrite existing level or save game level as a new one?"
    static let ALERT_MSG_DUPLICATED_NAME = "The name you entered is existed, would you like to overwrite it or enter a new name?"
    static let ALERT_MSG_LOAD = "Enter the level name to load"
    static let ALERT_MSG_NOT_FOUND = "No saved game level to load"
    static let ALERT_MSG_GAME_OVER = "Game over!"
    
    static let BUTTON_YES = "Yes"
    static let BUTTON_NO = "No"
    static let BUTTON_OVERWRITE = "Overwrite"
    static let BUTTON_SAVE_AS = "Save as"
    static let BUTTON_CANCEL = "Cancel"
    static let BUTTON_SAVE = "Save"
    static let BUTTON_NEWNAME = "New name"
    static let BUTTON_LOAD = "Load"
    static let BUTTON_OK = "Ok"
    
    static let POPUP_DELAY = 1.0
    
    static let KEY_GAME_LEVEL = "gameLevel"
    static let KEY_BUBBLE_COLLECTION = "levelBubbles"
    static let KEY_GAME_LEVEL_NAME = "levelName"
    
    static let FILE_EXTENSION_PLIST = ".plist"
    static let FILENAME_GAME_LEVEL_LIST = "game_level_list.plist"
    
    static let TIME_STEP = CGFloat(1.0/60.0)
    static let SPEED = CGFloat(1000)
    
    static let INFINITY_FLOAT = CGFloat(99999999)
    
    static let GROUP_SIZE_TO_EXPLODE = 3
    
    static let ANIMATION_DUTATION_FADING = 1.0
}

enum BubbleType: Int {
    case empty = -1
    case blue
    case green
    case orange
    case red
    
    func nextType() -> BubbleType {
        if self == .empty {
            return .empty
        }
        return BubbleType(rawValue: ((self.rawValue + 1) % Constant.NUMB_BUBBLE_TYPE))!
    }
}

enum PaletteState {
    case noneSelected
    case blue
    case orange
    case green
    case red
    case erase
}
