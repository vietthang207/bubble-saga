//
//  LevelSelectionViewController.swift
//  BubbleSaga
//
//  Created by dinhvt on 26/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit

class LevelSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LevelSelectionViewDelegate {
    @IBOutlet var gameLevelTableView: UITableView!
    
    private var gameLevelList: [String] = []
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var selectedLevel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameLevelList()
        loadGameLevelTableView()
        gameLevelTableView.delegate = self
        loadPreloadLevelList()
    }
    
    private func loadGameLevelList() {
        let gameLevelListUrl = documentDirectory.appendingPathComponent(Constant.FILENAME_GAME_LEVEL_LIST)
        if FileManager.default.fileExists(atPath: gameLevelListUrl.path) {
            let data = NSArray(contentsOfFile: gameLevelListUrl.path) as! [String]
            gameLevelList = data
        }
    }
    
    private func loadPreloadLevelList() {
        guard let preloadLevelListPath = Bundle.main.path(forResource: Constant.FILENAME_PRELOAD_LEVEL_LIST, ofType: Constant.TYPE_NAME_PLIST) else {
            return
        }
        if FileManager.default.fileExists(atPath: preloadLevelListPath) {
            let data = NSArray(contentsOfFile: preloadLevelListPath) as! [String]
            gameLevelList.append(contentsOf: data)
        }
    }
    
    private func loadGameLevelTableView() {
        gameLevelTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SEGUE_IDENTIFIER_SELECTION_TO_PLAY {
            if let gamePlayViewController = segue.destination as? GamePlayViewController {
                gamePlayViewController.levelName = selectedLevel
            }
        } else if segue.identifier == Constant.SEGUE_IDENTIFIER_SELECTION_TO_DESIGNER {
            if let levelDesignerViewController = segue.destination as? LevelDesignerViewController {
                levelDesignerViewController.levelName = selectedLevel
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedLevel == nil {
            return false
        }
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.NUMB_TABLE_VIEW_SECTION
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameLevelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.REUSE_IDENTIFIER_TABLE_VIEW, for: indexPath)
        cell.textLabel?.text = gameLevelList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLevel = gameLevelList[indexPath.row]
    }
    
    func didSelectLevelWithName(_ name: String) {
        selectedLevel = name
    }
    
}

protocol LevelSelectionViewDelegate {
    func didSelectLevelWithName(_ name: String)
}
