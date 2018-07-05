//
//  Constants.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let NO_MORE_MOVES = "Sorry. No more moves possible."
    static let NEW_HIGH_SCORE = "Oh YES. New PB reached."
    static let WINNER = "AWESOME!, you have won the game. Keep playing!!!"
    static let DIMENSION = 4
    static let THRESHHOLD = 2048
    static let TILE_WIDTH = 65.5
    static let TILE_PADDING = 8.0
    static let BOARD_CORNER_RADIUS = 2.0
    static let TILE_CORNER_RADIUS = 5
    static let DURATION : TimeInterval = 0.10
    static let GAME_BOARD_COLOUR = UIColor(red: 187.0/255, green: 173.0/255, blue: 160.0/255, alpha: 1)
    static let TILE_COLOUR = UIColor(red: 204.0/255, green: 192.0/255, blue: 179.0/255, alpha: 1)
    static let SMALL_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 38)
    static let MEDIUM_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 36)
    static let LARGE_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 28)
    static let RANDOM_RATIO = 0.7  //generate "2" is 4 times bigger than "4"
}
