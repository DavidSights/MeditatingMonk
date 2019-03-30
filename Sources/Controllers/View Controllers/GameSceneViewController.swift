//
//  GameSceneViewController.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/30/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit
import SpriteKit

class GameSceneViewController: UIViewController {

    var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        let gameScene = GameScene(size: view.bounds.size)
        gameScene.gameSceneDelegate = self
        self.gameScene = gameScene

        if let skView = self.view as? SKView {
            skView.presentScene(gameScene)
        }
    }
}

extension GameSceneViewController: GameSceneDelegate {

    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
