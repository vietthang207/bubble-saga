//
//  ViewController.swift
//  GameEngine
//
//  Created by dinhvt on 10/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import UIKit
import PhysicsEngine

class GamePlayViewController: UIViewController {
    @IBOutlet var gameArea: UIView!
    @IBOutlet var cannonArea: UIView!
    @IBOutlet var gameOverLine: UIView!
    
    var data: [[BubbleType]]?
    private var radius: CGFloat = 1.0
    
    // Controller to control projectile's MVC
    private var projectileControllers: [ProjectileController] = []
    
    // Coordinate where all projectile stared at
    private var origin = CGPoint(x: 1.0, y: 1.0)
    
    // Physics engine's world object to simulate
    private var world = World()
    
    // Collection of the controllers of all bubbles on the grid
    private var bubbleControllers = [[BubbleController]]()
    
    // Graph to support bfs checking
    private var graph = BubbleGraph(numRow: Constant.NUMB_ROWS, numCol: Constant.NUMB_COLUMNS)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        radius = self.view.frame.size.width / CGFloat(2 * Constant.NUMB_COLUMNS)
        let x = cannonArea.frame.midX
        let y = cannonArea.frame.midY
        origin = CGPoint(x: x, y: y)
        loadBackground()
        loadGameOverLine()
        loadGrid()
        loadCannonArea()
        prepareNewProjectile()
        addGestureRecognizersForGrid()
        runGameLoop()
    }
    
    private func loadBackground() {
        let backgroundImage = UIImage(named: Constant.IMAGE_NAME_BACKGROUND)
        let background = UIImageView(image: backgroundImage)
        
        let gameViewHeight = gameArea.frame.size.height
        let gameViewWidth = gameArea.frame.size.width
        
        background.frame = CGRect(x: 0, y: 0, width: gameViewWidth, height: gameViewHeight)
        gameArea.addSubview(background)
    }
    
    private func loadGameOverLine() {
        gameOverLine.backgroundColor = .red
        gameArea.addSubview(gameOverLine)
    }
    
    private func loadGrid() {
        loadEmptyGrid(radius: radius)
        if let data = data {
            for row in 0..<Constant.NUMB_ROWS {
                var numberBubbles = Constant.NUMB_COLUMNS
                if row % 2 == 1 {
                    numberBubbles -= 1
                }
                
                for col in 0..<numberBubbles {
                    if data[row][col] == .empty {
                        continue
                    }
                    let index = Index(row: row, col: col)
                    setBubbleOfType(data[row][col], atIndex: index)
                }
            }
        }
        
    }
    
    private func loadCannonArea() {
        cannonArea.backgroundColor = .clear
        gameArea.addSubview(cannonArea)
    }
    
    // Run only once when view loading
    private func prepareNewProjectile() {
        let physicalProjectile = Projectile(center: origin, radius: radius, velocity: CGVector(dx: 0, dy: 0))
        let startingType = Util.getRandomBubbleType()
        let bubbleModel = BubbleModel(type: startingType,
                                      center: origin,
                                      radius: radius)
        let bubbleView = BubbleView(image: BubbleView.getImageForBubbleType(startingType),
                                    center: origin,
                                    radius: radius)
        bubbleView.alpha = CGFloat(Constant.ALPHA_FULL)
        
        let projectileController = ProjectileController(model: bubbleModel, view: bubbleView, physicalProjectile: physicalProjectile)
        projectileControllers.append(projectileController)
        gameArea.addSubview(projectileController.view)
    }
    
    private func addGestureRecognizersForGrid() {
        gameArea.isUserInteractionEnabled = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        gameArea.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        gameArea.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .ended && recognizer.state != .failed {
            //rotate the cannon
            let location = recognizer.location(in: gameArea)
            fireAt(location: location)
        } else if recognizer.state == .ended && recognizer.state != .failed {
            let location = recognizer.location(in: gameArea)
            fireAt(location: location)
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: gameArea)
        fireAt(location: location)
    }
    
    private func fireAt(location: CGPoint) {
        let aimingVector = location.subtract(origin)
        let unitVector = CGVector(dx: aimingVector.dx/aimingVector.length(), dy: aimingVector.dy/aimingVector.length())
        let velocity = unitVector.dot(scalar: Constant.SPEED)
        if velocity.dy > 0 {
            return
        }
        if let projectileController = projectileControllers.last {
            projectileController.physicalProjectile.setVelocity(velocity: velocity)
            world.addProjectile(projectileController.physicalProjectile)
            gameArea.addSubview(projectileController.view)
            prepareNewProjectile()
        }
    }
    
    private func runGameLoop() {
        let ceiling = HorizontalCollidable(y: 0)
        let leftWall = VerticalCollidable(x: gameArea.frame.minX)
        let rightWall = VerticalCollidable(x: gameArea.frame.maxX)
        world.addBorder(ceiling)
        world.addBorder(leftWall)
        world.addBorder(rightWall)
        let midAirBubbles = self.graph.getAndRemoveMidAirBubbles()
        self.clearBubbleByIndexList(midAirBubbles)
        
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(Constant.TIME_STEP), target: self, selector: #selector(GamePlayViewController.gameLoop), userInfo: nil, repeats: true)
        
    }
    
    func gameLoop() {
        let willCollide = world.simulate(timeStep: Constant.TIME_STEP)
        for i in (0..<projectileControllers.count).reversed() {
            let projectileController = projectileControllers[i]
            let physicalProjectile = projectileController.physicalProjectile
            let y = physicalProjectile.getCenter().y
            if physicalProjectile.isStopped() || y > origin.y {
                let index = getClosestEmptyCellTo(point: (physicalProjectile.getCenter()))
                if index.row == Constant.NUMB_ROWS - 1 {
                    //showGameOverPopup()
                }
                snapProjectile(projectileController, toIndex: index)
                projectileController.view.removeFromSuperview()
                projectileControllers.remove(at: i)
                world.removeProjectileAtIndex(i)
            } else {
                projectileController.updateState()
            }
        }
    }
    
    func snapProjectile(_ projectile: ProjectileController, toIndex: Index) {
        setBubbleOfType(projectile.getType(), atIndex: toIndex)
        let connectedComponent = graph.getAndDeleteConnectedComponentOfTheSameColorAt(row: toIndex.row, col: toIndex.col)
        if connectedComponent.count >= Constant.GROUP_SIZE_TO_EXPLODE {
            self.clearBubbleByIndexList(connectedComponent)
            let midAirBubbles = self.graph.getAndRemoveMidAirBubbles()
            self.clearBubbleByIndexList(midAirBubbles)
        }
    }
    
    private func clearBubbleByIndexList(_ list: [Index]) {
        for index in list {
            clearBubbleAtIndex(index)
        }
    }
    
    private func clearBubbleAtIndex(_ index: Index) {
        let row = index.row
        let col = index.col
        self.world.deleteBubbleAtIndex(index)
        
        UIView.animate(withDuration: Constant.ANIMATION_DUTATION_FADING, animations: {
            self.bubbleControllers[row][col].changeType(.empty)
        })
        
    }
    
    private func showGameOverPopup() {
        let alert = UIAlertController(title: Constant.ALERT_MSG_GAME_OVER,
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constant.BUTTON_OK,
                                      style: .default,
                                      handler: nil ))
        
        present(alert, animated: true, completion: nil)
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
    
    private func createEmptyBubble(radius: CGFloat, row: Int, col: Int) -> BubbleController{
        let center = Util.getCenterForBubbleAt(row: row, col: col, radius: radius)
        let bubbleModel = BubbleModel(type: .empty,
                                      center: CGPoint(x: center.x, y: center.y),
                                      radius: radius)
        let bubbleView = BubbleView(image: BubbleView.getImageForBubbleType(.empty),
                                    center: CGPoint(x: center.x, y: center.y),
                                    radius: radius)
        bubbleView.alpha = CGFloat(Constant.ALPHA_FULL)
        
        let bubbleController = BubbleController(model: bubbleModel, view: bubbleView)
        gameArea.addSubview(bubbleController.view)
        return bubbleController
    }
    
    func getClosestEmptyCellTo(point: CGPoint) -> Index {
        var result = Index(row: 0, col: 0)
        var minimum = Constant.INFINITY_FLOAT
        for row in 0..<Constant.NUMB_ROWS {
            var numberBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numberBubbles -= 1
            }
            for col in 0..<numberBubbles {
                let type = bubbleControllers[row][col].getType()
                guard type == .empty else {
                    continue
                }
                let center = bubbleControllers[row][col].getCenter()
                let dist = point.subtract(center).length()
                if dist < minimum {
                    minimum = dist
                    result = Index(row: row, col: col)
                }
            }
        }
        return result
    }
    
    func setBubbleOfType(_ bubbleType: BubbleType, atIndex index: Index) {
        bubbleControllers[index.row][index.col].changeType(bubbleType)
        let center = Util.getCenterForBubbleAt(row: index.row, col: index.col, radius: radius)
        let newBubble = CircleCollidable(center: center, radius: radius)
        world.addBubbleAtIndex(index, bubble: newBubble)
        graph.changeBubbleTypeAt(row: index.row, col: index.col, type: bubbleType)
    }
    
}

