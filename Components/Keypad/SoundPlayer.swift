//
//  SoundPlayer.swift
//  KeypadSample
//
//  Created by Steve Tibbett on 2019-10-12.
//  Copyright © 2019 Steve Tibbett. All rights reserved.
//

import Foundation
import AVFoundation

// A simple singleton wrapper for AVAudioPlayer
// that owns the AVAudioPlayer instance so sounds
// keep playing when the view that started it
// is removed.
class SoundPlayer {
    static var shared = SoundPlayer()
    var player: AVAudioPlayer?
    
    #if os(macOS)
    func play(_ soundName: String) -> Void {
        guard let url = Bundle.main.url(forResource: "Sound Files/" + soundName, withExtension: ".mp3") else {
            fatalError()
        }
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.prepareToPlay()
            self.player?.play()
        } catch let error {
            NSLog("Error playing sound: \(error)")
        }
    }
    #endif
    
    #if os(iOS)
    func play(_ soundName: String) {
        do {
            if let player = player {
                // Stop and get rid of the previos one
                player.stop()
                self.player = nil
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setMode(.default)
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: [])
            
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") ??
                Bundle.main.url(forResource: soundName, withExtension: "aif") else {
                    NSLog("Can't find sound named \(soundName)")
                    return
            }
            
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.play()
        } catch {
            NSLog("Error playing sound: \(error)")
        }
    }
    #endif
    
}

