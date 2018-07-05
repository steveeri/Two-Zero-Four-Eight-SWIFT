//
//  CreateTileImage.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 4/7/18.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit


class CreateTileImage {
    
    static func buildTileImg(_ bgColour: UIColor, _ text: String = "", _ cornerRadius: CGFloat = 0,
                             _ fontName: String = "HelveticaNeue-Bold",
                             _ imgSize: CGSize = CGSize(width:68,height:68), _ textSize: CGFloat = 45,
                             _ textCol : UIColor = UIColor(red:99,green:91,blue:82,alpha:1)) -> UIImage {
        
        
        let tc = UIColor.black
        let imgArea = CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height)
        let renderer = UIGraphicsImageRenderer(size: imgSize)
        
        let img = renderer.image { ctx in

            // Create tile. Rounded if set.
            let bgRect = UIBezierPath(roundedRect: imgArea, cornerRadius: cornerRadius)
            bgColour.setFill()
            bgRect.fill()

            // Align text to centre.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
        
            // Define text attributes and wite text
            let attrs = [NSAttributedStringKey.font: UIFont(name: fontName, size: textSize)!,
                         NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.foregroundColor: tc]
            text.draw(with: imgArea, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
        }
        print(img)
        return img // return constructed img.
    }
}
