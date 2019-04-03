//
//  StageNode.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/2/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

/// This describes only essential stage data for a scene.
protocol Stage {
    var stageName: String { get }
    var node: SKNode { get }
}

enum StageType {
    case mountains

    /// The name to be used to describe this specific stage
    /// in the event that a stage selection option becomes available.
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
}

/// This is what visualizes the scene's stage, and the upper and lower
/// bondaries which the user can interact with.
class StageNode: SKNode {

    private let stageType: StageType

    /// This is the image which illustrates the upper and lower boundaries.
    private var stageImage: SKSpriteNode

    // The upper and lower boundaries for physics interactions.
    private var upperBoundaryNode = SKNode()
    private var lowerBoundaryNode = SKNode()

    init(withStageType type: StageType) {
        stageType = type
        stageImage = SKSpriteNode(imageNamed: type.imageName)
        super.init()
        setUpBoundaries()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpBoundaries() {
        upperBoundaryNode.physicsBody?.categoryBitMask = BitMask.upperBoundary
        lowerBoundaryNode.physicsBody?.categoryBitMask = BitMask.lowerBoundary
    }
}

extension StageNode: Stage {

    var stageName: String {
        return stageType.name
    }

    var node: SKNode {
        return self
    }
}
