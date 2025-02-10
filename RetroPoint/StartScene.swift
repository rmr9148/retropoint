import SpriteKit
import GameplayKit
public class StartScene: SKScene {
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = DebriefScene(fileNamed: "DebriefScene") {
            scene.scaleMode = .aspectFit
            self.scene?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
}

