# SwiftyDropDataListing

SwiftyDropDataListing provides a simple and effective way to browse, view, and get files(download) using the SwiftyDropbox. But you need to first integrate SwiftyDropbox. To integrate SwiftyDropbox follow this [SwiftyDropbox](https://github.com/dropbox/SwiftyDropbox).

After successfully integration handle the redirection back into the Swift SDK once the authentication flow is complete, you should add the following code in your application's delegate and  fire a notification. And add Observer to recieve the notification in YourViewController and push to the TableViewController.

#AppDelegate class  

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {  
    
    if let authResult = DropboxClientsManager.handleRedirectURL(url) {
      switch authResult {
      case .success:
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
        
        print("Success! User logged in.")
      case .error( _, let description):
        print("Error: \(description)")
      case .cancel:
        print("cancel")
      }
    }
    
     return false
    }

#YourViewController

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
  
    //MARK: SelectedDropboxData method
    func getDropboxSelectedData(_ dataArr: [String]){
    print(dataArr)
    }
  
    // Handle Notification
    // and segue to TableViewController. TableViewController Must be connected through the storyboard. and it should be push through the navigation controller.
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


# Features
Key Features of SwiftDropDataListing are listed below. It has a great interface for ios 8, 9 ,solid file handling features and file search capability.

# User Interface 

SwiftyDropDataListing has a beautiful and simple interface similar to that of the actual Dropbox App. The interface is built for iOS 8 or greator. You can get all dropbox data with in your app simply by after autenticate in dropbox.

<img src = "https://cloud.githubusercontent.com/assets/7422405/21468458/20db5754-ca37-11e6-8a2b-7200affdffa0.jpg" /> 

# Files

In SwiftyDropDataListing we are currently showing all files. When a user tap on file it get downloaded and it calls a Delegate method getDropboxSelectedData.

 To get selected/ downloaded file path you must implement SelectedDropboxData Delegate method in your class.

     func getDropboxSelectedData(_ dataArr: [String])
     
# File Search

Users can quickly get to the files they need by using the built-in search features. Just scroll to the top and start typing for instant search results. Download files directly from search results.

# Requirements
Requires minimum Xcode 8.0 for use in any iOS Project. Requires a minimum of iOS 8.0 as the deployment target.
Minimum Swift 3.

# Installation
Manually
Simply put DBListingViewController.swift and DroplightIcons.bundle in your project. And Segue Any TableViewController to your Class controller class and assign that TableViewController class to DBListingViewController.


# Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

 



