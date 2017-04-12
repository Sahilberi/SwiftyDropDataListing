//
//  ViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit
import SwiftyDropbox


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshDropboxList), name: "Dropboxlistrefresh", object: nil)

  }
  
  
  
  func refreshDropboxList() {

    self.performSegueWithIdentifier("DropboxListingViewController", sender: nil)
  }
 
  @IBAction func linkToDropboxClicked(sender: AnyObject) {
  
    if (Dropbox.authorizedClient == nil) {
      Dropbox.authorizeFromController(self)
    } else {
      print("User is already authorized!")
      self.refreshDropboxList()
    }
  }

}

