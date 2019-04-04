//
//  StageType.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 4/3/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import Foundation

/// This describes only essential stage data for a scene.
@objc protocol StageType {
    var name: String { get }
    var node: SKNode { get }
}
