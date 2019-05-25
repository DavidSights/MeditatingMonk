//
//  PhysicsManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/25/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class PhysicsManager: NSObject {

    // MARK: - Static Properties

    /// This provides the player with a consistent first jump
    /// at the beginning of every game.
    @objc static let newGameJump = CGVector(dx: 0, dy: DeviceManager.isTablet ? tabletNewJump : mobileBase)

    private static let mobileBase = 1000
    private static let tabletBase = 12000

    // The new jump on tablet is very different from the base jump, and needs its own value.
    private static let tabletNewJump = 7000

    // MARK: - Convenience Methods

    /// A jump value that varies between 3 options for increased difficulty.
    @objc class func jump() -> CGVector {
        return CGVector(dx: 0, dy: randomJumpValue())
    }

    private class func randomJumpValue() -> Int {

        let randomNumber = arc4random() % 3

        switch randomNumber {

        case 0:
            return DeviceManager.isTablet ? tabletBase : mobileBase

        case 1:
            return (DeviceManager.isTablet ? tabletBase : mobileBase) + 50

        case 2:
            return (DeviceManager.isTablet ? tabletBase : mobileBase) + 100

        default:
            #if DEBUG
            fatalError()
            #endif
            return Int(newGameJump.dy)
        }
    }
}
