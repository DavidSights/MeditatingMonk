//
//  DataManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/20/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

@objc class DataManager: NSObject {

    private struct DefaultsKey {
        static let highScore = "monkGameHighScore"
        static let combinedScores = "combinedScores"
        static let totalTaps = "totalTaps"
        static let currentScore = "currentScore"
    }

    /// The user's high score.
    @objc static var highScore: Int {
        get { return UserDefaults.standard.integer(forKey: DefaultsKey.highScore) }
        set { UserDefaults.standard.set(newValue, forKey: DefaultsKey.highScore) }
    }

    /// The last recorded score from a finished game.
    @objc static var currentScore: Int {
        get { return UserDefaults.standard.integer(forKey: DefaultsKey.currentScore) }
        set { UserDefaults.standard.set(newValue, forKey: DefaultsKey.currentScore) }
    }

    /// A sum of all scores achieved by the user.
    @objc static var combinedScores: Int {
        get { return UserDefaults.standard.integer(forKey: DefaultsKey.combinedScores) }
        set { UserDefaults.standard.set(newValue, forKey: DefaultsKey.combinedScores) }
    }

    /// A record of all gameplay taps the user has made.
    @objc static var totalTaps: Int {
        get { return UserDefaults.standard.integer(forKey: DefaultsKey.totalTaps) }
        set { UserDefaults.standard.set(newValue, forKey: DefaultsKey.totalTaps) }
    }

    /// Erases the user's high score.
    @objc class func resetHighScore() {
        highScore = 0
        // TODO: If possible, reset GameCenter's recorded high score as well.
    }
}
