//
//  SoundEffect.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/31/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation
import SpriteKit

enum SoundEffect {
    case jump
    case button
    case gameOver
    case highScore

    private var fileName: String {
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

    /// An action to be ran by an `SKNode` instance.
    var action: SKAction {
        return SKAction.playSoundFileNamed(fileName, waitForCompletion: true)
    }
}
