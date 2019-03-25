//
//  ImageManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/25/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import UIKit

class ImageManager: NSObject {

    /// Snaps a screenshot of the provided view.
    /// - parameter view: The view who's image should be captured.
    /// - returns: A screenshot image.
    @objc static func screenshotImage(withView view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let scoreImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scoreImage
    }
}
