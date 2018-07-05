//
//  AudioPlayerHelper.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 5/7/18.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import AVFoundation


class AudioPlayerHelper : NSObject, AVAudioPlayerDelegate {
    
    private var _player : AVAudioPlayer! = nil
    private var showWarnings : Bool = false
    private var volume : Float = 0.5

    // The default is to play at 50%, and to suppress warnings.
    init(_ volume: Float = 0.5) {
        self.volume = volume
    }

    // The default is to play at 50%, and to suppress warnings.
    init(volume: Float = 0.5, showWarnings : Bool = false) {
        self.volume = volume
        self.showWarnings = showWarnings
    }

    func playSound(filename: String, _ stopOtherPlayback: Bool = true) {
        
        if (stopOtherPlayback) { self.stopSound() }
        
        do {
            let path = Bundle.main.path(forResource: filename, ofType: nil)
            if (path != nil) {
                let url = URL(fileURLWithPath: path!)
                if (showWarnings) { print("URL for sound file is = \(url)") }
                
                _player = try AVAudioPlayer(contentsOf: url) // removed let
                _player.volume = 0.5
                _player.prepareToPlay()
                _player.delegate = self
                _player.play()
            } else {
                if (showWarnings) { print("Audio file was not found in bundle: \(filename)") }
            }
        } catch {
            if (showWarnings) { print("An error occurred while trying to play requested sound file \(filename)") }
        }
    }
    
    func stopSound() {
        // If there is a player object then clear.
        if (_player != nil) {
            _player.stop()
        }
    }
}
