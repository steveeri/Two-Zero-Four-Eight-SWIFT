//
//  ToastHelper.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 2/7/18.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit

class ToastHelper {
    
    class private func showAlert(backgroundColor: UIColor, textColor: UIColor, message: String) {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor =  backgroundColor // set bg colour
        label.textColor = textColor //set text colour
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 80, width: appDelegate.window!.frame.size.width, height: 44)
        
        label.alpha = 1
        
        appDelegate.window!.addSubview(label)
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        let animations1 = { () -> Void in label.frame = basketTopFrame }
        let animations2 = { () -> Void in label.alpha = 0 }
        let completion1 = { (value: Bool) in label.removeFromSuperview() }

        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.1,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: animations1,
            completion:
                { (value: Bool) in UIView.animate(
                    withDuration: 2.0,
                    delay: 2.0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.1,
                    options: UIViewAnimationOptions.curveEaseIn,
                    animations: animations2,
                    completion: completion1)}
            )
    }
    
    class func showMessage(_ bgCol: UIColor = UIColor.green, _ txtCol: UIColor = UIColor.white, _ message: String) {
        showAlert(backgroundColor: bgCol, textColor: txtCol, message: message)
    }

    class func showPositiveMessage(message: String) {
        showAlert(backgroundColor: UIColor.green, textColor: UIColor.black, message: message)
    }
    class func showNegativeMessage(message: String) {
        showAlert(backgroundColor: UIColor.red, textColor: UIColor.white, message: message)
    }
}
