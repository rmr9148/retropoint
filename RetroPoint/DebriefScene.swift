import SpriteKit
import GameplayKit
public class DebriefScene: SKScene {
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = KeyScene(fileNamed: "KeyScene") {
            scene.scaleMode = .aspectFit
            self.scene?.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.3))
        }
    }
}

