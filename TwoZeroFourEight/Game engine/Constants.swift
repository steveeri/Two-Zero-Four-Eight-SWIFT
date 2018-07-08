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
    
    // STD message strings EN
    static let NO_MORE_MOVES = "Sorry. No more moves possible. Try Undo?"
    static let NO_MORE_UNDO = "Sorry. No undo's available. Undo's are limited to 5!"
    static let NEW_HIGH_SCORE = "Oh YES. New PB reached."
    static let WINNER = "AWESOME!, you have won the game. Keep playing!!!"

    // Game specific values
    static let WIN_TARGET = 2048
    static let EMPTY_TILE_VAL = 0
    static let MAX_PREVIOUS_MOVES = 5
    static let PB_MESG_THRESHOLD = 100

    // Board specifics
    static let DIMENSION = 4
    static let TILE_CNT = 16
    static let TILE_WIDTH = 65.5
    static let TILE_PADDING = 8.0
    static let BOARD_CORNER_RADIUS = 2.0
    static let TILE_CORNER_RADIUS = 5
    
    // Animation duration in seconds
    static let ZERO_DURATION   : TimeInterval  = 0.00
    static let QUICK_DURATION  : TimeInterval  = 0.09
    static let NORMAL_DURATION : TimeInterval  = 0.25
    static let SLOW_DURATION   : TimeInterval  = 0.45
    static let LONG_DURATION   : TimeInterval  = 0.60
    static let PAUSE_DURATION   : TimeInterval = 1.00

    // Fonts for various occasions
    static let SMALL_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 38)
    static let MEDIUM_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 36)
    static let LARGE_NUMBER_FONTS = UIFont(name: "HelveticaNeue-Bold", size: 28)
    
    // Random tile selection ratio
    static let RANDOM_RATIO = 0.7  // favours '2's over '4's by  ~4:1
    
    // Audio files
    static let HORRAY_AUDIO_FN = "cheer.mp3"        // A MP# FILE
    static let SAD_AUDIO_FN = "negative-beeps.wav"  // A WAV FILE
    static let MP3_AUDIO = "mp3"                    // A WAV FILE
    static let WAV_AUDIO = "wav"                    // A WAV FILE
    static let AUDIO_SUBDIRECTORY = "sound.assets/"

    // Images
    static let SOUND_ON_IMG = #imageLiteral(resourceName: "sound_on")
    static let SOUND_OFF_IMG = #imageLiteral(resourceName: "sound_off")

    // All the tile colours
    static let GAME_BOARD_COLOUR = UIColor(red: 187.0/255, green: 173.0/255, blue: 160.0/255, alpha: 1)
    static let TILE_BG_COLOUR    = UIColor(red: 204.0/255, green: 192.0/255, blue: 179.0/255, alpha: 1)
    static let TILE2_COLOUR      = UIColor(red: 238.0/255, green: 228.0/255, blue: 244.0/255, alpha: 1)
    static let TILE4_COLOUR      =  UIColor(red: 237.0/255, green: 224.0/255, blue: 200.0/255, alpha: 1)
    static let TILE8_COLOUR      =  UIColor(red: 245.0/255, green: 149.0/255, blue: 99.0/255, alpha: 1)
    static let TILE16_COLOUR     =  UIColor(red: 245.0/255, green: 130.0/255, blue: 97.0/255, alpha: 1)
    static let TILE32_COLOUR     =  UIColor(red: 246.0/255, green: 124.0/255, blue: 95.0/255, alpha: 1)
    static let TILE64_COLOUR     =  UIColor(red: 246.0/255, green: 94.0/255, blue: 59.0/255, alpha: 1)
    static let TILE128_COLOUR    =  UIColor(red: 237.0/255, green: 207.0/255, blue: 114.0/255, alpha: 1)
    static let TILE256_COLOUR    =  UIColor(red: 237.0/255, green: 207.0/255, blue: 114.0/255, alpha: 1)
    static let TILE512_COLOUR    =  UIColor(red: 237.0/255, green: 200.0/255, blue: 80.0/255, alpha: 1)
    static let TILE1024_COLOUR   =  UIColor(red: 237.0/255, green: 197.0/255, blue: 63.0/255, alpha: 1)
    static let TILE2048_COLOUR   =  UIColor(red: 237.0/255, green: 194.0/255, blue: 46.0/255, alpha: 1)
    static let DEFAULT_COLOUR    = UIColor.darkGray
}
