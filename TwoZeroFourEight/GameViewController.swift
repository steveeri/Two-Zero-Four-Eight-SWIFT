//
//  GameViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var score: SSRoundedLabel!
    @IBOutlet weak var highScore: SSRoundedLabel!
    @IBOutlet weak var gameArea: UITextView!
    
    // Create initial game object context
    var game : TwoZeroFourEight = TwoZeroFourEight()
    var displayNewHighScoreMsg = true
    var displayWonGameMsg = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("viewDidLoad called")
        addSwipeListeners()
        setupForNewGamePanel()
    }
    
    // Setup the game panel for the first or new game rounds...
    private func setupForNewGamePanel() {
        // Do any additional setup after loading the view.
        var hs = StoredDataUtils.getHSData()
        
        if (game.score > hs) {
            StoredDataUtils.storedHSData(newHS: game.score)
            hs = game.score
        }
        
        game = TwoZeroFourEight(hs)
        gameArea.text = game.toString()
        score.text = String(game.score)
        highScore.text = String(game.previousHighScore)

        if (hs < 50) { displayNewHighScoreMsg = false }
    }

    @IBAction func newGameButtonTapped(_ sender: SSRoundedButton) {
        //print(sender.currentTitle!)
        setupForNewGamePanel()
    }

    @IBAction func quitButtonTapped(_ sender: SSRoundedButton) {
        //print(sender.currentTitle!)

        // Just check to see if the high score needs to be updates.
        if (game.score > game.previousHighScore) {
            StoredDataUtils.storedHSData(newHS: game.score)
        }

        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        return
        
//        guard navigationController?.popViewController(animated: true) != nil else {
//            dismiss(animated: true, completion: nil)
//            //print("inside pop call")
//
//            // Just check to see if the high score needs to be updates.
//            if (game.score > game.previousHighScore) {
//                StoredDataUtils.storedHSData(newHS: game.score)
//            }
//            return
//        }
    }

    private func postMoveChecksAndUpdates() {
        
        gameArea.text = game.toString()
        score.text = String(game.score)
        highScore.text = String(game.previousHighScore)
        
        if (displayWonGameMsg && game.acheivedTarget()) {
            // Display game has been won
            displayWonGameMsg = false
            Toast.showPositiveMessage(message: game.WINNER)
            return
        }

        if (displayNewHighScoreMsg && game.score > game.previousHighScore) {
            // display message for PB score
            displayNewHighScoreMsg = false
            Toast.showPositiveMessage(message: game.NEW_HIGHSCORE)
            if (game.score > game.previousHighScore) {
                StoredDataUtils.storedHSData(newHS: game.score)
            }
            return
        }
        
        if (!game.hasMovesRemaining()) {
            // display message no more moves
            Toast.showNegativeMessage(message: game.NO_MORE_MOVES)
            if (game.score > game.previousHighScore) {
                StoredDataUtils.storedHSData(newHS: game.score)
            }
            return
        }
    }
    
    // Affix gesture ALL 4 COMPASS POINT listeners to controller.
    func addSwipeListeners() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    /* BELOW:  RESPOND TO GAME MOVE INSTRUCTIONS */
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                //print("Swiped right")
                _ = game.actionMove(move: .RIGHT)
            case UISwipeGestureRecognizerDirection.down:
                //print("Swiped down")
                _ = game.actionMove(move: .DOWN)
            case UISwipeGestureRecognizerDirection.left:
                //print("Swiped left")
                _ = game.actionMove(move: .LEFT)
            case UISwipeGestureRecognizerDirection.up:
                //print("Swiped up")
                _ = game.actionMove(move: .UP)
            default:
                return
            }
            postMoveChecksAndUpdates()
        }
    }
}
