//
//  GameViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var gameArea: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    @IBAction func newGameButtonTapped(sender: UIButton) {
                print(sender.currentTitle)
    }
    
    
    @IBAction func quitButtonTapped(sender: UIButton) {
        print(sender.currentTitle)
    }
    
}
