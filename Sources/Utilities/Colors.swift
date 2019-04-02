//
//  Colors.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/25/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class Colors: NSObject {

    @objc static var creditsDarkColor: UIColor {
        return rgbColor(r: 134,
                        g: 114,
                        b: 58)
    }

    @objc static var creditsLightColor: UIColor {
        return rgbColor(r: 155,
                        g: 136,
                        b: 72)
    }

    static var tipLabelColor: UIColor {
        return rgbColor(r: 111,
                        g: 158,
                        b: 183)
    }

    private static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r/255,
                       green: g/255,
                       blue: b/255,
                       alpha: a)
    }
}
