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
        var color: UIColor
        
        switch value{
        case 2,4: color = UIColor.black
        default:  color = UIColor.white
        }
        return color
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // draw rect
        self.backgroundColor = Constants.TILE_COLOUR
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(Constants.TILE_CORNER_RADIUS)
        
        numberLabel?.removeFromSuperview()
        numberLabel = nil
        
        let frame = CGRect(x: 0, y: 0, width: Constants.TILE_WIDTH, height: Constants.TILE_WIDTH)
        //numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.tileWidth, height: Constants.tileWidth))
        numberLabel = UILabel()
        UIView.animate(withDuration: Constants.DURATION, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.numberLabel?.frame = frame
            }, completion: nil)
        numberLabel!.textAlignment = .center
        numberLabel!.backgroundColor = Constants.TILE_COLOUR
        numberLabel!.layer.masksToBounds = true
        numberLabel!.minimumScaleFactor = 0.5
        numberLabel!.layer.cornerRadius = self.layer.cornerRadius
        if value == nil {
            numberLabel!.text = ""
            numberLabel!.backgroundColor = Constants.TILE_COLOUR
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
    
    
    func setBackgroundColorForValue(value: Int) -> UIColor {
        var color:UIColor
        switch value {
        case 2: color =  UIColor(red: 238.0/255, green: 228.0/255, blue: 244.0/255, alpha: 1)
        case 4: color =  UIColor(red: 237.0/255, green: 224.0/255, blue: 200.0/255, alpha: 1)
        case 8: color =  UIColor(red: 245.0/255, green: 149.0/255, blue: 99.0/255, alpha: 1)
        case 16: color =  UIColor(red: 245.0/255, green: 130.0/255, blue: 97.0/255, alpha: 1)
        case 32: color =  UIColor(red: 246.0/255, green: 124.0/255, blue: 95.0/255, alpha: 1)
        case 64: color =  UIColor(red: 246.0/255, green: 94.0/255, blue: 59.0/255, alpha: 1)
        case 128: color =  UIColor(red: 237.0/255, green: 207.0/255, blue: 114.0/255, alpha: 1)
        case 256: color =  UIColor(red: 237.0/255, green: 207.0/255, blue: 114.0/255, alpha: 1)
        case 512: color =  UIColor(red: 237.0/255, green: 200.0/255, blue: 80.0/255, alpha: 1)
        case 1024: color =  UIColor(red: 237.0/255, green: 197.0/255, blue: 63.0/255, alpha: 1)
        case 2048: color =  UIColor(red: 237.0/255, green: 194.0/255, blue: 46.0/255, alpha: 1)
        default: color =  UIColor.darkGray
        }
        return color
    }
}
