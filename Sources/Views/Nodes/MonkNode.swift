//
//  MonkNode.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/17/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

class MonkNode: SKNode {

    private static let eyesOpenImageName = DeviceManager.isTablet ? "monkEyesOpeniPad" : "monkEyesOpeniPhone"
    private static let eyesClosedImageName = DeviceManager.isTablet ? "monkEyesClosediPad" : "monkEyesClosediPhone"

    private var image: SKSpriteNode
    private var openEyesAction: SKAction!
    private var closeEyesAction: SKAction!

    override init() {
        image = SKSpriteNode(imageNamed: MonkNode.eyesOpenImageName)
        super.init()
        setUpActions()
        physicsBody = SKPhysicsBody(rectangleOf: image.size)
        addChild(image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpActions() {

        if let openEyesImage = UIImage(named: MonkNode.eyesOpenImageName) {
            let openEyesTexture = SKTexture(image: openEyesImage)
            openEyesAction = SKAction.setTexture(openEyesTexture)
        }

        if let closedEyesImage = UIImage(named: MonkNode.eyesClosedImageName) {
            let closedEyesTexture = SKTexture(image: closedEyesImage)
            closeEyesAction = SKAction.setTexture(closedEyesTexture)
        }
    }

    @objc func openEyes() {
        image.run(openEyesAction)
    }

    @objc func closeEyes() {
        image.run(closeEyesAction)
    }
}
