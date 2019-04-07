//
//  StageDescription.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/3/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

/// Contains description, and construction in some cases, of the varying pieces of each stage.
enum StageDescription {
    case mountains

    var name: String {
        switch self {
        case .mountains:
            return "Mountains"
        }
    }

    // MARK: - Images

    var middlegroundImageName: String {
        switch self {
        case .mountains:
            return DeviceManager.isTablet ? "grassAndTreeiPad" : "grassAndTreeiPhone"
        }
    }

    var backgroundImageName: String {
        switch self {
        case .mountains:
            return DeviceManager.isTablet ? "backgroundiPad" : "backgroundiPhone"
        }
    }

    // MARK: - Boundaries

    var upperBoundaryPositionY: CGFloat {
        switch self {
        case .mountains:
            return centerBasedPosition(195)
        }
    }

    var lowerBoundaryPositionY: CGFloat {
        switch self {
        case .mountains:
            return centerBasedPosition(-145)
        }
    }

    var upperBoundaryPhysicsBody: SKPhysicsBody {
        switch self {
        case .mountains:
            return boundaryLine(positionY: upperBoundaryPositionY, categoryBitMask: .upperBoundary)
        }
    }

    var lowerBoundaryPhysicsBody: SKPhysicsBody {
        switch self {
        case .mountains:
            return boundaryLine(positionY: lowerBoundaryPositionY, categoryBitMask: .lowerBoundary)
        }
    }

    // MARK: - Music

    // TODO: Add stage music

    // MARK: - Convenience Methods

    /// Creates a physics body, for use as a boundary, that is full width and can varry in height.
    private func boundaryLine(positionY: CGFloat, categoryBitMask: BitMask) -> SKPhysicsBody {
        let size = UIScreen.main.bounds.size
        let physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: positionY), to: CGPoint(x: size.width, y: positionY))
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = categoryBitMask.value
        return physicsBody
    }

    /// This constructs a Y position value based on its distance from
    /// the center of the screen. (Normally, in SpriteKit, the
    /// Y position distance is based on the bottom of the screen.)
    private func centerBasedPosition(_ distance: CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.size.height/2) + distance
    }
}
