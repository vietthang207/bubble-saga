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
    static let IMAGE_NAME_BUBBLE_BOMB = "bubble-bomb.png"
    static let IMAGE_NAME_BUBBLE_INDESTRUCTIBLE = "bubble-indestructible.png"
    static let IMAGE_NAME_BUBBLE_LIGHTNING = "bubble-lightning.png"
    static let IMAGE_NAME_BUBBLE_STAR = "bubble-star.png"
    static let IMAGE_NAME_CANNON = "cannon.png"
    static let IMAGE_NAME_CANNON_BASE = "cannon-base.png"
    
    static let BUTTON_NAME_BLUE = "blue"
    static let BUTTON_NAME_GREEN = "green"
    static let BUTTON_NAME_ORANGE = "orange"
    static let BUTTON_NAME_RED = "red"
    static let BUTTON_NAME_ERASE = "erase"
    static let BUTTON_NAME_BOMB = "bomb"
    static let BUTTON_NAME_INDESTRUCTIBLE = "indestructible"
    static let BUTTON_NAME_LIGHTNING = "lightning"
    static let BUTTON_NAME_STAR = "star"
    
    static let REUSE_IDENTIFIER = "BubbleCell"
    static let REUSE_IDENTIFIER_TABLE_VIEW = "GameLevelNameCell"
    static let SEGUE_IDENTIFIER_SELECTION_TO_PLAY = "SelectionToPlay"
    static let SEGUE_IDENTIFIER_SELECTION_TO_DESIGNER = "SelectionToDesigner"
    
    static let NUMB_COLUMNS = 12
    static let NUMB_ROWS = 9
    static let NUMB_TABLE_VIEW_SECTION = 1
    
    static let ALPHA_HALF = CGFloat(0.5)
    static let ALPHA_FULL = CGFloat(1.0)
    
    static let IMAGE_RADIUS = CGFloat(100)

    static let NUMB_BUBBLE_COLOUR = 4
    static let NUMB_BUBBLE_TYPE = 8
    
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
    static let ALERT_MSG_SHOW_SCORE = "Your score is "
    
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
    static let SPEED_FREE_FALL = CGFloat(3000)
    static let FREE_FALL_ACCELERATON = 98
    
    static let INFINITY_FLOAT = CGFloat(99999999)
    
    static let GROUP_SIZE_TO_EXPLODE = 3
    
    static let ANIMATION_DUTATION_FADING = 1.0
    
    static let UPCOMMING_BUBBLE_QUEUE_SIZE = 3
    static let DEFAULT_BUBBLE_LIMIT = 1000
    
    static let RATIO_CANNON_HEIGHT_OVER_RADIUS: CGFloat = 3.8
    static let RATIO_CANNON_WIDTH_OVER_RADIUS: CGFloat = 2.2
    static let FRAME_DIFFERENT_Y_AXIS: CGFloat = 39
    static let CANNON_IMAGE_WIDTH = 220
    static let CANNON_IMAGE_HEIGHT = 400
}

enum BubbleType: Int {
    case empty = -1
    case blue
    case green
    case orange
    case red
    case bomb
    case indestructible
    case lightning
    case star
    
    func nextType() -> BubbleType {
        if self == .empty {
            return .empty
        }
        return BubbleType(rawValue: ((self.rawValue + 1) % Constant.NUMB_BUBBLE_TYPE))!
    }
    
    func hasEffect() -> Bool {
        return self == .bomb || self == .lightning || self == .star
    }
    
}

enum PaletteState {
    case noneSelected
    case blue
    case orange
    case green
    case red
    case erase
    case bomb
    case indestructible
    case lightning
    case star
}
