//
//  StageDescription.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/3/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

/// This describes each specific stage and its resources.
enum StageDescription {
    case mountains

    var name: String {
        switch self {
        case .mountains:
            return "Mountains"
        }
    }

    var imageName: String {
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

    var upperBoundaryPhysicsBody: SKPhysicsBody {
        switch self {
        case .mountains:
            return boundaryLine(height: 126, categoryBitMask: .upperBoundary)
        }
    }

    var lowerBoundaryPhysicsBody: SKPhysicsBody {
        switch self {
        case .mountains:
            return boundaryLine(height: -126, categoryBitMask: .lowerBoundary)
        }
    }

    // TODO: Add stage music

    // MARK: - Convenience Methods

    /// Creates a physics body, for use as a boundary, that is full width and can varry in height.
    private func boundaryLine(height: CGFloat, categoryBitMask: BitMask) -> SKPhysicsBody {
        let size = UIScreen.main.bounds.size
        let yPosition = centerBasedPosition(height)
        let physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: yPosition), to: CGPoint(x: size.width, y: yPosition))
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
