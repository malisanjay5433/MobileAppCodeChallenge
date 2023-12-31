//
//  File.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 31/12/23.
//

import UIKit
@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue
              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}
