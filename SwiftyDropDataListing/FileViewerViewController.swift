//
//  FileViewerViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2017 SahilBeri. All rights reserved.
//

import UIKit

class FileViewerViewController: UIViewController {
  
  @IBOutlet weak var webView: UIWebView!
  
  var fileUrl: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let url = self.fileUrl {
      
      let requestObj = URLRequest(url: url);
      webView.loadRequest(requestObj);
    }
  }
  
  
}
