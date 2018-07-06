//
//  GameViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import AVFoundation
import UIKit


class GameViewController: UIViewController, GameEngineProtocol,TileViewDataSource {

    var gameEngine: GameEngine?
    var displayHighScoreMsg = true
    var audioPlayer = AudioPlayerHelper()  // use default setting.
    var soundOn = true
   
    @IBOutlet weak var soundButton: UIButton!
    
    @IBAction func soundTapped(_ sender: UIButton) {
        if (soundOn) {
            soundOn = false
            soundButton.setBackgroundImage(Constants.SOUND_OFF_IMG, for: .normal)
        } else {
            soundOn = true
            soundButton.setBackgroundImage(Constants.SOUND_ON_IMG, for: .normal)
        }
    }
    
  
    @IBAction func quitTapped(_ sender: SSRoundedButton) {
        // Just check to see if the high score needs to be updates.
        saveHighestScore()
        
        // Suspend game. Leave it to ios to cleanup if not restarted.
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        return
    }
    
    @IBAction func newGameTapped(_ sender: SSRoundedButton) {
        // Just check to see if the high score needs to be updates.
        saveHighestScore()
        setupStartUI()
    }
    
    @IBOutlet weak var highestScoreLabel: SSRoundedLabel! {
        didSet {
            highestScoreLabel.text = "0"
        }
    }
    
    @IBOutlet weak var scoreLabel: SSRoundedLabel!
    
    @IBOutlet weak var gamePanel: GamePanelView! {
        didSet {
            gamePanel.datasource = self
        }
    }
    
    //record current score
    var currentScore = 0 {
        didSet {
            self.scoreLabel.text = "\(self.currentScore)"
            self.scoreLabel.setNeedsDisplay()
            userPB()
        }
    }
    
    var highestScore = 0 {
        didSet{
            //saveHighestScore()
            highestScoreLabel.text = "\(self.highestScore)"
            self.highestScoreLabel.setNeedsDisplay()
        }
    }
    
    let dimension: Int = Constants.DIMENSION
    let threshold: Int = Constants.THRESHHOLD
    
    func valueForTile(sender: GamePanelView, position p: (Int, Int)) -> Int? {
        let(x,y) = p
        return gameEngine?.gameboard[x][y]
    }
    
    
    func saveHighestScore() {
        let previousHighScore = StoredDataUtils.getHSData()
        if self.currentScore > previousHighScore {
            StoredDataUtils.storedHSData(newHS: self.currentScore)
            self.highestScore = self.currentScore
            userPB()
        }
    }

    
    func readHighestScore() -> Int {
        return StoredDataUtils.getHSData()
    }
    
    
    //
    // VIEW DID LOAD
    // Setup game board
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        gameEngine = GameEngine(dimension:Constants.DIMENSION, threshold:Constants.THRESHHOLD, delegate: self)
        setupStartUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Start / Reset game here ->
    // Start / Reset game here ->
    func setupStartUI() {
        
        self.currentScore = 0
        
        // Reset game panel
        self.gameEngine?.resetGamePanel()
        
        //insert two new tile
        self.gameEngine!.insertNewTile(value: 2)
        self.gameEngine!.insertNewTile(value: 2)
        
        //add gestures
        self.addGestures()
        self.highestScore = readHighestScore()
    }
    
    
    // The method is called under a few circumstances.  Swap, Clear, and Merge.
    func updateTileValue(_ transition: Transitions, position: (Int,Int)) {
        self.gamePanel.resetTile(transition, Position: position)
    }
    
    // User has beaten previous highscore value.
    func userPB() {
        // pop up an alert to encourage the player to go on
        if displayHighScoreMsg {
            if currentScore > highestScore && highestScore > 100 {
                displayHighScoreMsg = false
                ToastHelper.showPositiveMessage(message: Constants.NEW_HIGH_SCORE)
                if soundOn { audioPlayer.playSound(filename: Constants.HORRAY_AUDIO_FN) }
            }
        }
    }
    
    func userWin() {
        saveHighestScore()
        // pop up an alert to reminder the user that you have won the game
        ToastHelper.showPositiveMessage(message: Constants.WINNER)
        if soundOn { audioPlayer.playSound(filename: Constants.HORRAY_AUDIO_FN) }
    }

    
    func userFail() {
        saveHighestScore()
        ToastHelper.showNegativeMessage(message: Constants.NO_MORE_MOVES)
        if soundOn { audioPlayer.playSound(filename: Constants.SAD_AUDIO_FN) }
    }
    
    
    func swapTilePositions(tileA A: (Int, Int), tileB B:(Int, Int)) {
        self.gamePanel.swapTilePositions(TileA: A, TileB:B)
    }
    
    
    //add gestures
    //add gestures
    func addGestures() {
        let up = UISwipeGestureRecognizer(target: self, action: #selector(upAction))
        up.numberOfTouchesRequired = 1
        up.direction = .up
        self.view.addGestureRecognizer(up)
        
        let down = UISwipeGestureRecognizer(target: self, action: #selector(downAction))
        self.view.addGestureRecognizer(down)
        down.numberOfTouchesRequired = 1
        down.direction = .down
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftAction))
        self.view.addGestureRecognizer(left)
        left.numberOfTouchesRequired = 1
        left.direction = .left
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightAction))
        self.view.addGestureRecognizer(right)
        right.numberOfTouchesRequired = 1
        right.direction = .right
    }


    // Respond to swipe actions below
    // Respond to swipe actions below
    
    @objc func upAction() {

        let score = self.gameEngine?.performSwipe(direction: MoveDirection.Up)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.gameEngine!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func downAction() {
        let score = self.gameEngine?.performSwipe(direction: MoveDirection.Down)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.gameEngine!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func leftAction() {
        let score = self.gameEngine?.performSwipe(direction: MoveDirection.Left)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.gameEngine!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func rightAction() {
        let score = self.gameEngine?.performSwipe(direction: MoveDirection.Right)
        self.currentScore += score!
        var state:(String,String?)
      
        state = self.gameEngine!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
}
