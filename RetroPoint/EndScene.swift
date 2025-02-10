import SpriteKit
import GameplayKit
public class EndScene: SKScene {
    var timeLabel: SKLabelNode!
    override public func sceneDidLoad() {
        guard let timeLabel = childNode(withName: "timeLabel") as? SKLabelNode else {
            fatalError("TimeLabel node not loaded")
        }
        self.timeLabel = timeLabel
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFit
            self.scene?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
    public func sceneTime(time: TimeInterval) {
        var date = Date(timeIntervalSinceReferenceDate: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        timeLabel.text = "Final Time: " + dateFormatter.string(from: date)
    }
}

