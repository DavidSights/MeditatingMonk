//
//  PhysicsManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/25/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class PhysicsManager: NSObject {

    @objc static let newGameJump = CGVector(dx: 0, dy: 1150)

    @objc class func standardJump() -> CGVector {
        return CGVector(dx: 0, dy: randomJumpValue())
    }

    private class func randomJumpValue() -> Int {
        let randomNumber = arc4random()%3
        print("Random Jump Value: \(randomNumber)")
        switch randomNumber {
        case 0:
            return 1150
        case 1:
            return 1000
        case 2:
            return 1250
        default:
            fatalError()
        }
    }
}
