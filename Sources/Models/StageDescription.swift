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

    // TODO: Add stage music
}
