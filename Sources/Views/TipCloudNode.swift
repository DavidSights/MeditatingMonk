//
//  TipCloudNode.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/1/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

class TipCloudNode: SKNode {

    let tipLabel = SKLabelNode()

    override init() {
        super.init()
        let tipCloudImage = SKSpriteNode(imageNamed: DeviceManager.isTablet ? "tipCloudiPad" : "tipCloudiPhone")
        addChild(tipCloudImage)
        // TODO: Update font size for tablet.
        setUpTipLabel(fontSize: DeviceManager.isTablet ? 10 : 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpTipLabel(fontSize: CGFloat) {
        tipLabel.fontSize = fontSize
        tipLabel.fontName = FontManager.appFontName
        tipLabel.position = CGPoint(x: 0, y: -5)
        tipLabel.numberOfLines = 0
        tipLabel.fontColor = Colors.tipLabelColor
        addChild(tipLabel)
        reloadTip()
    }

    @objc func reloadTip() {
        self.tipLabel.text = TipsArray.tip()
    }
}
