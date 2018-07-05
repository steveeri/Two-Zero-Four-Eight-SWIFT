//
//  TwoZeroFourEight.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit

public enum GameMoves : String {
    case UP,DOWN,LEFT,RIGHT
}

public class GameColours {
    static let gameBacking   = UIColor(red: 188, green: 173, blue: 162, alpha: 1)
    static let tile0         = UIColor(red: 204, green: 192, blue: 180, alpha: 1)
    static let tile2         = UIColor(red: 238, green: 228, blue: 218, alpha: 1)
    static let tile4         = UIColor(red: 236, green: 224, blue: 200, alpha: 1)
    static let tile8         = UIColor(red: 242, green: 177, blue: 121, alpha: 1)
    static let tile16        = UIColor(red: 236, green: 141, blue: 83, alpha: 1)
    static let tile32        = UIColor(red: 245, green: 124, blue: 95, alpha: 1)
    static let tile64        = UIColor(red: 233, green: 89, blue: 55, alpha: 1)
    static let tile128       = UIColor(red: 243, green: 217, blue: 107, alpha: 1)
    static let tile256       = UIColor(red: 241, green: 208, blue: 75, alpha: 1)
    static let tile512       = UIColor(red: 228, green: 192, blue: 42, alpha: 1)
    static let tile1024      = UIColor(red: 227, green: 186, blue: 20, alpha: 1)
    static let tile2048      = UIColor(red: 230, green: 170, blue: 10, alpha: 1)
    static let tileTextDark  = UIColor(red: 99, green: 91, blue: 82, alpha: 1)
    static let tileTextLight = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
}


public class TwoZeroFourEight {

    public let NO_MORE_MOVES = "Sorry. No more moves possible."
    public let NEW_HIGHSCORE = "Yes. New PB reached."
    public let WINNER = "Awesome, you have won the game."

    var score = 0, previousHighScore = 0
    private var numEmpty = 16
    var gameOver = false
    var maxTile = 0
    var transitions = [Transition]()

    private var tiles = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    public let TARGET = 2048
    private let GRID_CNT = 16
    private let ROW_CNT = 4
    private let COL_CNT = 4
    private let BLANK = 0

    enum Actions {
        case ADD_NEW
        case BLANK
        case SLIDE
        case COMPACT
        case REFRESH
    }

    init (_ previousHighScore : Int = 0) {
        //print("Inside init on TZFE\n")
        self.createNewTransitions()
        self.addNewTile()
        self.addNewTile()
        self.previousHighScore = previousHighScore
    }

    internal func createNewTransitions() {
        transitions = [Transition]()
    }
    
    func rePlot() {
        self.createNewTransitions()
        for i in 0..<GRID_CNT {
            self.transitions.append(Transition(Actions.REFRESH, tiles[i], i))
        }
    }

    public func acheivedTarget() -> Bool {
        return maxTile >= TARGET
    }
    
    internal func addNewTile() {
        if (numEmpty == 0) { return }

        let value = Int((arc4random_uniform(2) + 1) * 2)
        let pos = Int(arc4random_uniform(UInt32(numEmpty)))
        var blanksFound = 0

        for i in 0..<GRID_CNT {
            if (tiles[i] == BLANK) {
                if (blanksFound == pos) {
                    tiles[i] = value
                    if (value > maxTile) { maxTile = value }
                    numEmpty -= 1
                    transitions.append(Transition(Actions.ADD_NEW, value, i))
                    return
                }
                blanksFound += 1
            }
        }
    }

    func getValue(i: Int) -> Int {
        return tiles[i]
    }

    func hasMovesRemaining() -> Bool {

        if (numEmpty > 0) { return true }

        // check left-right for compact moves remaining.
        var arrLimit = GRID_CNT - COL_CNT
        for i in 0..<arrLimit {
            if (tiles[i] == tiles[i + COL_CNT]) { return true }
        }

        // check up-down for compact moves remaining.
        arrLimit = GRID_CNT - 1
        for i in 0..<arrLimit {
            if ((i + 1) % ROW_CNT > 0) {
                if (tiles[i] == tiles[i + 1]) { return true }
            }
        }
        return false
    }

    private func slideTileRowOrColumn(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int) -> Bool {

        var moved = false
        var val1 = tiles[index1]
        var tmpI = index1

        for j in 1..<COL_CNT {
            var val2 = BLANK
            var tmpJ = BLANK
            switch (j) {
                case 1:
                    val2 = tiles[index2]
                    tmpJ = index2
                case 2:
                    val2 = tiles[index3]
                    tmpJ = index3
                case 3:
                    val2 = tiles[index4]
                    tmpJ = index4
                default :
                    break
            }

            if (val1 == BLANK && val2 != BLANK) {
                tiles[tmpI] = val2
                tiles[tmpJ] = BLANK
                transitions.append(Transition(Actions.SLIDE, val2, tmpJ, tmpI))
                transitions.append(Transition(Actions.BLANK, BLANK, tmpJ))
                val1 = BLANK
                tmpI = tmpJ
                moved = true
            } else if (val1 != BLANK && val2 == BLANK) {
                val1 = BLANK
                tmpI = tmpJ
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

        for j in 1..<COL_CNT {
            var val1 = BLANK
            var val2 = BLANK
            var tmpI = BLANK
            var tmpJ = BLANK
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

            if (val1 != BLANK && val1 == val2) {
                tiles[tmpI] = val1 * 2
                score += tiles[tmpI]
                if (tiles[tmpI] > maxTile) {
                    maxTile = tiles[tmpI]
                }
                numEmpty += 1
                tiles[tmpJ] = BLANK
                compacted = true
                transitions.append(Transition(Actions.COMPACT, tiles[tmpI], tmpJ, tmpI))
                transitions.append(Transition(Actions.BLANK, BLANK, tmpJ))
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

    func actionMove(move : GameMoves) -> Bool {
        
        if (!hasMovesRemaining()) {
            gameOver = true
            return false
        }

        var result = false
        
        switch move {
        case .UP:
            result = actionMoveUp()
        case .DOWN:
            result = actionMoveDown()
        case .LEFT:
            result = actionMoveLeft()
        case .RIGHT:
            result = actionMoveRight()
        }
        
        if (result) { addNewTile() }
        return result
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

    func toString() -> String {
        var str = "---------\n"
        str += "|\(tiles[0])|\(tiles[4])|\(tiles[8])|\(tiles[12])|\n"
        str += "|\(tiles[1])|\(tiles[5])|\(tiles[9])|\(tiles[13])|\n"
        str += "|\(tiles[2])|\(tiles[6])|\(tiles[10])|\(tiles[14])|\n"
        str += "|\(tiles[3])|\(tiles[7])|\(tiles[11])|\(tiles[15])|\n"
        str += "---------"
        return (str)
    }
    
    
    class Transition {

        var type: Actions
        var value = 0
        private var posStart, posFinal : Int

        init(_ action: Actions, _ value: Int, _ posStart: Int, _ posFinal: Int = -1) {
            type = action
            self.value = value
            self.posStart = posStart
            self.posFinal = posFinal
        }
    }
}
