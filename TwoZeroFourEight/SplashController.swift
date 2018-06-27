//
//  ViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

class SplashController: UIViewController {

    
    @IBAction func playGameTapped(sender: SSRoundedButton) {
        print(sender.currentTitle)
    }
    
    
    @IBAction func quitGameTapped(sender: SSRoundedButton) {
        print(sender.currentTitle)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
