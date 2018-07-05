//
//  SSRoundedUIView.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 27/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SSRoundedUIView : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
        updateBorderColour()
        updateBorderWidth()
    }
    
    @IBInspectable
    var rounded_radius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable
    var border_width: CGFloat = 0 {
        didSet {
            updateBorderWidth()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded_radius
    }
    
    func updateBorderColour() {
        layer.borderColor = UIColor.gray.cgColor
    }

    func updateBorderWidth() {
        layer.borderWidth = border_width
    }
}
