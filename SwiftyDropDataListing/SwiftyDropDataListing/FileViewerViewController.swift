//
//  FileViewerViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit

class FileViewerViewController: UIViewController {
  
  @IBOutlet weak var webView: UIWebView!
  
  var fileUrl: NSURL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let url = self.fileUrl {
      
      let requestObj = NSURLRequest(URL: url);
      webView.loadRequest(requestObj);
    }
  }
  
  
}
