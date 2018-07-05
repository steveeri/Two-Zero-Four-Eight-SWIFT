//
//  GameModel.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation


protocol GameModelProtocol {
    func updateTileValue(position:(Int,Int))
    func userWin()
    func userFail()
    func swapTilePositions(tileA A: (Int, Int), tileB B:(Int, Int))
}

enum MoveDirection {
    case Up
    case Down
    case Left
    case Right
}

class GameModel {
    let dimension:Int
    let threshold:Int
    typealias TileObject = Int
    var gameboard:[[TileObject?]] = Array(repeating: Array(repeating: nil, count: Constants.DIMENSION), count: Constants.DIMENSION)
    let delegate:GameModelProtocol
    
    init(dimension: Int, threshold: Int, delegate: GameModelProtocol) {
        self.dimension = dimension
        self.threshold = threshold
        self.delegate = delegate
    }
    
    
    func moveTiles(floor f:(Int, Int), ceiling c: (Int, Int)) -> Bool {
        
        var moved = false
        
        if f.0 == c.0 {
            var inc = 0
            if f.1 > c.1 { inc = -1 } else { inc = 1 }
            
            var emptyBefore = false
            
            for y in stride(from: f.1, to: c.1+inc, by: inc) {
                if self.gameboard[f.0][y] == nil {
                    emptyBefore = true
                    continue
                }
                if emptyBefore && self.gameboard[f.0][y] != nil {
                    moved = true
                    var yy = y
                    
                    repeat{
                        swapTile(tileA: (f.0,yy-inc), TileB: (f.0, yy))
                        //swapTile1(tileA: (f.0,yy-inc), tileB: (f.0, yy))
                        yy -= inc
                    } while(validPosition(position: (f.0, yy-inc)) && (self.gameboard[f.0][yy-inc]) == nil)
                }
            }
        } else {
            var inc:Int
            if f.0 > c.0 { inc = -1 } else { inc = 1 }
            
            var emptyBefore = false
            let start = f.0
            let end = c.0
            for x in stride(from: start, to: end+inc, by: inc) {
                //print("x = \(x)")
                if self.gameboard[x][f.1] == nil{
                    emptyBefore = true
                    continue
                }
                
                if emptyBefore && self.gameboard[x][f.1] != nil {
                    moved = true
                    var xx = x
                    
                    repeat {
                        swapTile(tileA: (xx-inc,f.1), TileB: (xx, f.1))
                        //swapTile1(tileA: (xx-inc,f.1), tileB: (xx, f.1))
                        xx -= inc
                    } while(validPosition(position: (xx-inc, f.1)) && self.gameboard[xx-inc][f.1] == nil)
                }
            }
        }
        return moved
    }
    
    
    func swapTile(tileA A:(Int, Int), TileB B:(Int, Int)) {
        assert(validPosition(position: A) == true && validPosition(position: B) == true)
        let (Ax,Ay) = A
        let (Bx,By) = B
        let valueA = self.gameboard[Ax][Ay]
        self.gameboard[Ax][Ay] = self.gameboard[Bx][By]
        delegate.updateTileValue(position: (Ax, Ay))
        self.gameboard[Bx][By] = valueA
        delegate.updateTileValue(position: (Bx, By))
    }
    
    
    func swapTile1(tileA A:(Int, Int), tileB B:(Int, Int)) -> Void {
        assert(validPosition(position: A) == true && validPosition(position: B) == true)
        let (Ax,Ay) = A
        let (Bx,By) = B
        let valueA = self.gameboard[Ax][Ay]
        self.gameboard[Ax][Ay] = self.gameboard[Bx][By]
        self.gameboard[Bx][By] = valueA
        delegate.swapTilePositions(tileA: A, tileB: B)
    }
    
    
    func combineTiles(floor f:(Int, Int), ceiling c: (Int, Int), performAction:Bool) -> (Bool,Int) {
        var moved = false
        var  score = 0
        
        if f.0 == c.0 {
            var skiped = false
            var inc = 0
            if f.1 > c.1 { inc = -1 } else { inc = 1 }
            
            for y in stride(from: f.1, to: c.1, by: inc) {
                if skiped == true {
                    skiped = false
                    continue
                }
                if self.gameboard[f.0][y] != nil {
                    if(self.gameboard[f.0][y] == self.gameboard[f.0][y+inc]) {
                        moved = true
                        
                        if performAction {
                            skiped = true
                            //combine the value
                            let value = self.gameboard[f.0][y]!
                            self.gameboard[f.0][y]  = 2*value
                            // USE TO TEST BIG NUMBERS  self.gameboard[f.0][y]  = 1024
                            score += 2*value
                            delegate.updateTileValue(position: (f.0,y))
                            self.gameboard[f.0][y+inc] = nil
                            delegate.updateTileValue(position: (f.0, y+inc))

                        } else { return (moved,score) }
                    }
                }
            }
        } else {
            var inc = 0
            var skiped = false
            if f.0 > c.0 { inc = -1 } else { inc = 1 }
            
            for x in stride(from: f.0, to: c.0, by: inc) {
                if skiped == true {
                    skiped = false
                    continue
                }
                if self.gameboard[x][f.1] != nil {
                    if(self.gameboard[x][f.1] == self.gameboard[x+inc][f.1]) {
                        moved = true
                        
                        if performAction {
                            skiped = true
                            
                            //combine the value
                            let value = self.gameboard[x][f.1]!
                            self.gameboard[x][f.1] = 2*value
                            score += 2*value
                            delegate.updateTileValue(position: (x,f.1))
                            self.gameboard[x+inc][f.1] = nil
                            delegate.updateTileValue(position: (x+inc, f.1))
                        } else {
                           return (moved,score)
                        }
                    }
                }
            }
        }
        
        if moved { _ = moveTiles(floor: f, ceiling: c) }
        return (moved,score)
    }
    
    
    func performSwipe(direction: MoveDirection) -> Int {
        var atLeastOneMove = false
        var score = 0
        
        for i in 0..<self.dimension{
            var floor:(Int, Int)
            var ceiling:(Int, Int)
            switch direction{
            case .Down:  floor = (self.dimension-1, i); ceiling = (0,i)
            case .Left:  floor = (i,0);                 ceiling = (i, self.dimension-1)
            case .Right: floor = (i, self.dimension-1); ceiling = (i, 0)
            case .Up:    floor = (0, i);                ceiling = (self.dimension-1,i)
            }
            //print("in the GameModel::performSwipe, floor:\(floor)")
            //print("in the GameModel::performSwipe, ceiling\(ceiling)")
            
            //1. move all tiles
            atLeastOneMove = moveTiles(floor: floor, ceiling: ceiling) == true || (atLeastOneMove == true)
            //print("atLeastOneMove = \(atLeastOneMove)")
            
            //2. combine if has any
            var atLeastOneMove1 = false
            
            var currentScore = 0
            (atLeastOneMove1,currentScore) = combineTiles(floor:floor, ceiling:ceiling, performAction: true)
            
            score += currentScore
            atLeastOneMove = (atLeastOneMove == true || atLeastOneMove1 == true)
        }
        
        if atLeastOneMove {
            //gengerate a random new tile at a random position
            insertRandomNewTile()
        }
        //insertRandomNewTile()
        return score
    }

    
    func findAllOpenSpaces() -> [(Int, Int)] {
        var open = [(Int, Int)]()
        
        for i in 0..<self.dimension {
            for j in 0..<self.dimension{
                if self.gameboard[i][j] == nil{
                    open.append((i,j))
                }
            }
        }
        return open
    }
    
    
    func determineGameState() -> (String, String?) {
        // TODO comment
        //1.(end, win) 2.(end, lose) 3.(continue, nil)
        
        let spaces = findAllOpenSpaces()
        if spaces.count == 0 {
            // TODO
            var moved = false

            for i in 0..<self.dimension {
                if combineTiles(floor: (i, 0), ceiling: (i, self.dimension-1), performAction: false).0 == true {
                    moved = true
                    break
                }
                
                if combineTiles(floor: (i, self.dimension-1), ceiling: (i, 0), performAction: false).0 == true {
                    moved = true
                    break
                }
                
                if combineTiles(floor: (0, i), ceiling: (self.dimension-1, i), performAction: false).0 == true {
                    moved = true
                    break
                }
                
                if combineTiles(floor: (self.dimension-1, i), ceiling: (0, i), performAction: false).0 == true {
                    moved = true
                    break
                }
            }
            
            if moved == true { return ("continue", nil) } else { return ("end", "lose") }
        }else {
            // TODO
            for i in 0..<self.dimension {
                for j in 0..<self.dimension {
                    if self.gameboard[i][j] != nil && Int(self.gameboard[i][j]!) == self.threshold { return ("end", "win") }
                }
            }
            return ("continue", nil)
        }
    }
    
    
    func insertRandomNewTile() {
        //randomly select 4 or 2
        let separator = Int(100*Constants.RANDOM_RATIO)
        let num = Int(arc4random())%100
        var value:Int
        
        if(num >= separator) { value = 4 } else { value = 2 }
        insertNewTile(value: value)
    }
    
    
    func insertNewTile(value: Int) {
        //find all the open spaces
        let open = findAllOpenSpaces()
        
        if open.count > 0 {
            //pick one randomly
            let size = open.count
            let index = Int(arc4random())%size
            let (x,y) = open[index]
            
            //change the value
            self.gameboard[x][y] = value
            delegate.updateTileValue(position: (x,y))
        }
    }
    
    
    func validPosition(position: (Int, Int)) -> Bool {
        let (x,y) = position
        return x>=0 && x<self.dimension && y>=0 && y<self.dimension
    }
    
    
    func resetBoard() {
        for i in 0..<self.dimension {
            for j in 0..<self.dimension {
                self.gameboard[i][j] = nil
                delegate.updateTileValue(position: (i,j))
            }
        }
    }
    
}
