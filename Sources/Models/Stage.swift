//
//  StageNode.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/2/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

/// Provides a stage node to be added to a scene.
class Stage: NSObject {

    // MARK: Propeties

    private let stageDescription: StageDescription
    private let stageNode = SKNode()

    // The upper and lower boundaries for physics interactions.
    private var upperBoundaryNode = SKNode()
    private var lowerBoundaryNode = SKNode()

    // MARK: - Initialization

    // The standard init is hidden and should never be called.
    private override init() {
        stageDescription = .mountains
        super.init()
    }

    // TODO: Is there a way to overried and hide the SKNode initializers?

    init(withDescription description: StageDescription) {
        self.stageDescription = description
        super.init()
        setUpBoundaries()
    }

    // MARK: - Convenience Methods

    private func setUpBoundaries() {
        upperBoundaryNode.physicsBody?.categoryBitMask = BitMask.upperBoundary
        lowerBoundaryNode.physicsBody?.categoryBitMask = BitMask.lowerBoundary
    }

    // TODO: Add stage images, including background
}

// MARK: - Stage Protocol Conformance

extension Stage: StageType {

    var name: String {
        return stageDescription.name
    }

    var node: SKNode {
        return self.stageNode
    }
}
