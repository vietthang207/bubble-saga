//
//  ViewController.swift
//  LevelDesigner
//
//  Created by dinhvt on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

class LevelDesignerViewController: UIViewController {
    @IBOutlet var gameArea: UIView!
    @IBOutlet var paletteArea: UIView!
    @IBOutlet var grid: UICollectionView!
    @IBOutlet var paletteButtons: [UIButton]!
    
    private var radius: CGFloat = 1.0
    private var paletteState: PaletteState = .noneSelected
    private var gridViewController = GridViewController(radius: 1.0)
    private var levelName: String?
    private var gameLevelList: [String] = []
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radius = self.view.frame.size.width / CGFloat(2 * Constant.NUMB_COLUMNS)
        loadBackground()
        loadPallette()
        loadGrid()
        addGestureRecognizersForGrid()
        loadGameLevelList()
    }
    
    private func loadBackground() {
        let backgroundImage = UIImage(named: Constant.IMAGE_NAME_BACKGROUND)
        let background = UIImageView(image: backgroundImage)
        
        let gameViewHeight = gameArea.frame.size.height
        let gameViewWidth = gameArea.frame.size.width
        
        background.frame = CGRect(x: 0, y: 0, width: gameViewWidth, height: gameViewHeight)
        gameArea.addSubview(background)
    }
    
    private func loadPallette() {
        gameArea.addSubview(paletteArea)
    }
    
    private func loadGrid() {
        gridViewController = GridViewController(radius: radius)
        grid.dataSource = gridViewController
        grid.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constant.REUSE_IDENTIFIER)
        grid.backgroundColor = .clear
        grid.collectionViewLayout = BubbleCollectionViewFlowLayout(radius: radius)
        gameArea.addSubview(grid)
    }
    
    private func addGestureRecognizersForGrid() {
        grid.isUserInteractionEnabled = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        grid.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        grid.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        grid.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .ended && recognizer.state != .failed {
            let location = recognizer.location(in: grid)
            if let indexPath = grid.indexPathForItem(at: location) {
                gridViewController.changeBubbleByIndexPath(indexPath, paletteState: paletteState)
            }
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: grid)
        if let indexPath = grid.indexPathForItem(at: location) {
            if paletteState != .noneSelected {
                gridViewController.changeBubbleByIndexPath(indexPath, paletteState: paletteState)
            } else {
                gridViewController.cycleBubbleTypeByIndexPath(indexPath)
            }
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: grid)
        if let indexPath = grid.indexPathForItem(at: location) {
            gridViewController.changeBubbleByIndexPath(indexPath, paletteState: .erase)
        }
    }
    
    private func loadGameLevelList() {
        let gameLevelListUrl = documentDirectory.appendingPathComponent(Constant.FILENAME_GAME_LEVEL_LIST)
        if FileManager.default.fileExists(atPath: gameLevelListUrl.path) {
            let data = NSArray(contentsOfFile: gameLevelListUrl.path) as! [String]
            gameLevelList = data
        }
    }
    @IBAction func bubbleSellected(_ sender: Any) {
        let bubbleSelected = sender as! UIButton
        
        var isDeactivation = false
        
        for button in paletteButtons {
            if button == bubbleSelected {
                if button.alpha == Constant.ALPHA_HALF {
                    button.alpha = Constant.ALPHA_FULL
                } else {
                    isDeactivation = true
                    button.alpha = Constant.ALPHA_HALF
                }
            } else {
                button.alpha = Constant.ALPHA_HALF
            }
        }
        
        if isDeactivation {
            // deactivation by tapping on a button that has been already selected
            paletteState = .noneSelected
        } else {
            // tapping on a button that has not been selected
            switch bubbleSelected.currentTitle! {
            case Constant.BUTTON_NAME_BLUE:
                paletteState = .blue
            case Constant.BUTTON_NAME_GREEN:
                paletteState = .green
            case Constant.BUTTON_NAME_ORANGE:
                paletteState = .orange
            case Constant.BUTTON_NAME_RED:
                paletteState = .red
            case Constant.BUTTON_NAME_ERASE:
                paletteState = .erase
            case Constant.BUTTON_NAME_BOMB:
                paletteState = .bomb
            case Constant.BUTTON_NAME_INDESTRUCTIBLE:
                paletteState = .indestructible
            case Constant.BUTTON_NAME_LIGHTNING:
                paletteState = .lightning
            case Constant.BUTTON_NAME_STAR:
                paletteState = .star
            default:
                paletteState = .noneSelected
            }
        }
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        let alert = UIAlertController(title: Constant.ALERT_MSG_RESET,
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_YES,
                                      style: .default,
                                      handler: { _ in self.reset() }))
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_NO,
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        gridViewController.reset()
    }

    @IBAction func savePressed(_ sender: Any) {
        if levelName == nil {
            askNameAndSaveWithMessage("")
        } else {
            saveExistingLevelWithMessage("")
        }
    }
    
    private func askNameAndSaveWithMessage(_ message: String) {
        
        let alert = UIAlertController(title: Constant.ALERT_MSG_ASK_NAME,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: self.configurationHandler)
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_SAVE,
                                      style: .default,
                                      handler: { _ in self.processName((alert.textFields?[0].text)!) }))
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_CANCEL,
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func configurationHandler(textField: UITextField) {
        textField.placeholder = Constant.ALERT_MSG_ASK_NAME
    }
    
    private func processName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedName == "" {
            askNameAndSaveWithMessage(Constant.ALERT_MSG_INVALID_NAME)
        } else if gameLevelList.contains(name) {
            handleDuplicatedName(trimmedName)
        } else {
            saveLevelWithName(trimmedName)
        }
    }
    
    private func handleDuplicatedName(_ name: String) {
        let alert = UIAlertController(title: Constant.ALERT_MSG_DUPLICATED_NAME,
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_OVERWRITE,
                                      style: .default,
                                      handler: { _ in self.saveLevelWithName(name) }))
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_NEWNAME,
                                      style: .cancel,
                                      handler: { _ in self.askNameAndSaveWithMessage("") }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Ask user whether to overwrite existing game level or save as a new one
    private func saveExistingLevelWithMessage(_ message: String) {
        let alert = UIAlertController(title: Constant.ALERT_MSG_OVERWRITE,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_OVERWRITE,
                                      style: .default,
                                      handler: { _ in self.saveLevelWithName(self.levelName!) }))
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_SAVE_AS,
                                      style: .default,
                                      handler: { _ in self.askNameAndSaveWithMessage("") }))
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_CANCEL,
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func saveLevelWithName(_ name: String) {
        levelName = name
        if !gameLevelList.contains(name) {
            gameLevelList.append(name)
            writeGameLevelList()
        }
        gridViewController.setName(name)
        writeGameLevelWithName(name)
        showSaveSuccessful()
    }
    
    private func writeGameLevelWithName(_ name: String) {
        let fileName = name + Constant.FILE_EXTENSION_PLIST
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        let gameLevel = gridViewController.getSavableGameLevelObj()
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(gameLevel, forKey: Constant.KEY_GAME_LEVEL)
        archiver.finishEncoding()
        _ = data.write(to: fileURL, atomically: true)
    }
    
    private func writeGameLevelList() {
        let gameLevelListPath = documentDirectory.appendingPathComponent(Constant.FILENAME_GAME_LEVEL_LIST)
        let data = gameLevelList as NSArray
        _ = data.write(to: gameLevelListPath, atomically: true)
    }
    
    private func showSaveSuccessful() {
        let alert = UIAlertController(title: Constant.ALERT_MSG_SAVED + levelName!,
                                      message: "",
                                      preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        let deadline = DispatchTime.now() + Constant.POPUP_DELAY
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = gridViewController.getBubbleData()
        if let gamePlayViewController = segue.destination as? GamePlayViewController {
            gamePlayViewController.data = data
        }
        
    }
    
    @IBAction func loadPressed(_ sender: Any) {
        if gameLevelList.isEmpty {
            showFileNotFound()
            return
        }
        showGameLevelOptionMenu()
    }
    
    private func showGameLevelOptionMenu() {
        let alert = UIAlertController(title: Constant.ALERT_MSG_LOAD,
                                      message: "",
                                      preferredStyle: .actionSheet)
        
        
        for gameLevel in gameLevelList {
            alert.addAction(UIAlertAction(title: gameLevel,
                                          style: .default,
                                          handler: { _ in self.loadExistingLevelWithName(gameLevel) }))
        }
        
        alert.popoverPresentationController?.sourceView = self.view
        present(alert, animated: true, completion: nil)
    }
    
    private func loadExistingLevelWithName(_ name: String) {
        levelName = name
        let fileName = name + Constant.FILE_EXTENSION_PLIST
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        if let gameLevel = unarchiver.decodeObject(forKey: Constant.KEY_GAME_LEVEL) as? GameLevel {
            gridViewController.loadGameLevel(gameLevel: gameLevel)
        }
    }
    
    private func showFileNotFound() {
        let alert = UIAlertController(title: Constant.ALERT_MSG_NOT_FOUND,
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.alert)
        present(alert, animated: true, completion: nil)
        
        let deadline = DispatchTime.now() + Constant.POPUP_DELAY
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}

