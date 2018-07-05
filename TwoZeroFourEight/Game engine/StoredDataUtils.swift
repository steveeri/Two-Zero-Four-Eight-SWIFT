//
//  StoredDataUtils.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 2/7/18.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import Foundation

struct gameKeys {
    static let highestScore = "highestScore"
}

class StoredDataUtils {

    // Push highscore data to user defaults
    static func storedHSData(newHS : Int) {
        let defaults = UserDefaults.standard
        defaults.set(newHS, forKey: gameKeys.highestScore)
        defaults.synchronize()
    }
    
    // Get highscore data from user defaults
    static func getHSData() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: gameKeys.highestScore)
    }
}
