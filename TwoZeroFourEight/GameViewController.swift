//
//  GameViewController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, GameModelProtocol,TileViewDataSource {


    @IBOutlet weak var scoreLabel: SSRoundedLabel!
  
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
    
    @IBOutlet weak var board: GameBoardView! {
        didSet {
            board.datasource = self
        }
    }
    
    var model: GameModel?
    
    //record current score
    var currentScore = 0 {
        didSet {
            self.scoreLabel.text = "\(self.currentScore)"
            self.scoreLabel.setNeedsDisplay()
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
    
    func valueForTile(sender: GameBoardView, position p: (Int, Int)) -> Int? {
        let(x,y) = p
        return model?.gameboard[x][y]
    }
    
    
    func saveHighestScore() {
        let previousHighScore = StoredDataUtils.getHSData()
        if self.currentScore > previousHighScore {
            StoredDataUtils.storedHSData(newHS: self.currentScore)
            self.highestScore = self.currentScore
            if highestScore > 50 {
                ToastHelper.showPositiveMessage(message: Constants.NEW_HIGH_SCORE)
            }
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
        model = GameModel(dimension:Constants.DIMENSION, threshold:Constants.THRESHHOLD, delegate: self)
        setupStartUI()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Start / Reset game here
    // Start / Reset game here
    func setupStartUI() {
        //reset score
        //self.scoreLable?.text = "Score\n0"
        
        self.currentScore = 0
        
        //set up tiles
        //self.board?.resetBoard()
        self.model?.resetBoard()
        
        //insert two new tile
        self.model!.insertNewTile(value: 2)
        self.model!.insertNewTile(value: 2)
        
        //add gestures
        self.addGestures()
        self.highestScore = readHighestScore()
    }
    
    
    //#pragma - mark procotols
    func updateTileValue(position: (Int,Int)) {
        //self.board?.resetTile(value, Position: p)
        self.board.resetTile(Position: position)
    }
    
    
    func userWin() {
        saveHighestScore()
        // pop up an alert to reminder the user that you have won the game
        ToastHelper.showPositiveMessage(message: Constants.WINNER)
    }
    
    
    func userFail() {
        saveHighestScore()
        ToastHelper.showNegativeMessage(message: Constants.NO_MORE_MOVES)
    }
    
    
    func swapTilePositions(tileA A: (Int, Int), tileB B:(Int, Int)) {
        self.board.swapTilePositions(TileA: A, TileB:B)
    }
    
    
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

        let score = self.model?.performSwipe(direction: MoveDirection.Up)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.model!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func downAction() {
        let score = self.model?.performSwipe(direction: MoveDirection.Down)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.model!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func leftAction() {
        let score = self.model?.performSwipe(direction: MoveDirection.Left)
        self.currentScore += score!
        var state:(String,String?)
        
        state = self.model!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
    
    @objc func rightAction() {
        let score = self.model?.performSwipe(direction: MoveDirection.Right)
        self.currentScore += score!
        var state:(String,String?)
      
        state = self.model!.determineGameState()
        if state.0 == "end" && state.1 == "win" {
            self.userWin()
        } else if (state.0 == "end" && state.1 == "lose") {
            self.userFail()
        }
    }
}
