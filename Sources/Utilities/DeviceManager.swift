//
//  DeviceManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/17/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class DeviceManager: NSObject {

    /// Describes whether or not the user is using an iPad device.
    @objc static var isTablet: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
