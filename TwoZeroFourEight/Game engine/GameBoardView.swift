//
//  TileViewDataSource.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

protocol TileViewDataSource : class {
    func valueForTile(sender:GameBoardView, position p:(Int,Int)) -> Int?
}

//configure the game board view
class GameBoardView : SSRoundedUIView {
    //tiles
    var tiles:Dictionary<NSIndexPath, TileView> = [:]
    weak var datasource:TileViewDataSource?
    
    //reset board
    func resetBoard() {
        for i in 0..<Constants.DIMENSION {
            for j in 0..<Constants.DIMENSION {
                let pos = NSIndexPath(row: j, section: i)
                tiles[pos]?.value = nil
            }
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = Constants.GAME_BOARD_COLOUR
        self.layer.cornerRadius = CGFloat(Constants.BOARD_CORNER_RADIUS)
        self.layer.masksToBounds = true
        
        //set up tiles
        for row in 0..<Constants.DIMENSION {
            for column in 0..<Constants.DIMENSION {
                //create a new tile view
                let x = Double(column+1)*Constants.TILE_PADDING + Double(column)*Constants.TILE_WIDTH
                let y = Double(row + 1)*Constants.TILE_PADDING + Double(row)*Constants.TILE_WIDTH
                let tile = TileView(frame: CGRect(x: x, y: y, width: Constants.TILE_WIDTH, height: Constants.TILE_WIDTH))
                tile.value = datasource?.valueForTile(sender: self, position: (row, column))
                self.addSubview(tile)
                let position = NSIndexPath(row: column, section: row)
                tiles[position] = tile
            }
        }
    }
    
    func swapTilePositions(TileA A: (Int, Int), TileB B:(Int, Int)) {
        let (x1,y1) = A
        let (x2,y2) = B
        assert(x1 == x2 || y1 == y2)
        
        let pos1 = NSIndexPath(row: y1, section: x1)
        let pos2 = NSIndexPath(row: y2, section: x2)
        let tile1 = tiles[pos1]
        let tile2 = tiles[pos2]
        
        UIView.animate(withDuration: Constants.DURATION, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            let f1 = tile1?.frame
            let label1 = tile1?.numberLabel
            let value1 = tile1?.value
            
            tile1?.frame = (tile2?.frame)!
            tile1?.numberLabel = tile2?.numberLabel
            tile1?.value = tile2?.value
            
            tile2?.frame = f1!
            tile2?.numberLabel = label1
            tile2?.value = value1
            }, completion: nil)
    }
    
    
    func resetTile(Position p:(Int, Int)) {
        let (i,j) = p
        let pos = NSIndexPath(row: j, section: i)

        let tile = self.tiles[pos]

        tile?.value = self.datasource?.valueForTile(sender: self, position: p)
        //animated
//        UIView.animateWithDuration(Constants.duration) { 
//            tile?.value = self.datasource?.valueForTile(self, position: p)
//        }
    }

}
