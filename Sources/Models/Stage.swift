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

    private var size: CGSize {
        return UIScreen.main.bounds.size
    }

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
        setUpNodes()
        setUpBoundaries()
    }

    // MARK: - Convenience Methods

    private func setUpBoundaries() {

        let upperBoundaryPositionY: CGFloat = 126
        let lowerBoundaryPositionY: CGFloat = (size.height/20)*17

        func boundaryPhysicsBody(_ yPosition: CGFloat, categoryBitMask: UInt32) -> SKPhysicsBody {
            let physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: yPosition), to: CGPoint(x: size.width, y: yPosition))
            physicsBody.isDynamic = false
            physicsBody.categoryBitMask = categoryBitMask
            return physicsBody
        }

        upperBoundaryNode.physicsBody = boundaryPhysicsBody(upperBoundaryPositionY, categoryBitMask: BitMask.upperBoundary.value)
        lowerBoundaryNode.physicsBody = boundaryPhysicsBody(lowerBoundaryPositionY, categoryBitMask: BitMask.lowerBoundary.value)
    }

    private func setUpNodes() {
        let stageSpriteNode = SKSpriteNode(imageNamed: stageDescription.imageName)
        let backgroundSpriteNode = SKSpriteNode(imageNamed: stageDescription.backgroundImageName)
        let size = UIScreen.main.bounds.size
        let center = CGPoint(x: size.width/2, y: size.height/2)
        stageSpriteNode.position = center
        backgroundSpriteNode.position = center
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
