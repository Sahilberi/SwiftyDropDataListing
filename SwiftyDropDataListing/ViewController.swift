//
//  ViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2017 SahilBeri. All rights reserved.
//

import UIKit
import SwiftyDropbox


class ViewController: UIViewController, SelectedDropboxData {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshDropboxList), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewController"{
            let tableViewController = segue.destination  as! DBListingViewController
            tableViewController.delegate = self
            tableViewController.showDropboxData()
        }
    }
    
    func getDropboxSelectedData(_ dataArr: [String]){
        print(dataArr)
        print( FileManager.default.contents(atPath: dataArr[0]))
    }
    
    func refreshDropboxList() {
        self.performSegue(withIdentifier: "TableViewController", sender: nil)
    }

  @IBAction func linkToDropboxClicked(_ sender: AnyObject) {
        
        if (DropboxClientsManager.authorizedClient == nil) {
            //authorize a user
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        } else {
            print("User is already authorized!")
            self.refreshDropboxList()
        }
    }
    
}

