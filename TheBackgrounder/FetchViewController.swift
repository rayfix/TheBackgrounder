//
//  FetchViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit

class FetchViewController: UIViewController {
  
  @IBOutlet weak var updateLabel: UILabel?
  
  var updateTime: NSDate?
  
  func fetchNewTime(completion:(Void -> Void)) {
    updateTime = NSDate()
    completion()
  }
  
  func update() {
    if let time = updateTime {
      let formatter = NSDateFormatter()
      formatter.dateStyle = .ShortStyle
      formatter.timeStyle = .LongStyle
      updateLabel?.text = formatter.stringFromDate(time)
    }
    else {
      updateLabel?.text = "Not yet updated"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    update()
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
  }
  
  @IBAction func didTapUpdate(sender: UIButton) {
    fetchNewTime { self.update() }
  }
  
}
