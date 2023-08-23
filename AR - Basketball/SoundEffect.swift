//
//  SoundEffect.swift
//  AR - Basketball
//
//  Created by Kevin Christopher Darmawan on 14/08/23.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playThrowSound() {
    guard let soundEffectURL = Bundle.main.url(forResource: "throwSound", withExtension: "mp3") else {
        return
    }
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundEffectURL)
        audioPlayer?.play()
    } catch {
        print("Error playing sound: \(error.localizedDescription)")
    }
}

func playBackgroundMusic() {
    guard let backgroundMusicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") else {
        return
    }
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    } catch {
        print("Error playing background music: \(error.localizedDescription)")
    }
}

