//
//  GameEngine.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation


// Required protocol of delegate using this game engine
protocol GameEngineProtocol {
    func updateTileValue(_ moves: GameEngine.Transition)
    func userPB()
    func userWin()
    func userFail()
}


// Allawable game moves
enum GameMoves {
    case Up
    case Down
    case Left
    case Right
}

// Allowable tile movement sequences
enum TileMoveType {
    case Add
    case Slide
    case Merge
    case Clear
    case Reset
}


// The core of the 2048 game logic
// Game board moves are tracked via the compilation of transitions involved in a tile movement.
// The game engine uses constants values found in the Constants.swift class
public class GameEngine {
    
    var gameOver = false
    var score = 0, previousHighScore = 0
    private var numEmpty = Constants.TILE_CNT
    private var maxTile = Constants.EMPTY_TILE_VAL

    private var previousMoves = [GameBoardRecord]()
    private var transitions = [Transition]()
    private var tiles = [Int]()
    
    private let gridCount = Constants.TILE_CNT
    private let rowCnt = Constants.DIMENSION
    private let colCnt = Constants.DIMENSION
    private let blankTile = Constants.EMPTY_TILE_VAL

    // callback delegate to control rendering of the game
    let delegate: GameEngineProtocol
    
    
    // Constructor
    init(delegate: GameEngineProtocol) {
        self.delegate = delegate
    }
    
    
    // Reset the playing board, and generate rendering transition records
    func newGame(newHighScore: Int) {
        self.previousHighScore = newHighScore
        self.numEmpty = Constants.TILE_CNT
        self.maxTile = Constants.EMPTY_TILE_VAL
        self.gameOver = false
        self.score = 0
        
        self.previousMoves = [GameBoardRecord]()
        self.transitions = [Transition]()
        self.tiles = [Int]()
        
        for i in 0..<gridCount {
            tiles.insert(Constants.EMPTY_TILE_VAL, at: 0)
            self.transitions.append(Transition(action: TileMoveType.Reset, value: Constants.EMPTY_TILE_VAL, location: i))
        }
        _ = self.addNewTile(2)
        _ = self.addNewTile(2)
        
        self.previousMoves.insert(getGameBoardRecord(), at: 0)
    }
    
    // RePlot the game board to an earlier time.
    func replotBoard() {
        transitions = [Transition]()
        for i in 0..<gridCount {
            self.transitions.append(Transition(action: TileMoveType.Reset, value: tiles[i], location: i))
        }
        self.applyGameMoves()
    }
    
    // Create and return a current game board status record object
    private func getGameBoardRecord() -> GameBoardRecord {
        return GameBoardRecord(tiles: tiles, score: score, numEmpty: numEmpty, gameOver: gameOver, maxTile: maxTile)
    }
    
    public func acheivedTarget() -> Bool {
        return maxTile >= Constants.WIN_TARGET
    }
    
    public func getTileValue(at: Int) -> Int {
        if at >= 0 && at < gridCount {
            return tiles[at]
        }
        return 0
    }
    
    internal func addNewTile(_ seedValue: Int = -1) -> Bool {
        if (numEmpty == 0) { return false }
        
        var value : Int = 2
        
        if (seedValue < 2 || seedValue > 4) {
            // Randomly select 4 or 2
            let ratioSplit = Int(100 * Constants.RANDOM_RATIO)
            let sample = Int(arc4random()) % 100
            if(sample >= ratioSplit) { value = 4 } else { value = 2 }
        } else {
            value = seedValue
        }
        
        let pos = Int(arc4random_uniform(UInt32(numEmpty)))
        var blanksFound = 0
        
        for i in 0..<gridCount {
            if (tiles[i] == blankTile) {
                if (blanksFound == pos) {
                    tiles[i] = value
                    if (value > maxTile) { maxTile = value }
                    numEmpty -= 1
                    transitions.append(Transition(action: TileMoveType.Add, value: value, location: i))
                    return true
                }
                blanksFound += 1
            }
        }
        return false
    }
    
    func hasMovesRemaining() -> Bool {
        
        if (numEmpty > 0) { return true }
        
        // check left-right for compact moves remaining.
        var arrLimit = gridCount - colCnt
        for i in 0..<arrLimit {
            if (tiles[i] == tiles[i + colCnt]) { return true }
        }
        
        // check up-down for compact moves remaining.
        arrLimit = gridCount - 1
        for i in 0..<arrLimit {
            if ((i + 1) % rowCnt > 0) {
                if (tiles[i] == tiles[i + 1]) { return true }
            }
        }
        return false
    }
    
    // TODO not sliding X X 0 0 sequence
    private func slideTileRowOrColumn(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int) -> Bool {
        
        var moved = false
        let tmpArr : [Int] = [index1,index2,index3,index4]
        
        // Do we have some sliding to do, or not?
        var es = 0  // empty spot index
        for j in 0..<tmpArr.count {
            if (tiles[tmpArr[es]] != blankTile) {
                es += 1
                continue
            } else if (tiles[tmpArr[j]] == blankTile) {
                continue
            } else {
                // Otherwise we have a slide condition
                tiles[tmpArr[es]] = tiles[tmpArr[j]]
                tiles[tmpArr[j]] = blankTile
                transitions.append(Transition(action: TileMoveType.Slide, value: tiles[tmpArr[es]], location: tmpArr[es], oldLocation: tmpArr[j]))
                moved = true
                es += 1
            }
        }
        return moved
    }
    
    private func slideLeft() -> Bool {
        let a = slideTileRowOrColumn(0, 4, 8, 12)
        let b = slideTileRowOrColumn(1, 5, 9, 13)
        let c = slideTileRowOrColumn(2, 6, 10, 14)
        let d = slideTileRowOrColumn(3, 7, 11, 15)
        return (a || b || c || d)
    }
    
    private func slideRight() -> Bool {
        let a = slideTileRowOrColumn(12, 8, 4, 0)
        let b = slideTileRowOrColumn(13, 9, 5, 1)
        let c = slideTileRowOrColumn(14, 10, 6, 2)
        let d = slideTileRowOrColumn(15, 11, 7, 3)
        return (a || b || c || d)
    }
    
    private func slideUp() -> Bool {
        let a = slideTileRowOrColumn(0, 1, 2, 3)
        let b = slideTileRowOrColumn(4, 5, 6, 7)
        let c = slideTileRowOrColumn(8, 9, 10, 11)
        let d = slideTileRowOrColumn(12, 13, 14, 15)
        return (a || b || c || d)
    }
    
    private func slideDown() -> Bool {
        let a = slideTileRowOrColumn(3, 2, 1, 0)
        let b = slideTileRowOrColumn(7, 6, 5, 4)
        let c = slideTileRowOrColumn(11, 10, 9, 8)
        let d = slideTileRowOrColumn(15, 14, 13, 12)
        return (a || b || c || d)
    }
    
    private func compactTileRowOrColumn(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int) -> Bool {
        
        var compacted = false
        
        for j in 1..<colCnt {
            var val1 = blankTile
            var val2 = blankTile
            var tmpI = blankTile
            var tmpJ = blankTile
            switch (j) {
            case 1:
                val1 = tiles[index1]
                val2 = tiles[index2]
                tmpI = index1
                tmpJ = index2
            case 2:
                val1 = tiles[index2]
                val2 = tiles[index3]
                tmpI = index2
                tmpJ = index3
            case 3:
                val1 = tiles[index3]
                val2 = tiles[index4]
                tmpI = index3
                tmpJ = index4
            default :
                break
            }
            
            if (val1 != blankTile && val1 == val2) {
                tiles[tmpI] = val1 * 2
                score += tiles[tmpI]
                if (tiles[tmpI] > maxTile) {
                    maxTile = tiles[tmpI]
                }
                numEmpty += 1
                tiles[tmpJ] = blankTile
                compacted = true
                transitions.append(Transition(action: TileMoveType.Merge, value: tiles[tmpI], location: tmpI, oldLocation: tmpJ))
            }
        }
        return compacted
    }
    
    private func compactLeft() -> Bool {
        let a = compactTileRowOrColumn(0, 4, 8, 12)
        let b = compactTileRowOrColumn(1, 5, 9, 13)
        let c = compactTileRowOrColumn(2, 6, 10, 14)
        let d = compactTileRowOrColumn(3, 7, 11, 15)
        return (a || b || c || d)
    }
    
    private func compactRight() -> Bool {
        let a = compactTileRowOrColumn(12, 8, 4, 0)
        let b = compactTileRowOrColumn(13, 9, 5, 1)
        let c = compactTileRowOrColumn(14, 10, 6, 2)
        let d = compactTileRowOrColumn(15, 11, 7, 3)
        return (a || b || c || d)
    }
    
    private func compactUp() -> Bool {
        let a = compactTileRowOrColumn(0, 1, 2, 3)
        let b = compactTileRowOrColumn(4, 5, 6, 7)
        let c = compactTileRowOrColumn(8, 9, 10, 11)
        let d = compactTileRowOrColumn(12, 13, 14, 15)
        return (a || b || c || d)
    }
    
    private func compactDown() -> Bool {
        let a = compactTileRowOrColumn(3, 2, 1, 0)
        let b = compactTileRowOrColumn(7, 6, 5, 4)
        let c = compactTileRowOrColumn(11, 10, 9, 8)
        let d = compactTileRowOrColumn(15, 14, 13, 12)
        return (a || b || c || d)
    }
    
    private func actionMoveLeft() -> Bool {
        let a = slideLeft()
        let b = compactLeft()
        let c = slideLeft()
        return (a || b || c)
    }
    
    private func actionMoveRight() -> Bool {
        let a = slideRight()
        let b = compactRight()
        let c = slideRight()
        return (a || b || c)
    }
    
    private func actionMoveUp() -> Bool {
        let a = slideUp()
        let b = compactUp()
        let c = slideUp()
        return (a || b || c)
    }
    
    private func actionMoveDown() -> Bool {
        let a = slideDown()
        let b = compactDown()
        let c = slideDown()
        return (a || b || c)
    }
    
    // THIS FUNCTION IS THE MAIN CONTROLLER FOR GAME MOVES
    // THIS FUNCTION IS THE MAIN CONTROLLER FOR GAME MOVES
    func actionMove(move : GameMoves) -> Bool {

        // Clean the transition record as we are doing a new move action.
        transitions = [Transition]()
        
        if (!hasMovesRemaining()) {
            gameOver = true
            return false
        }
        
        var changed = false
        
        switch move {
        case .Up:
            changed = actionMoveUp()
        case .Down:
            changed = actionMoveDown()
        case .Left:
            changed = actionMoveLeft()
        case .Right:
            changed = actionMoveRight()
        }
        
        // If board has changed then add new tile and store previous changes game board
        if (changed) {
            changed = addNewTile()
            if (changed) {
                self.previousMoves.insert(getGameBoardRecord(), at: 0)  // index zero is current/last board result
                if (previousMoves.count > Constants.MAX_PREVIOUS_MOVES+1) {
                    self.previousMoves.remove(at: previousMoves.count-1)
                }
            }
            self.applyGameMoves()
        }
        return changed
    }
    
    // Callback to the delegate to render game board changes
    func applyGameMoves() {
        for trans in self.transitions {
            delegate.updateTileValue(trans)
        }
    }
    
    // Regress state and move sequences back to previous
    func goBackOneMove() -> Bool {
        if (self.previousMoves.count > 1) {
            let pm = self.previousMoves[1]
            self.tiles = pm.tiles
            self.score = pm.score
            self.numEmpty = pm.numEmpty
            self.gameOver = pm.gameOver
            self.maxTile = pm.maxTile
            self.previousMoves.remove(at: 0)
            self.replotBoard() // redraw and create transitions for re-rendering the board.
            return true
        }
        return false
    }
    
    func toString() -> String {
        var str = "---------\n"
        str += "|\(tiles[0])|\(tiles[4])|\(tiles[8])|\(tiles[12])|\n"
        str += "|\(tiles[1])|\(tiles[5])|\(tiles[9])|\(tiles[13])|\n"
        str += "|\(tiles[2])|\(tiles[6])|\(tiles[10])|\(tiles[14])|\n"
        str += "|\(tiles[3])|\(tiles[7])|\(tiles[11])|\(tiles[15])|\n"
        str += "---------"
        return (str)
    }
    
    // Tile movement instructions record for the game board renderer
    class Transition {
        
        var type: TileMoveType
        var value = 0
        var location, oldLocation : Int
        
        init(action: TileMoveType, value: Int, location: Int) {
            type = action
            self.value = value
            self.location = location
            self.oldLocation = -1  // old location not relevant for add and refresh ops
        }
        
        init(action: TileMoveType, value: Int, location: Int, oldLocation: Int = -1) {
            type = action
            self.value = value
            self.location = location
            self.oldLocation = oldLocation
        }
    }
    
    // Snapshot Object containing the status of previous game moves
    class GameBoardRecord : NSObject {
        var tiles : [Int]
        var score : Int
        var numEmpty : Int
        var gameOver : Bool
        var maxTile : Int
        
        init(tiles : [Int], score : Int, numEmpty : Int, gameOver : Bool, maxTile : Int) {
            self.tiles = tiles
            self.score = score
            self.numEmpty = numEmpty
            self.gameOver = gameOver
            self.maxTile = maxTile
        }
    }
}

