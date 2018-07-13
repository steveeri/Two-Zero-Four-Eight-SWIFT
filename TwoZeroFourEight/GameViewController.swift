//
//  GameViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import AVFoundation
import UIKit


class GameViewController: UIViewController, GameEngineProtocol, TileViewDataSource,  AVAudioPlayerDelegate {
   
    
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
    
    @IBAction func undoTapped(_ sender: SSRoundedButton) {
        saveHighestScore()
        if (!gameEngine!.goBackOneMove()) {
            ToastHelper.showNegativeMessage(message: Constants.NO_MORE_UNDO)
            if soundOn { audioPlayer.playSound(filename: Constants.SAD_AUDIO_FN) }
        } else {
            self.currentScore = gameEngine!.score
            //print(gameEngine!.toString())
        }
    }
    
    @IBAction func newGameTapped(_ sender: SSRoundedButton) {
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
            highestScoreLabel.text = "\(self.highestScore)"
            self.highestScoreLabel.setNeedsDisplay()
        }
    }
    
    func saveHighestScore() {
        if self.gameEngine!.score > self.gameEngine!.previousHighScore {
            StoredDataUtils.storedHSData(newHS: self.gameEngine!.score)
            self.highestScore = self.gameEngine!.score
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
        gameEngine = GameEngine(delegate: self)
        self.addGestures()
        setupStartUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Start / Reset game here ->
    // Start / Reset game here ->
    func setupStartUI() {
        self.highestScore = readHighestScore()
        self.gamePanel.resetBoard()
        self.gameEngine!.newGame(newHighScore: self.highestScore)
        print(self.gameEngine!.toString())
    }

    // Return the value of tile X
    func valueForTile(sender: GamePanelView, position: Int) -> Int? {
        return (gameEngine!.getTileValue(at: position))
    }
    
    // The method is called under a few circumstances.  Swap, Clear, and Merge.
    func updateTileValue(_ moves: GameEngine.Transition) {
        self.gamePanel.applyTileMove(moves)
    }
    
    // Has user beaten previous highscore value.
    func userPB() {
        if displayHighScoreMsg {
            if ((gameEngine!.score > gameEngine!.previousHighScore) && (gameEngine!.previousHighScore > Constants.PB_MESG_THRESHOLD)) {
                displayHighScoreMsg = false
                // pop up an alert to encourage the player to go on
                ToastHelper.showPositiveMessage(message: Constants.NEW_HIGH_SCORE)
                if soundOn { audioPlayer.playSound(filename: Constants.HORRAY_AUDIO_FN) }
            }
        }
    }
    
    func userWin() {
        saveHighestScore()
        ToastHelper.showPositiveMessage(message: Constants.WINNER)
        if soundOn { audioPlayer.playSound(filename: Constants.HORRAY_AUDIO_FN) }
    }

    func userFail() {
        saveHighestScore()
        ToastHelper.showNegativeMessage(message: Constants.NO_MORE_MOVES)
        if soundOn { audioPlayer.playSound(filename: Constants.SAD_AUDIO_FN) }
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
    @objc func upAction()    { moveAction(dir: GameMoves.Up)    }
    @objc func downAction()  { moveAction(dir: GameMoves.Down)  }
    @objc func leftAction()  { moveAction(dir: GameMoves.Left)  }
    @objc func rightAction() { moveAction(dir: GameMoves.Right) }
    
    var _player : AVAudioPlayer?
    
    // Common handler for registered swipe actions
    func moveAction(dir: GameMoves) {

        if self.gameEngine!.gameOver {
            self.userFail()
            return
        }
        
        if self.gameEngine!.actionMove(move: dir) {
            self.currentScore = gameEngine!.score
            if gameEngine!.acheivedTarget() {
                self.userWin()
            } else {
                userPB()
            }
        } else if self.gameEngine!.gameOver {
            self.userFail()
        }
        //print(gameEngine!.toString())
    }
}
