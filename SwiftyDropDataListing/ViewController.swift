//
//  ViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit
import SwiftyDropbox


class ViewController: UIViewController, SelectedData {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshDropboxList), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DropboxListingViewController"{
            let dropboxListingViewController = segue.destination  as! DropboxListingViewController
            dropboxListingViewController.delegate = self
            //            dropboxListingViewController.getSelectedData = { pathArr in
            //                print(pathArr)
            //                print( FileManager.default.contents(atPath: pathArr[0]))
            //
            //
            //            }
            dropboxListingViewController.showDropboxData()
            
            
        }
    }
    
    func getDropboxSelectedData(_ dataArr: [String]){
        print(dataArr)
        print( FileManager.default.contents(atPath: dataArr[0]))
    }
    
    func refreshDropboxList() {
        
        self.performSegue(withIdentifier: "DropboxListingViewController", sender: nil)
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

