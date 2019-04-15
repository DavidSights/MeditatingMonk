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

    init(_ description: StageDescription) {
        stageDescription = description
        super.init()
        setUpNodes()
    }

    // MARK: - Convenience Methods

    private func setUpNodes() {

        var nodes = [SKNode]()

        let center = CGPoint(x: size.width/2, y: size.height/2)

        // Note: The order that these nodes are appended to the nodes array mattters because
        // it affects their place in the view hierarchy. For example, if the background is appended
        // after the middleground, it will appear on top of the middleground (hiding the middleground completely).

        let backgroundSpriteNode = SKSpriteNode(imageNamed: stageDescription.backgroundImageName)
        backgroundSpriteNode.position = center
        nodes.append(backgroundSpriteNode)

        let middlegroundSpriteNode = SKSpriteNode(imageNamed: stageDescription.middlegroundImageName)
        middlegroundSpriteNode.position = center
        nodes.append(middlegroundSpriteNode)

        let upperBoundaryNode = SKNode()
        upperBoundaryNode.physicsBody = stageDescription.upperBoundaryPhysicsBody
        nodes.append(upperBoundaryNode)

        let lowerBoundaryNode = SKNode()
        lowerBoundaryNode.physicsBody = stageDescription.lowerBoundaryPhysicsBody
        nodes.append(lowerBoundaryNode)

        for node in nodes { stageNode.addChild(node) }
    }

    /// This is a simple way to visualize this stage's boundaries.
    /// Use this when testing new physics interactions or stage design.
    private func visualizeBoundaries() {

        let visualizerSize = CGSize(width: size.width, height: 5)

        let upperBoundaryNodeVisualizer = SKSpriteNode(color: .red, size: visualizerSize)
        upperBoundaryNodeVisualizer.position = CGPoint(x: size.width/2, y: stageDescription.upperBoundaryPositionY)
        stageNode.addChild(upperBoundaryNodeVisualizer)

        let lowerBoundaryNodeVisualizer = SKSpriteNode(color: .red, size: visualizerSize)
        lowerBoundaryNodeVisualizer.position = CGPoint(x: size.width/2, y: stageDescription.lowerBoundaryPositionY)
        stageNode.addChild(lowerBoundaryNodeVisualizer)
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
