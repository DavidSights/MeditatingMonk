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

    private var size: CGSize {
        return UIScreen.main.bounds.size
    }

    // MARK: - Initialization

    // The standard init is hidden and should never be called.
    private override init() {
        stageDescription = .mountains
        super.init()
    }

    init(withDescription description: StageDescription) {
        stageDescription = description
        super.init()
        setUpNodes()
    }

    // MARK: - Convenience Methods

    private func setUpNodes() {

        let center = CGPoint(x: size.width/2, y: size.height/2)

        let middlegroundSpriteNode = SKSpriteNode(imageNamed: stageDescription.middlegroundImageName)
        middlegroundSpriteNode.position = center

        let backgroundSpriteNode = SKSpriteNode(imageNamed: stageDescription.backgroundImageName)
        backgroundSpriteNode.position = center

        let upperBoundaryNode = SKNode()
        upperBoundaryNode.physicsBody = stageDescription.upperBoundaryPhysicsBody

        let lowerBoundaryNode = SKNode()
        lowerBoundaryNode.physicsBody = stageDescription.lowerBoundaryPhysicsBody

        stageNode.addChild(middlegroundSpriteNode)
        stageNode.addChild(backgroundSpriteNode)
        stageNode.addChild(upperBoundaryNode)
        stageNode.addChild(lowerBoundaryNode)
    }

    // TODO: Add stage images, including background
}

// MARK: - Stage Protocol Conformance

extension Stage: StageType {

    var name: String {
        return stageDescription.name
    }

    var node: SKNode {
        return stageNode
    }

    func beginEnvironmentAnimations() {
        // TODO
    }

    func stopAndClearEnvironmentAnimations() {
        // TODO
    }
}
