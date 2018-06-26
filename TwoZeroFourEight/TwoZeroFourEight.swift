﻿import Foundation

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif


public class TwoZeroFourEight {

    var score = 0
    private var numEmpty = 16
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

    init () {
        print("Inside init on TZFE\n")
        self.createNewTransitions()
        self.addNewTile()
        self.addNewTile()
    }

    internal func createNewTransitions() {
        transitions = [Transition]()
    }

    func rePlot() {
        self.createNewTransitions()
        for i in 0..<GRID_CNT {
            self.transitions.append(Transition(action: Actions.REFRESH, value: tiles[i], posFinal: i))
        }
    }

    internal func addNewTile() {
        if (numEmpty == 0) { return }

        //TODO ramdom is crap in swift... have to use old c libraries.  Where is Java :( new Random(2) )
        //print("\(random()) \(random() % 2)\n")
        let value = Int((arc4random_uniform(2) + 1) * 2)
        let pos = Int(arc4random_uniform(UInt32(numEmpty)))
        var blanksFound = 0

        for i in 0..<GRID_CNT {
            if (tiles[i] == BLANK) {
                if (blanksFound == pos) {
                    tiles[i] = value
                    if (value > maxTile) { maxTile = value }
                    numEmpty -= 1
                    transitions.append(Transition(action: Actions.ADD_NEW, value: value, posFinal: i))
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

    private func slideTileRowOrColumn(index1: Int, index2: Int, index3: Int, index4: Int) -> Bool {

        var moved = false
        var val1 = tiles[index1]
        var tmpI = index1

        for j in 0..<COL_CNT {
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
                transitions.append(Transition(action: Actions.SLIDE, value: val2, posStart: tmpJ, posFinal: tmpI))
                transitions.append(Transition(action: Actions.BLANK, value: BLANK, posFinal: tmpJ))
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
        let a = slideTileRowOrColumn(0, index2: 4, index3: 8, index4: 12)
        let b = slideTileRowOrColumn(1, index2: 5, index3: 9, index4: 13)
        let c = slideTileRowOrColumn(2, index2: 6, index3: 10, index4: 14)
        let d = slideTileRowOrColumn(3, index2: 7, index3: 11, index4: 15)
        return (a || b || c || d)
    }

    private func slideRight() -> Bool {
        let a = slideTileRowOrColumn(12, index2: 8, index3: 4, index4: 0)
        let b = slideTileRowOrColumn(13, index2: 9, index3: 5, index4: 1)
        let c = slideTileRowOrColumn(14, index2: 10, index3: 6, index4: 2)
        let d = slideTileRowOrColumn(15, index2: 11, index3: 7, index4: 3)
        return (a || b || c || d)
    }

    private func slideUp() -> Bool {
        let a = slideTileRowOrColumn(0, index2: 1, index3: 2, index4: 3)
        let b = slideTileRowOrColumn(4, index2: 5, index3: 6, index4: 7)
        let c = slideTileRowOrColumn(8, index2: 9, index3: 10, index4: 11)
        let d = slideTileRowOrColumn(12, index2: 13, index3: 14, index4: 15)
        return (a || b || c || d)
    }

    private func slideDown() -> Bool {
        let a = slideTileRowOrColumn(3, index2: 2, index3: 1, index4: 0)
        let b = slideTileRowOrColumn(7, index2: 6, index3: 5, index4: 4)
        let c = slideTileRowOrColumn(11, index2: 10, index3: 9, index4: 8)
        let d = slideTileRowOrColumn(15, index2: 14, index3: 13, index4: 12)
        return (a || b || c || d)
    }

    private func compactTileRowOrColumn(index1: Int, index2: Int, index3: Int, index4: Int) -> Bool {

        var compacted = false

        for j in 0..<COL_CNT {
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
                transitions.append(Transition(action: Actions.COMPACT, value: tiles[tmpI], posStart: tmpJ, posFinal: tmpI))
                transitions.append(Transition(action: Actions.BLANK, value: BLANK, posFinal: tmpJ))
            }
        }
        return compacted
    }

    private func compactLeft() -> Bool {
        let a = compactTileRowOrColumn(0, index2: 4, index3: 8, index4: 12)
        let b = compactTileRowOrColumn(1, index2: 5, index3: 9, index4: 13)
        let c = compactTileRowOrColumn(2, index2: 6, index3: 10, index4: 14)
        let d = compactTileRowOrColumn(3, index2: 7, index3: 11, index4: 15)
        return (a || b || c || d)
    }

    private func compactRight() -> Bool {
        let a = compactTileRowOrColumn(12, index2: 8, index3: 4, index4: 0)
        let b = compactTileRowOrColumn(13, index2: 9, index3: 5, index4: 1)
        let c = compactTileRowOrColumn(14, index2: 10, index3: 6, index4: 2)
        let d = compactTileRowOrColumn(15, index2: 11, index3: 7, index4: 3)
        return (a || b || c || d)
    }

    private func compactUp() -> Bool {
        let a = compactTileRowOrColumn(0, index2: 1, index3: 2, index4: 3)
        let b = compactTileRowOrColumn(4, index2: 5, index3: 6, index4: 7)
        let c = compactTileRowOrColumn(8, index2: 9, index3: 10, index4: 11)
        let d = compactTileRowOrColumn(12, index2: 13, index3: 14, index4: 15)
        return (a || b || c || d)
    }

    private func compactDown() -> Bool {
        let a = compactTileRowOrColumn(3, index2: 2, index3: 1, index4: 0)
        let b = compactTileRowOrColumn(7, index2: 6, index3: 5, index4: 4)
        let c = compactTileRowOrColumn(11, index2: 10, index3: 9, index4: 8)
        let d = compactTileRowOrColumn(15, index2: 14, index3: 13, index4: 12)
        return (a || b || c || d)
    }

    func actionMoveLeft() -> Bool {
        let a = slideLeft()
        let b = compactLeft()
        let c = slideLeft()
        return (a || b || c)
    }

    func actionMoveRight() -> Bool {
        let a = slideRight()
        let b = compactRight()
        let c = slideRight()
        return (a || b || c)
    }

    func actionMoveUp() -> Bool {
        let a = slideUp()
        let b = compactUp()
        let c = slideUp()
        return (a || b || c)
    }

    func actionMoveDown() -> Bool {
        let a = slideDown()
        let b = compactDown()
        let c = slideDown()
        return (a || b || c)
    }

    func toString() -> String {
        var str = "TwoZeroFourEight:class\n--------------------\n"
        str += "|\(tiles[0])|\(tiles[4])|\(tiles[8])|\(tiles[12])|\n"
        str += "|\(tiles[1])|\(tiles[5])|\(tiles[9])|\(tiles[13])|\n"
        str += "|\(tiles[2])|\(tiles[6])|\(tiles[10])|\(tiles[14])|\n"
        str += "|\(tiles[3])|\(tiles[7])|\(tiles[11])|\(tiles[15])|\n"
        str += "--------------------\n"
        return (str)
    }

    
    class Transition {

        var type: Actions
        var value = 0
        private var posStart = -1, posFinal = -1

        init(action: Actions, value: Int, posStart: Int, posFinal: Int) {
            type = action
            self.value = value
            self.posStart = posStart
            self.posFinal = posFinal
        }

        init(action: Actions, value: Int, posFinal: Int) {
            type = action
            self.value = value
            self.posFinal = posFinal
        }
    }
}
