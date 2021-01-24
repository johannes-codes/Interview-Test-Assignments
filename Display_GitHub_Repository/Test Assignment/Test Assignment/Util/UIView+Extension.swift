//
//  UIView+Extension.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import UIKit

extension UIView {

    /// Adds a corner radius to specific view edges
    /// - Parameters:
    ///   - corners: the corners to round
    ///   - radius: the corner radius
    func roundCorners(at corners: CACornerMask, radius: CGFloat) {
        layer.maskedCorners = corners
        layer.cornerRadius = radius
    }
}
