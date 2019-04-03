//
//  BitMask.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/2/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

struct BitMask {
    static let playerBody: UInt32 = 0x1
    static let upperBoundary: UInt32 = 0x1 << 1
    static let lowerBoundary: UInt32 = 0x1 << 2
}
