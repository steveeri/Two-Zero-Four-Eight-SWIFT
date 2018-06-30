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
    
    // Create a game object
    var game : TwoZeroFourEight = TwoZeroFourEight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameArea.text = game.toString()
    }
    
    @IBAction func newGameTapped(sender: SSRoundedButton) {
        //print(sender.currentTitle!)
        game = TwoZeroFourEight()
        gameArea.text = game.toString()
    }
    
    @IBAction func creditsButtonTapped(sender: SSRoundedButton) {
        //print(sender.currentTitle!)
        guard navigationController?.popViewControllerAnimated(true) != nil else { //modal
            dismissViewControllerAnimated(true, completion: nil)
            //print("inside pop call")
            return
        }
    }
    
}
