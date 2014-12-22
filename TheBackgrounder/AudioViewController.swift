//
//  AudioViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
  
  @IBOutlet weak var songLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  var player: AVQueuePlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var error: NSError?
    let session = AVAudioSession.sharedInstance()
    
    var success = session.setCategory(AVAudioSessionCategoryPlayback, error: &error)
    
    if !success {
      fatalError("Error: \(error)")
    }
    
    session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
    
    if !success {
      fatalError("Error: \(error?.localizedDescription)")
    }
    
    let songNames = ["FeelinGood","IronBacon","WhatYouWant"]
    let songURLs = songNames.map { NSBundle.mainBundle().URLForResource($0, withExtension: "mp3") }
    let songs = songURLs.map { AVPlayerItem(URL: $0) }
    
    player = AVQueuePlayer(items: songs)
    player.actionAtItemEnd = .Advance
    player.addObserver(self, forKeyPath: "currentItem", options: .New | .Initial , context: nil)
    
    player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue()) {
      [unowned self] time in
      let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
      if UIApplication.sharedApplication().applicationState == .Active {
        self.timeLabel.text = timeString
      }
      else {
        println("Background: \(timeString)")
      }
    }
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if keyPath == "currentItem" {
      if let player = object as? AVPlayer {
        if let currentItem = player.currentItem?.asset as? AVURLAsset {
          songLabel.text = currentItem.URL?.lastPathComponent? ?? "Unknown"
        }
      }
    }
  }
  
  @IBAction func playPauseAction(sender: UIButton) {
    sender.selected = !sender.selected
    if sender.selected {
      player.play()
    } else {
      player.pause()
    }
  }
}

