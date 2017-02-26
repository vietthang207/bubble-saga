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
    @IBOutlet var upcommingBubbles: [UIImageView]!
    @IBOutlet var scoreView: UITextField!
    @IBOutlet var bubbleLimitView: UITextField!
    
    var levelName: String?
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private var radius: CGFloat = 1.0
    
    private var upcomingBubbleType = Queue<BubbleType>()
    
    // Controller to control projectile's MVC
    private var projectileControllers: [ProjectileController] = []
    private var freeFallBubbleControllers: [BubbleController] = []
    
    // Coordinate where all projectile stared at
    private var origin = CGPoint(x: 1.0, y: 1.0)
    
    // Physics engine's world object to simulate
    private var world = World()
    
    // Collection of the controllers of all bubbles on the grid
    private var bubbleControllers = [[BubbleController]]()
    
    // Graph to support bfs checking
    private var graph = BubbleGraph(numRow: Constant.NUMB_ROWS, numCol: Constant.NUMB_COLUMNS)
    
    private var cannonView = UIImageView()
    private var cannonBaseView = UIImageView()
    private var cannonDirection = CGVector(dx: 0, dy: 1)
    
    private var bubbleLimit: Int = Constant.DEFAULT_BUBBLE_LIMIT
    private var score: Int = 0
    private var isGameOver: Bool = false
    
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
        if let levelName = levelName {
            loadLevelWithName(levelName)
        }
        
    }
    
    private func loadCannonArea() {
        cannonArea.backgroundColor = .clear
        gameArea.addSubview(cannonArea)
    }
    
    private func loadCannon() {
        let cannonImage = UIImage(named: Constant.IMAGE_NAME_CANNON)
        let rect = CGRect(x: 0, y: 0, width: Constant.CANNON_IMAGE_WIDTH, height: Constant.CANNON_IMAGE_HEIGHT)
        let imageRef = cannonImage?.cgImage?.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!)
        cannonView.removeFromSuperview()
        cannonView = UIImageView(image: image)
        let cannonHeight = Constant.RATIO_CANNON_HEIGHT_OVER_RADIUS * radius
        let cannonWidth = Constant.RATIO_CANNON_WIDTH_OVER_RADIUS * radius
        let x = origin.x - cannonWidth / 2
        let y = origin.y - cannonHeight / 2
        cannonView.frame = CGRect(x: x, y: y, width: cannonWidth, height: cannonHeight)
        rotateCannon()
        gameArea.addSubview(cannonView)
        
        let cannonBaseImage = UIImage(named: Constant.IMAGE_NAME_CANNON_BASE)
        cannonBaseView.removeFromSuperview()
        cannonBaseView = UIImageView(image: cannonBaseImage)
        cannonBaseView.frame = CGRect(x: x, y: y + Constant.FRAME_DIFFERENT_Y_AXIS, width: cannonWidth, height: cannonWidth)
        gameArea.addSubview(cannonBaseView)
    }
    
    private func rotateCannon() {
        if cannonDirection.dy > 0 {
            return
        }
        let angle = Util.getAngleInRadianFromVector(cannonDirection)
        cannonView.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    // Run only once when view loading
    private func prepareNewProjectile() {
        while upcomingBubbleType.count < Constant.UPCOMMING_BUBBLE_QUEUE_SIZE && bubbleLimit > 0 {
            upcomingBubbleType.enqueue(Util.getRandomBubbleType())
            bubbleLimit -= 1
        }
        
        let physicalProjectile = Projectile(center: origin, radius: radius, velocity: CGVector(dx: 0, dy: 0))
        guard let startingType = try? upcomingBubbleType.dequeue() else {
            return
        }
        if bubbleLimit > 0 {
            upcomingBubbleType.enqueue(Util.getRandomBubbleType())
            bubbleLimit -= 1
        }
        let upcomingBubbleArray = upcomingBubbleType.toArray()
        for i in 0..<upcommingBubbles.count {
            upcommingBubbles[i].image = Util.getImageForBubbleType(.empty)
        }
        for i in 0..<upcomingBubbleArray.count {
            upcommingBubbles[i].image = Util.getImageForBubbleType(upcomingBubbleArray[i])
        }
        
        let bubbleModel = BubbleModel(type: startingType,
                                      center: origin,
                                      radius: radius)
        let bubbleView = BubbleView(image: Util.getImageForBubbleType(startingType),
                                    center: origin,
                                    radius: radius)
        bubbleView.alpha = CGFloat(Constant.ALPHA_FULL)
        
        let projectileController = ProjectileController(model: bubbleModel, view: bubbleView, physicalProjectile: physicalProjectile)
        projectileControllers.append(projectileController)
        gameArea.addSubview(projectileController.view)
        loadCannon()
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
            cannonDirection = location.subtract(origin)
            rotateCannon()
        } else if recognizer.state == .ended && recognizer.state != .failed {
            let location = recognizer.location(in: gameArea)
            fireAt(location: location)
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: gameArea)
        cannonDirection = location.subtract(origin)
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
        makeBubblesFreeFallByIndexList(midAirBubbles)
        
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(Constant.TIME_STEP), target: self, selector: #selector(GamePlayViewController.gameLoop), userInfo: nil, repeats: true)
        
    }
    
    func gameLoop() {
        scoreView.text = String(score)
        bubbleLimitView.text = String(bubbleLimit)
        if bubbleLimit <= 0 && projectileControllers.count == 0 {
            showGameOverPopup()
        }
        processFreeFallBubbles()
        _ = world.simulate(timeStep: Constant.TIME_STEP)
        for i in (0..<projectileControllers.count).reversed() {
            let projectileController = projectileControllers[i]
            let physicalProjectile = projectileController.physicalProjectile
            let y = physicalProjectile.getCenter().y
            if physicalProjectile.isStopped() || y > origin.y {
                let index = getClosestEmptyCellTo(point: (physicalProjectile.getCenter()))
                if isProjectile(physicalProjectile, closeToIndex: index) {
                    snapProjectile(projectileController, toIndex: index)
                } else {
                    makeProjectileFreeFall(projectile: projectileController)
                }
                projectileController.view.removeFromSuperview()
                projectileControllers.remove(at: i)
                world.removeProjectileAtIndex(i)
            } else {
                projectileController.updateState()
            }
        }
    }
    
    private func makeProjectileFreeFall(projectile: ProjectileController) {
        let center = projectile.getCenter()
        let bubbleModel = BubbleModel(type: projectile.getType(),
                                      center: CGPoint(x: center.x, y: center.y),
                                      radius: radius)
        let bubbleView = BubbleView(image: Util.getImageForBubbleType(projectile.getType()),
                                    center: CGPoint(x: center.x, y: center.y),
                                    radius: radius)
        bubbleView.alpha = CGFloat(Constant.ALPHA_FULL)
        
        let newBubbleController = BubbleController(model: bubbleModel, view: bubbleView)
        gameArea.addSubview(newBubbleController.view)
        freeFallBubbleControllers.append(newBubbleController)
    }
    
    private func processFreeFallBubbles() {
        let movementVector = CGVector(dx: 0, dy: Constant.SPEED_FREE_FALL).dot(scalar: Constant.TIME_STEP)
        for  i in (0..<freeFallBubbleControllers.count).reversed() {
            let bubbleController = freeFallBubbleControllers[i]
            let center = bubbleController.getCenter()
            let newCenter = center.translate(vector: movementVector)
            bubbleController.changeViewWithCenter(newCenter, newRadius: radius)
            if newCenter.y > origin.y {
                bubbleController.view.removeFromSuperview()
                freeFallBubbleControllers.remove(at: i)
            }
        }
    }
    
    func snapProjectile(_ projectile: ProjectileController, toIndex: Index) {
        let activatingType = projectile.getType()
        setBubbleOfType(activatingType, atIndex: toIndex)
        let connectedComponent = graph.getAndDeleteConnectedComponentOfTheSameColorAt(row: toIndex.row, col: toIndex.col)
        if connectedComponent.count >= Constant.GROUP_SIZE_TO_EXPLODE {
            explodeBubbleByIndexList(connectedComponent)
        }
        let destroyedBySpecialBubbles = graph.activateSpecialBubblesAdjacentTo(row: toIndex.row, col: toIndex.col, activatingType: activatingType)
        explodeBubbleByIndexList(destroyedBySpecialBubbles)
        let midAirBubbles = self.graph.getAndRemoveMidAirBubbles()
        makeBubblesFreeFallByIndexList(midAirBubbles)
    }
    
    func isProjectile(_ projectile: Projectile, closeToIndex index: Index) -> Bool {
        let center = projectile.getCenter()
        let location = Util.getCenterForBubbleAt(row: index.row, col: index.col, radius: radius)
        let distance = center.subtract(location).length()
        return distance < radius
    }
    
    private func explodeBubbleByIndexList(_ list: [Index]) {
        for index in list {
            explodeBubbleAtIndex(index)
        }
    }
    
    private func explodeBubbleAtIndex(_ index: Index) {
        let row = index.row
        let col = index.col
        if bubbleControllers[row][col].getType() != .empty {
            score += 1
        }
        self.world.deleteBubbleAtIndex(index)
        
        UIView.animate(withDuration: Constant.ANIMATION_DUTATION_FADING, animations: {
            self.bubbleControllers[row][col].view.alpha = 0
        }, completion: { _ in
            self.bubbleControllers[row][col].changeType(.empty)
        })

    }
    
    private func makeBubblesFreeFallByIndexList(_ list: [Index]) {
        for index in list {
            makeBubbleFreeFallAtIndex(index)
        }
    }
    
    private func makeBubbleFreeFallAtIndex(_ index: Index) {
        let row = index.row
        let col = index.col
        let type = bubbleControllers[row][col].getType()
        if type != .empty {
            score += 1
        }
        self.world.deleteBubbleAtIndex(index)
        
        let newBubbleController = createEmptyBubble(radius: radius, row: row, col: col)
        newBubbleController.changeType(type)
        freeFallBubbleControllers.append(newBubbleController)
        self.bubbleControllers[row][col].changeType(.empty)
    }
    
    private func showGameOverPopup() {
        if isGameOver {
            return
        }
        isGameOver = true
        let alert = UIAlertController(title: Constant.ALERT_MSG_GAME_OVER,
                                      message: Constant.ALERT_MSG_SHOW_SCORE + String(score),
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
        let bubbleView = BubbleView(image: Util.getImageForBubbleType(.empty),
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
    
    private func setBubbleOfType(_ bubbleType: BubbleType, atIndex index: Index) {
        if bubbleType == .empty {
            return
        }
        bubbleControllers[index.row][index.col].changeType(bubbleType)
        let center = Util.getCenterForBubbleAt(row: index.row, col: index.col, radius: radius)
        let newBubble = CircleCollidable(center: center, radius: radius)
        world.addBubbleAtIndex(index, bubble: newBubble)
        graph.changeBubbleTypeAt(row: index.row, col: index.col, type: bubbleType)
    }
    
    private func loadLevelWithName(_ name: String) {
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
            loadGameLevel(gameLevel: gameLevel)
        }
    }
    
    private func loadGameLevel(gameLevel: GameLevel) {
        let list = gameLevel.getBubbleCollection()
        var counter = 0
        for row in 0..<Constant.NUMB_ROWS {
            var numBubbles = Constant.NUMB_COLUMNS
            if row % 2 == 1 {
                numBubbles -= 1
            }
            for col in 0..<numBubbles {
                setBubbleOfType(BubbleType(rawValue: Int(list[counter]))!, atIndex: Index(row: row, col: col))
                counter += 1
            }
        }
    }
    
}

