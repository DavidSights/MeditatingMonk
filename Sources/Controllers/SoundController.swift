//
//  SoundController.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/31/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation
import SpriteKit
import AVKit

@objc class SoundController: NSObject {

    private enum SoundEffect {
        case jump
        case button
        case gameOver
        case highScore

        var fileName: String {
            switch self {
            case .jump:
                return "jumpSound.mp3"
            case .button:
                return "buttonSound.wav"
            case .gameOver:
                return "gameOverSound.mp3"
            case .highScore:
                return "highScoreSound.mp3"
            }
        }

        var action: SKAction {
            return SKAction.playSoundFileNamed(fileName, waitForCompletion: true)
        }
    }

    // MARK: - Properties

    /// A sound effects node. This is a node because it makes
    /// switching between sounds much easier.
    private let soundEffectsPlayer = SKNode()

    /// An audio player dedicated to playing game music.
    private var musicPlayer: AVAudioPlayer!

    // MARK: - Initialization

    // Made private because initializing with a scene instance is required.
    private override init() {
        super.init()
    }

    /// Sets up the sound controller and adds a sound node to the passed scene.
    /// - parameter scene: The `SKScene` instance which the sound effects node will be added to.
    @objc init(forScene scene: SKScene) {
        super.init()
        setUpMusicPlayer()
        scene.addChild(soundEffectsPlayer)
    }

    // MARK: - Setup

    private func setUpMusicPlayer() {

        guard let musicFilePath = Bundle.main.path(forResource: "musicLoop", ofType: "wav") else {
            print("Failed to set up music player because the `musicLoop.wav` could not be found.")
            return
        }

        let musicUrl = NSURL(fileURLWithPath: musicFilePath) as URL

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicUrl)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
        } catch {
            print("Error while creating music player: \(error.localizedDescription)")
        }
    }

    // MARK: - Sound Effects
    
    private func playSoundEffect(_ soundEffect: SoundEffect) {
        soundEffectsPlayer.run(soundEffect.action)
    }

    @objc func playJumpSound() {
        playSoundEffect(.jump)
    }

    @objc func playButtonSound() {
        playSoundEffect(.button)
    }

    @objc func playGameOverSound() {
        playSoundEffect(.gameOver)
    }

    @objc func playHighScoreSound() {
        playSoundEffect(.highScore)
    }

    // MARK: - Music

    /// Begins playing music (leaving off from where paused if necessary).
    @objc func playMusic() {
        if musicPlayer.isPlaying { return }
        musicPlayer.play()
    }

    /// Pauses the music (without rewinding back to the beginning of the song).
    @objc func pauseMusic() {
        musicPlayer.stop()
    }

    /// Stops the music (and rewinds back to the beginning of the song).
    @objc func stopMusic() {
        musicPlayer.stop()
        musicPlayer.currentTime = 0;
    }
}
