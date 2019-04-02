//
//  TipCloudNode.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/1/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

class TipCloudNode: SKNode {

    private let label = SKLabelNode()

    override init() {
        super.init()
        let tipCloudImage = SKSpriteNode(imageNamed: DeviceManager.isTablet ? "tipCloudiPad" : "tipCloudiPhone")
        addChild(tipCloudImage)
        setUpLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLabel() {
        // TOOD: Update font size for iPad.
        label.fontSize =  DeviceManager.isTablet ? 10 : 10
        label.fontName = FontManager.appFontName
        label.position = CGPoint(x: 0, y: -5)
        label.numberOfLines = 0
        label.fontColor = Colors.tipLabelColor
        addChild(label)
        reloadTip()
    }

    @objc func reloadTip() {
        self.label.text = TipsArray.tip()
    }
}
