import Foundation
import SpriteKit
import GameplayKit


struct CollisionType {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let player: UInt32 = UInt32(1)
    static let platform: UInt32 = UInt32(2)
    static let obstacle: UInt32 = UInt32(4)
    static let letter: UInt32 = UInt32(8)
    static let powerUp: UInt32 = UInt32(16)
    static let leftBorder: UInt32 = UInt32(32)
    static let bottomBorder: UInt32 = UInt32(64)
    static let rightBorder: UInt32 = UInt32(128)
    static let topBorder: UInt32 = UInt32(256)
    static let spike: UInt32 = UInt32(512)
}

// main gameScene class
public class GameScene: SKScene, SKPhysicsContactDelegate {
    // Nodes
    var player: SKSpriteNode!
    var leftBorderNode: SKSpriteNode!
    var bottomBorderNode: SKSpriteNode!
    var rightBorderNode: SKSpriteNode!
    var topBorderNode: SKSpriteNode!
    var timeLabel: SKLabelNode!
    var life1: SKSpriteNode!
    var life2: SKSpriteNode!
    var life3: SKSpriteNode!
    var w1Label: SKLabelNode!
    var w2Label: SKLabelNode!
    var dLabel: SKLabelNode!
    var cLabel: SKLabelNode!
    var oneLabel: SKLabelNode!
    var nineLabel: SKLabelNode!
    var backgroundMusic: SKAudioNode!
    // Extra variables
    var touchLocation: CGPoint!
    let movementSpeed: CGFloat = 750
    let obstacleTexture = SKTexture(imageNamed: "obstacle")
    let powerUpTexture = SKTexture(imageNamed: "powerUp")
    let spikeTexture = SKTexture(imageNamed: "mouse1")
    var letterIcons = ["W", "W", "D", "C", "1", "9"]
    var rightDown = false
    var leftDown = false
    
    // variables for the update method
    var timePrevious: TimeInterval = 0
    var timeCurrent: TimeInterval = 0.0
    var timeBetween: TimeInterval = 0.0
    var timeTotal: TimeInterval = 0.0
    var timePlatformWait = 1.0
    var timePlatform: TimeInterval = 1.0
    var timeObstacle: TimeInterval = 1.0
    var timeObstacleWait = 3.0
    var timeSpike: TimeInterval = 1.0
    var timeSpikeWait = 6.0
    var timePowerUp: TimeInterval = 0.0
    var timePowerUpWait = 8.0
    var timeLetter: TimeInterval = 0.0
    var timeLetterWait = 10.0
    var timeHit: TimeInterval = 0.0
    
    //game variables
    var lives = 3
    
    // didMove method
    override public func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        guard let leftBorderNode = childNode(withName: "leftBorderNode") as? SKSpriteNode else {
            fatalError("leftBorderNode not loaded")
        }
        self.leftBorderNode = leftBorderNode
        guard let rightBorderNode = childNode(withName: "rightBorderNode") as? SKSpriteNode else {
            fatalError("rightBorderNode not loaded")
        }
        self.rightBorderNode = rightBorderNode
        guard let bottomBorderNode = childNode(withName: "bottomBorderNode") as? SKSpriteNode else {
            fatalError("bottomBorderNode not loaded")
        }
        self.bottomBorderNode = bottomBorderNode
        guard let topBorderNode = childNode(withName: "topBorderNode") as? SKSpriteNode else {
            fatalError("topBorderNode not loaded")
        }
        self.topBorderNode = topBorderNode
        guard let player = self.childNode(withName: "player") as? SKSpriteNode else {
            fatalError("Player node not loaded")
        }
        self.player = player
        playerPhysics()
        guard let life1 = self.childNode(withName: "life1") as? SKSpriteNode else {
            fatalError("Life1 node not loaded")
        }
        self.life1 = life1
        guard let life2 = self.childNode(withName: "life2") as? SKSpriteNode else {
            fatalError("Life2 node not loaded")
        }
        self.life2 = life2
        guard let life3 = self.childNode(withName: "life3") as? SKSpriteNode else {
            fatalError("Life3 node not loaded")
        }
        self.life3 = life3
        guard let timeLabel = self.childNode(withName: "timeLabel") as? SKLabelNode else {
            fatalError("TimeLabel node not loaded")
        }
        self.timeLabel = timeLabel
        guard let w1Label = self.childNode(withName: "w1Label") as? SKLabelNode else {
            fatalError("W1Label node not loaded")
        }
        self.w1Label = w1Label
        guard let w2Label = self.childNode(withName: "w2Label") as? SKLabelNode else {
            fatalError("W2Label node not loaded")
        }
        self.w2Label = w2Label
        guard let dLabel = self.childNode(withName: "dLabel") as? SKLabelNode else {
            fatalError("DLabel node not loaded")
        }
        self.dLabel = dLabel
        guard let cLabel = self.childNode(withName: "cLabel") as? SKLabelNode else {
            fatalError("CLabel node not loaded")
        }
        self.cLabel = cLabel
        guard let oneLabel = self.childNode(withName: "oneLabel") as? SKLabelNode else {
            fatalError("OneLabel node not loaded")
        }
        self.oneLabel = oneLabel
        guard let nineLabel = self.childNode(withName: "nineLabel") as? SKLabelNode else {
            fatalError("NineLabel node not loaded")
        }
        self.nineLabel = nineLabel
        
        // MUSIC
        if let soundPlayer = Bundle.main.url(forResource: "song", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: soundPlayer)
            addChild(backgroundMusic)
        }
        
        // Set up left border
        self.leftBorderNode.physicsBody = SKPhysicsBody(rectangleOf: leftBorderNode.size)
        self.leftBorderNode.physicsBody?.restitution = 0
        self.leftBorderNode.physicsBody?.friction = 0
        self.leftBorderNode.physicsBody?.categoryBitMask = CollisionType.leftBorder
        self.leftBorderNode.physicsBody?.isDynamic = false
        
        // Set up right border
        self.rightBorderNode.physicsBody = SKPhysicsBody(rectangleOf: rightBorderNode.size)
        self.rightBorderNode.physicsBody?.restitution = 0
        self.rightBorderNode.physicsBody?.friction = 0
        self.rightBorderNode.physicsBody?.categoryBitMask = CollisionType.rightBorder
        self.rightBorderNode.physicsBody?.isDynamic = false
        
        // Set up bottom border
        self.bottomBorderNode.physicsBody = SKPhysicsBody(rectangleOf: bottomBorderNode.size)
        self.bottomBorderNode.physicsBody?.restitution = 0
        self.bottomBorderNode.physicsBody?.friction = 0
        self.bottomBorderNode.physicsBody?.categoryBitMask = CollisionType.bottomBorder
        self.bottomBorderNode.physicsBody?.isDynamic = false
        
        // Set up top border
        self.topBorderNode.physicsBody = SKPhysicsBody(rectangleOf: topBorderNode.size)
        self.topBorderNode.physicsBody?.restitution = 0
        self.topBorderNode.physicsBody?.categoryBitMask = CollisionType.topBorder
        self.topBorderNode.physicsBody?.friction = 0
        self.topBorderNode.physicsBody?.isDynamic = false
        
    }
    override public func update(_ timeCurrent: TimeInterval) {
        if lives != 0 {
            if timePrevious == 0 {
                timeBetween = 0
            }
            else {
                timeBetween = timeCurrent - timePrevious
            }
            timePrevious = timeCurrent
            timeTotal += timeBetween
            timeHit += timeBetween
            var date = Date(timeIntervalSinceReferenceDate: timeTotal) 
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm:ss"
            timeLabel.text = "Time: " + dateFormatter.string(from: date)
            self.timeCurrent = timeCurrent
            if (timeCurrent - timePlatform) >= timePlatformWait {
                addPlatform()
                
                timePlatform = timeCurrent
            }
            if ((timeCurrent - timePowerUp) >= timePowerUpWait) && lives < 3 {
                addPowerUp()
                timePowerUp = timeCurrent
            }
            if(timeCurrent  - timeObstacle) >= timeObstacleWait {
                addObstacle()
                timeObstacle = timeCurrent
            }
            if(timeCurrent  - timeSpike) >= timeSpikeWait {
                addSpike()
                timeSpike = timeCurrent
            }
            if(timeCurrent  - timeLetter) >= timeLetterWait {
                addLetter()
                timeLetter = timeCurrent
            }
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let xPosition = touches.first!.location(in: self).x
        if xPosition >= CGFloat(0) {
            player.physicsBody?.velocity.dx = movementSpeed
        }
        else if xPosition < CGFloat(0) {
            player.physicsBody?.velocity.dx = -movementSpeed
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity.dx = 0
    }
    public func playerPhysics() {
        player.physicsBody?.collisionBitMask = CollisionType.platform | CollisionType.bottomBorder | CollisionType.leftBorder | CollisionType.rightBorder | CollisionType.topBorder
        player.physicsBody?.categoryBitMask = CollisionType.player
        player.physicsBody?.contactTestBitMask = CollisionType.all
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.restitution = 0
        player.physicsBody?.isDynamic = true
        player.physicsBody?.friction = 0
    }
    // Random methods
    public func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    public func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // adding the platform
    public func addPlatform() {
        let platform = SKSpriteNode(imageNamed: "appleTV")
        platform.xScale = 0.75
        platform.yScale = 0.75
        let randomDegree = random(min: 0, max: 7)
        let randomPlatform = random(min: -350 , max: -50)
        let degree = [-1 * Float.pi / 4, Float.pi / 4, Float.pi / 4, Float.pi / 2, 0, 0, 0]
        platform.position = CGPoint(x: size.width + platform.size.width/2, y: randomPlatform)
        //platform.zRotation = degree[randomDegree]
        addChild(platform)
        let actionMove = SKAction.move(to: CGPoint(x: -1280, y: randomPlatform), duration: TimeInterval(3.0))
        let actionMoveDone = SKAction.removeFromParent()
        platform.run(SKAction.sequence([actionMove, actionMoveDone]))
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.restitution = 0
        platform.physicsBody?.friction = 0
        platform.physicsBody?.categoryBitMask = CollisionType.platform
    }
    public func addPowerUp(){
        let powerUp = SKSpriteNode(imageNamed: "finderIcon")
        powerUp.xScale = 0.7
        powerUp.yScale = 0.7
        let randomPowerUp = random(min: -300 , max: 300)
        powerUp.position = CGPoint(x: randomPowerUp, y: size.height + powerUp.size.height/2)
        addChild(powerUp)
        let powerUpTime = random(min: CGFloat(3.0), max: CGFloat(4.0))
        let powerUpAction = SKAction.move(to: CGPoint(x: randomPowerUp, y: -500), duration: TimeInterval(powerUpTime))
        let powerUpActionDone = SKAction.removeFromParent()
        powerUp.run(SKAction.sequence([powerUpAction, powerUpActionDone]))
        powerUp.physicsBody = SKPhysicsBody(texture: powerUpTexture, size: powerUp.size)
        powerUp.physicsBody?.isDynamic = false
        powerUp.physicsBody?.restitution = 0
        powerUp.physicsBody?.friction = 0
        powerUp.physicsBody?.categoryBitMask = CollisionType.powerUp
    }
    public func addObstacle(){
        let obstacle = SKSpriteNode(imageNamed: "obstacle")
        obstacle.xScale = 3
        obstacle.yScale = 3
        let randomObstacle = random(min: -600 , max: 600)
        obstacle.position = CGPoint(x: randomObstacle, y: size.height + obstacle.size.height/2)
        addChild(obstacle)
        let obstacleTime = random(min: CGFloat(5.0), max: CGFloat(7.0))
        let obstacleMove = SKAction.move(to: CGPoint(x: randomObstacle, y: -500), duration: TimeInterval(obstacleTime))
        let obstacleMoveDone = SKAction.removeFromParent()
        let obstacleRotation = SKAction.rotate(byAngle: (.pi * 2) * -1, duration: TimeInterval(0.75))
        obstacle.run(SKAction.sequence([obstacleMove, obstacleMoveDone]))
        obstacle.run(SKAction.repeatForever(obstacleRotation))
        obstacle.physicsBody = SKPhysicsBody(texture: obstacleTexture, size: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.restitution = 0
        obstacle.physicsBody?.friction = 0
        obstacle.physicsBody?.categoryBitMask = CollisionType.obstacle
    }
    public func addSpike(){
        let spike = SKSpriteNode(imageNamed: "mouse1")
        spike.xScale = 0.1
        spike.yScale = 0.1
        let spikeY = random(min: -300 , max: 300)
        spike.position = CGPoint(x: size.width + spike.size.width/2, y: spikeY)
        spike.zPosition = 1
        spike.zRotation = .pi / 2
        addChild(spike)
        let spikeTime = random(min: CGFloat(1.0), max: CGFloat(4.0))
        let spikeMove = SKAction.move(to: CGPoint(x: -800, y: spikeY), duration: TimeInterval(spikeTime))
        let spikeMoveDone = SKAction.removeFromParent()
        spike.run(SKAction.sequence([spikeMove, spikeMoveDone]))
        spike.physicsBody = SKPhysicsBody(texture: spikeTexture, size: spike.size)
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.restitution = 0
        spike.physicsBody?.friction = 0
        spike.physicsBody?.categoryBitMask = CollisionType.spike
    }
    public func addLetter(){
        let letter = SKLabelNode(text: letterIcons.first!)
        letter.fontName = "Pixelation"
        letter.fontSize = CGFloat(96.0)
        let randomLetter = random(min: -150 , max: 150)
        letter.position = CGPoint(x: size.width * 1.25, y: randomLetter)
        letter.zPosition = 15
        addChild(letter)
        let letterMove = SKAction.move(to: CGPoint(x: -800, y: randomLetter), duration: TimeInterval(4.0))
        let letterMoveDone = SKAction.removeFromParent()
        letter.run(SKAction.sequence([letterMove, letterMoveDone]))
        letter.physicsBody = SKPhysicsBody(rectangleOf: letter.frame.size)
        letter.physicsBody?.isDynamic = false
        letter.physicsBody?.restitution = 0
        letter.physicsBody?.friction = 0
        letter.physicsBody?.categoryBitMask = CollisionType.letter
    }
    public func didBegin(_ contact: SKPhysicsContact) {
        // first and second body declaration
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // different collisions
        switch firstBody.categoryBitMask {
        case CollisionType.player:
            switch secondBody.categoryBitMask {
            case CollisionType.platform:
                player.physicsBody?.velocity.dy = 1250
            case CollisionType.bottomBorder:
                player.physicsBody?.velocity.dy = 1250
            case CollisionType.leftBorder:
                player.physicsBody?.velocity.dx = 0
                lives -= 1
                updateLives()
                let playerSad = SKAction.setTexture(SKTexture(imageNamed: "A13sad"))
                let playerTime = SKAction.wait(forDuration: 2.0)
                let playerHappy = SKAction.setTexture(SKTexture(imageNamed: "A13happy"))
                player.run(SKAction.sequence([playerSad, playerTime, playerHappy]))
                let playerWhite = SKAction.run {
                    self.player.alpha = 0.5
                }
                let playerDuration = SKAction.wait(forDuration: 0.25)
                let playerNormal = SKAction.run {
                    self.player.alpha = 1
                }
                player.run(SKAction.repeat(SKAction.sequence([ playerWhite, playerDuration, playerNormal, playerDuration]), count: 4))
            case CollisionType.rightBorder:
                player.physicsBody?.velocity.dx = 0
            case CollisionType.obstacle:
                if timeHit >= 2 {
                    secondBody.node?.removeFromParent()
                    lives -= 1
                    updateLives()
                    timeHit = 0
                    let playerSad = SKAction.setTexture(SKTexture(imageNamed: "A13sad"))
                    let playerTime = SKAction.wait(forDuration: 2.0)
                    let playerHappy = SKAction.setTexture(SKTexture(imageNamed: "A13happy"))
                    player.run(SKAction.sequence([playerSad, playerTime, playerHappy]))
                    let playerWhite = SKAction.run {
                        self.player.alpha = 0.5
                    }
                    let playerDuration = SKAction.wait(forDuration: 0.25)
                    let playerNormal = SKAction.run {
                        self.player.alpha = 1
                    }
                    player.run(SKAction.repeat(SKAction.sequence([ playerWhite, playerDuration, playerNormal, playerDuration]), count: 4))
                }
            case CollisionType.spike:
                if timeHit >= 2 {
                    secondBody.node?.removeFromParent()
                    lives -= 1
                    updateLives()
                    timeHit = 0
                    let playerSad = SKAction.setTexture(SKTexture(imageNamed: "A13sad"))
                    let playerTime = SKAction.wait(forDuration: 2.0)
                    let playerHappy = SKAction.setTexture(SKTexture(imageNamed: "A13happy"))
                    player.run(SKAction.sequence([playerSad, playerTime, playerHappy]))
                    let playerWhite = SKAction.run {
                        self.player.alpha = 0.5
                    }
                    let playerDuration = SKAction.wait(forDuration: 0.25)
                    let playerNormal = SKAction.run {
                        self.player.alpha = 1
                    }
                    player.run(SKAction.repeat(SKAction.sequence([playerWhite, playerDuration, playerNormal, playerDuration]), count: 4))
                }
            case CollisionType.powerUp:
                secondBody.node?.removeFromParent()
                if lives < 3 {
                    lives += 1
                    updateLives()
                }
            case CollisionType.letter:
                secondBody.node?.removeFromParent()
                letterIcons.remove(at: 0)
                switch letterIcons.count {
                case 5:
                    w1Label.fontColor = UIColor.white
                case 4:
                    w2Label.fontColor = UIColor.white
                case 3:
                    dLabel.fontColor = UIColor.white
                case 2:
                    cLabel.fontColor = UIColor.white
                case 1:
                    oneLabel.fontColor = UIColor.white
                case 0:
                    gameWin()
                default:
                    break
                }
            default:
                break
            }
        default:
            break
        }
    }
    public func updateLives(){
        switch lives {
        case 0:
            self.life1.isHidden = true
            self.life2.isHidden = true
            self.life3.isHidden = true
            gameOver()
        case 1:
            self.life1.isHidden = true
            self.life2.isHidden = true
            self.life3.isHidden = false
        case 2:
            self.life1.isHidden = true
            self.life2.isHidden = false
            self.life3.isHidden = false
        case 3:
            self.life1.isHidden = false
            self.life2.isHidden = false
            self.life3.isHidden = false
        default:
            break
        }
    }
    public func gameOver() {
        player.physicsBody?.isDynamic = false
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if let scene = EndScene(fileNamed: "EndScene") {
            scene.scaleMode = .aspectFit
            scene.sceneTime(time: self.timeTotal)
            self.scene?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
    public func gameWin() {
        player.physicsBody?.isDynamic = false
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if let scene = WinScene(fileNamed: "WinScene") {
            scene.scaleMode = .aspectFit
            scene.sceneTime(time: self.timeTotal)
            self.scene?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
}
