//
//  BitMask.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/2/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

enum BitMask {
    case playerBody
    case upperBoundary
    case lowerBoundary

    var value: UInt32 {
        switch self {
        case .playerBody:
            return 0x1
        case .upperBoundary:
            return 0x1 << 1
        case .lowerBoundary:
            return 0x1 << 2
        }
    }
}

/// A simple and temporary access for Swift BitMask models.
@objc class BitMaskAccessor: NSObject {
    @objc static let playerBoundary = BitMask.playerBody.value
    @objc static let upperBoundary = BitMask.upperBoundary.value
    @objc static let lowerBoundary = BitMask.upperBoundary.value
}
