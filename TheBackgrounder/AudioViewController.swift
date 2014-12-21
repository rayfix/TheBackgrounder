//
//  FirstViewController.swift
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
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if keyPath == "currentItem" {
      if let player = object as? AVPlayer {
        if let currentItem = player.currentItem?.asset as? AVURLAsset {
          songLabel.text = currentItem.URL?.lastPathComponent? ?? "Unknown"
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let songNames = ["FeelinGood","IronBacon","WhatYouWant"]
    let songURLs = songNames.map { NSBundle.mainBundle().URLForResource($0, withExtension: "mp3") }
    let songs = songURLs.map { AVPlayerItem(URL: $0) }
    
    
    player = AVQueuePlayer(items: songs)
    player.actionAtItemEnd = .Advance
    player.addObserver(self, forKeyPath: "currentItem", options: .New | .Initial , context: nil)
    
    player.addPeriodicTimeObserverForInterval(CMTimeMake(10, 1000), queue: dispatch_get_main_queue()) {
      time in
      let timeString = String(format: "%2.2f", CMTimeGetSeconds(time))
      if UIApplication.sharedApplication().applicationState == .Active {
        self.timeLabel.text = timeString
      }
      else {
        println("Background: \(timeString)")
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

