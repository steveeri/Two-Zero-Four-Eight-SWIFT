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
    
    // Create initial game object context
    var game : TwoZeroFourEight = TwoZeroFourEight()
    var displayedNewHighScoreMsg = false
    var displayedWonGameMsg = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        setupForNewGamePanel()
    }
    
    @IBAction func newGameButtonTapped(_ sender: SSRoundedButton) {
        //print(sender.currentTitle!)
        setupForNewGamePanel()
    }
    
    // Setup the game panel for the first or new game rounds...
    private func setupForNewGamePanel() {
        // Do any additional setup after loading the view.
        let hs = StoredDataUtils.getHSData()
        
        if (game.score > hs) {
            StoredDataUtils.storedHSData(newHS: hs)
        }
        
        game = TwoZeroFourEight(hs)
        gameArea.text = game.toString()
        score.text = String(game.score)
        highScore.text = String(game.previousHighScore)
    }
    
    @IBAction func creditsButtonTapped(_ sender: SSRoundedButton) {
        //print(sender.currentTitle!)
        guard navigationController?.popViewController(animated: true) != nil else {
            dismiss(animated: true, completion: nil)
            //print("inside pop call")
            return
        }
    }

    private func postMoveChecksAndUpdates() {
        gameArea.text = game.toString()
        score.text = String(game.score)
        highScore.text = String(game.previousHighScore)
        
        if (!displayedWonGameMsg && game.acheivedTarget()) {
            // Display game has been won
            displayedWonGameMsg = true
            Toast.showPositiveMessage(message: game.WINNER)
            return
        }

        if (!displayedNewHighScoreMsg && game.score > game.previousHighScore) {
            // display message for PB score
            displayedNewHighScoreMsg = true
            Toast.showPositiveMessage(message: game.NEW_HIGHSCORE)
            if (game.score > game.previousHighScore) {
                StoredDataUtils.storedHSData(newHS: game.score)
            }
            return
        }
        
        if (!game.hasMovesRemaining()) {
            // display message no more moves
            Toast.showPositiveMessage(message: game.NO_MORE_MOVES)
            if (game.score > game.previousHighScore) {
                StoredDataUtils.storedHSData(newHS: game.score)
            }
            return
        }
    }
    

    /* BELOW:  RESPOND TO GAME MOVE INSTRUCTIONS */
    @IBAction func moveRightTapped(_ sender: SSRoundedButton) {
        _ = game.actionMove(move: .RIGHT)
        postMoveChecksAndUpdates()
    }
    
    @IBAction func moveLeftTapped(_ sender: SSRoundedButton) {
        _ = game.actionMove(move: .LEFT)
        postMoveChecksAndUpdates()
    }
    
    @IBAction func moveUpTapped(_ sender: SSRoundedButton) {
        _ = game.actionMove(move: .UP)
        postMoveChecksAndUpdates()
    }
    
    @IBAction func moveDownTapped(_ sender: SSRoundedButton) {
        _ = game.actionMove(move: .DOWN)
        postMoveChecksAndUpdates()
    }
}
