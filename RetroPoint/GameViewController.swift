//
//  GameViewController.swift
//  RetroPoint
//
//  Created by Rahul Raiyani on 3/24/19.
//  Copyright © 2019 Rahul Raiyani. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cfURL1 = Bundle.main.url(forResource: "AlegreyaSansSC-Bold", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL1, CTFontManagerScope.process, nil)
        let cfURL2 = Bundle.main.url(forResource: "CupheadFelix-Regular", withExtension: "otf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL2, CTFontManagerScope.process, nil)
        let cfURL3 = Bundle.main.url(forResource: "Pixelation", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL3, CTFontManagerScope.process, nil)
        let cfURL4 = Bundle.main.url(forResource: "SF-Pro-Display-Bold", withExtension: "otf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL4, CTFontManagerScope.process, nil)
        if let scene = GKScene(fileNamed: "StartScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! StartScene? {
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                    
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
