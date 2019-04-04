//
//  GameSceneViewController.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/30/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

class GameSceneViewController: UIViewController {

    var gameScene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        EmailManager.registerDelegate(delegate: self)
    }

    private func setUpAndShowGameScene() {
        gameScene = GameScene(size: view.bounds.size)
        gameScene.gameSceneDelegate = self
        gameScene.stage = Stage(withStageType: .mountains)

        if let skView = self.view as? SKView {
            skView.presentScene(gameScene)
        }
    }
}

// MARK: - Game Scene Delegate

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

    func shareScore(_ score: String) {

        // Create the content.
        guard let screenShotImage = ImageManager.screenshotImage(withView: view) else { return }
        let appStoreUrlString = "https://itunes.apple.com/us/app/meditating-monk/id904463280"
        let shareMessage = "I scored \(score) while playing Meditating Monk. Can you beat my score?\n\(appStoreUrlString)"

        // Create the share sheet.
        let activityViewController = UIActivityViewController(activityItems: [screenShotImage, shareMessage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view

        // Show the share sheet.
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - Email Manager Delegate

extension GameSceneViewController: EmailManagerDelegate {

    func showEmailViewController(_ emailViewController: UIViewController) {
        present(emailViewController, animated: true, completion: nil)
    }

    func dismissEmailViewController(_ emailViewController: UIViewController) {
        emailViewController.dismiss(animated: true, completion: nil)
    }
}
