//
//  TileView.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    var value: Int? = nil {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var numberLabel: UILabel?
    
    func setColorForValue(value: Int) -> UIColor {
        switch value {
        case 2,4: return UIColor.black
        default:  return UIColor.white
        }
    }
    
    // Reflective render call to paint tile
    override func draw(_ rect: CGRect) {
        
        // draw rect
        self.backgroundColor = Constants.TILE_BG_COLOUR
        self.layer.cornerRadius = CGFloat(Constants.TILE_CORNER_RADIUS)
        self.layer.masksToBounds = true

        numberLabel?.removeFromSuperview()
        numberLabel = nil
        
        let frame = CGRect(x: 0, y: 0, width: Constants.TILE_WIDTH, height: Constants.TILE_WIDTH)
        numberLabel = UILabel()
        UIView.animate(withDuration: Constants.QUICK_DURATION, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.numberLabel?.frame = frame
        }, completion: nil)
        
        numberLabel!.textAlignment = .center
        numberLabel!.backgroundColor = Constants.TILE_BG_COLOUR
        numberLabel!.layer.masksToBounds = true
        numberLabel!.minimumScaleFactor = 0.5
        numberLabel!.layer.cornerRadius = self.layer.cornerRadius
        if value == 0 || value == nil {
            numberLabel!.text = ""
            numberLabel!.backgroundColor = Constants.TILE_BG_COLOUR
        } else {
            // Set font size depending on tile value... so the text will fit on the tile.
            if value! < 128 {
                numberLabel!.font = Constants.SMALL_NUMBER_FONTS
            } else if value! >= 1024 {
                numberLabel!.font = Constants.LARGE_NUMBER_FONTS
            } else {
                numberLabel!.font = Constants.MEDIUM_NUMBER_FONTS
            }
            numberLabel!.text = "\(value!)"
            numberLabel!.backgroundColor = self.setBackgroundColorForValue(value: value!)
            numberLabel!.textColor = self.setColorForValue(value: value!)
        }
        addSubview(numberLabel!)
    }
    
    // Simple method to assign required colour for tile
    func setBackgroundColorForValue(value: Int) -> UIColor {
        switch value {
        case 2:    return Constants.TILE2_COLOUR
        case 4:    return  Constants.TILE4_COLOUR
        case 8:    return Constants.TILE8_COLOUR
        case 16:   return Constants.TILE16_COLOUR
        case 32:   return Constants.TILE32_COLOUR
        case 64:   return Constants.TILE64_COLOUR
        case 128:  return Constants.TILE128_COLOUR
        case 256:  return Constants.TILE256_COLOUR
        case 512:  return Constants.TILE512_COLOUR
        case 1024: return Constants.TILE1024_COLOUR
        case 2048: return Constants.TILE2048_COLOUR
        default:   return Constants.DEFAULT_COLOUR
        }
    }
}

