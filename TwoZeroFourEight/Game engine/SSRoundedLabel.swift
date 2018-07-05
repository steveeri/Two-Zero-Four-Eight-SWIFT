//
//  SSRoundedLabel.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 27/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SSRoundedLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable
    var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
