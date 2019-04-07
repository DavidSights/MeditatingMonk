//
//  PhysicsManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/25/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class PhysicsManager: NSObject {

    /// This provides the player with a consistent first jump
    /// at the beginning of every game.
    @objc static let newGameJump = CGVector(dx: 0, dy: 1000)

    /// A jump value that varies between 3 options for increased difficulty.
    @objc class func jump() -> CGVector {
        return CGVector(dx: 0, dy: randomJumpValue())
    }

    private class func randomJumpValue() -> Int {

        let randomNumber = arc4random()%3

        switch randomNumber {

        case 0:
            return 1000

        case 1:
            return 1150

        case 2:
            return 1250

        default:
            #if DEBUG
            fatalError()
            #endif
            return Int(newGameJump.dy)
        }
    }
}
