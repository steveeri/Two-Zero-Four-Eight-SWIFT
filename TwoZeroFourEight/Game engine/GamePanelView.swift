//
//  GamePanelView.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

protocol TileViewDataSource : class {
    func valueForTile(sender: GamePanelView, position: Int) -> Int?
}

//configure the game board view
class GamePanelView: SSRoundedUIView {
    
    var tileViews : [TileView?] = Array(repeating: nil, count: Constants.TILE_CNT)
    weak var datasource: TileViewDataSource?
    
    // Reset board tiles
    func resetBoard() {
        for tile in tileViews {
            if (tile != nil) {
            tile!.value = Constants.EMPTY_TILE_VAL
            }
        }
        setNeedsDisplay()
    }
    
    // Reflective draw function for UIView
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = Constants.GAME_BOARD_COLOUR
        self.layer.cornerRadius = CGFloat(Constants.BOARD_CORNER_RADIUS)
        self.layer.masksToBounds = true
        
        //set up tiles and apply to view
        for row in 0..<Constants.DIMENSION {
            for column in 0..<Constants.DIMENSION {
                let arrIdx = (row % Constants.DIMENSION) + (column * Constants.DIMENSION)
                let x = Double(column+1) * Constants.TILE_PADDING + Double(column) * Constants.TILE_WIDTH
                let y = Double(row+1) * Constants.TILE_PADDING + Double(row) * Constants.TILE_WIDTH
                let tile = TileView(frame: CGRect(x: x, y: y, width: Constants.TILE_WIDTH, height: Constants.TILE_WIDTH))
                tile.value = datasource?.valueForTile(sender: self, position: arrIdx)
                tileViews[arrIdx] = tile
                self.addSubview(tile)
                //print(tileViews)
            }
        }
    }
    
    // Take receiving movement record and apply to affected TextViews
    func applyTileMove (_ transition: GameEngine.Transition) {
        
        let val = transition.value
        let loc = transition.location
        let oldLoc = transition.oldLocation
        
        switch transition.type {
        case .Add:
            UIView.animate(withDuration: Constants.LONG_DURATION) { self.tileViews[loc]!.value = val }
        case .Merge:
            UIView.animate(withDuration: Constants.QUICK_DURATION) { self.tileViews[oldLoc]!.value = Constants.EMPTY_TILE_VAL }
            UIView.animate(withDuration: Constants.SLOW_DURATION) { self.tileViews[loc]!.value = val }
        case .Clear:
            UIView.animate(withDuration: Constants.QUICK_DURATION) { self.tileViews[loc]!.value = Constants.EMPTY_TILE_VAL }
        case .Slide:
            UIView.animate(withDuration: Constants.QUICK_DURATION) { self.tileViews[oldLoc]!.value = Constants.EMPTY_TILE_VAL }
            UIView.animate(withDuration: Constants.NORMAL_DURATION) { self.tileViews[loc]!.value = val }
        case .Reset:
            self.tileViews[loc]!.value = val
            //UIView.animate(withDuration: Constants.ZERO_DURATION) { self.tileViews[loc].value = val }
        }
    }
}

