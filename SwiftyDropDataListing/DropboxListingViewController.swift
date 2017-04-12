//
//  DropboxListingViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  var fileUrl:URL?
  var fileName :String?
  
  ///store dropbox entity's namek
  var dropboxData = [String]()
  
  ///store dropbox entity's path
  var dropboxDataPath = [String]()
  
  var searchActive : Bool = false
  
  var filtered:[String] = []
  var filteredDataPath = [String]()
  
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.showDropboxData()
    
  }
  
  //MARK: UITableViewDataSource and UITableViewDelegate methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if self.searchActive {
      return self.filtered.count
    }
    return dropboxData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "DropboxListingCell") as! DropboxListingCell
    var currentfile = ""

    if self.searchActive {
      currentfile = filtered[indexPath.row]
    } else {
      // get current file name
      currentfile = dropboxData[indexPath.row]
    }
    
    // get current file extension
    let currentfileExtension = currentfile as NSString
    
    let pathExtension = currentfileExtension.pathExtension
    
    //set filename
    cell.fileName.text = currentfile
    
    // check if current file is pdf show pdf icon in cell
    // else if current file is doc show doc icon in cell
    //else show folder icon in cell
    if pathExtension == "pdf" {
      cell.listImageView.image = UIImage(named: "pdf_icon")
    } else if pathExtension == "doc" {
      cell.listImageView.image = UIImage(named: "doc_icon")
    } else if pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
      cell.listImageView.image = UIImage(named: "Image_icon")
    } else {
      cell.listImageView.image = UIImage(named: "folder_icon")
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    var currentFile = ""
    var path = ""
    
    if self.searchActive {
      currentFile = filtered[indexPath.row]
      path = filteredDataPath[indexPath.row]
    } else {
      // get current file name
      currentFile = dropboxData[indexPath.row]
      // get currentfile path
      path = dropboxDataPath[indexPath.row]
    }
    
    // get current file as NSString to check extension
    let filename = currentFile as NSString
    
    // if fileExtenstion is folder
    // add folder's data in dropboxData and dropboxDataPath variable and delete old data.
    // else download the file from dropbox
    if filename.pathExtension == "" {
      if let client = DropboxClientsManager.authorizedClient {
        
        // List folder
        client.files.listFolder(path: path).response { response, error in
          // delet old data
          self.dropboxData.removeAll()
          self.dropboxDataPath.removeAll()
          
          print("*** List folder ***")
          
          if let result = response {
            print(result)
            print("Folder contents:")
            for entry in result.entries {
              
              let str  = entry.name as NSString
              let pathExtension = str.pathExtension
              
              // check pathExtension of entity's and append data
              if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
                
                self.dropboxDataPath.append(entry.pathLower!)
                self.dropboxData.append(entry.name)
              }
            }
            //reload tableview
            self.tableView.reloadData()
          } else {
            
            //TODO: show message here to user
          }
        }
      }
    } else {
      
      if let client = DropboxClientsManager.authorizedClient {
        // Download a file
        
        // create  unique destination for file.
        let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
          let fileManager = FileManager.default
          let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
          
//          let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//          
//          let documentsDirectory: AnyObject = paths[0] as AnyObject
          let dataPath = directoryURL.appendingPathComponent("Resumes")
          
          if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
              // create Resumes folder
              try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
              print(error.localizedDescription);
            }
          }
          
          let pathComponent = directoryURL.appendingPathComponent("Resumes")
          let path = pathComponent.appendingPathComponent(filename as String)
          print(path)
          
          // if file is already exist then delete it first
          if FileManager.default.fileExists(atPath: path.path) {
            do {
              try FileManager.default.removeItem(atPath: path.path)
            }
            catch let error as NSError {
              print("Ooops! Something went wrong: \(error)")
            }
          }
          return path
        }
        
        print(destination)
        
        // download file here in destination.
        client.files.download(path: path, destination: destination).response { response, error in
          if let (metadata, url) = response {
            print("*** Download file ***")
            
            print(url.pathExtension)
            print(url)
            
            self.fileUrl = url
            self.fileName = metadata.name
            
            let data = try? Data(contentsOf: url)
            print("Downloaded file name: \(metadata.name)")
            print("Downloaded file url: \(url)")
            print("Downloaded file data: \(data)")
            self.performSegue(withIdentifier: "FileViewerViewController", sender: nil)
          } else {
            print(error?.description)
            
            // Utilities.showAlertForMessage(message: (error?.description)!)
          }
        }
      }
    }
    
  }
  
  /// show dropbox data in tableview
  func showDropboxData() {
    
    // check user is authorizedClient or not
    // if yes then hit dropbox api and save data in dropboxData  and dropboxDataPath variables.
    if let client = DropboxClientsManager.authorizedClient {
      
      // Get the current user's account info
      client.users.getCurrentAccount().response { response, error in
        print("*** Get current account ***")
        if let account = response {
          print("Hello \(account.name.givenName)!")
        } else {
          print(error!)
        }
      }
      
      // List folder
      client.files.listFolder(path: "").response { response, error in
        print("*** List folder ***")
        print(response)
        
        if let result = response {
          print("Folder contents:")
          
          for entry in result.entries {
            let entryName  = entry.name as NSString
            let pathExtension = entryName.pathExtension
            
            // check pathExtension of entity's and append data
            if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
              self.dropboxDataPath.append(entry.pathLower!)
              self.dropboxData.append(entry.name)
            }
          }
          //reload tableview
          self.tableView.reloadData()
        } else {
          //show error message
          print("error")
        }
      }
    }
  }
  
  //MARK: UISearchbarDelegate methods
 
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    self.searchActive = true

    self.filteredDataPath.removeAll()
    
    filtered = self.dropboxData.filter(
      { (text) -> Bool in
        let tmp: NSString = text as NSString
        let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
        print(range)
        return range.location != NSNotFound
    })
    
    for element in self.filtered {
      let index = self.dropboxData.index(of: element)
      self.filteredDataPath.append(self.dropboxDataPath[index!])
    }

    print(filtered.count)
    
    if(filtered.count == 0) {
      searchActive = false
    } else {
      searchActive = true
    }
    self.tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
    
    if segue.identifier == "FileViewerViewController" {
      if let destVC = segue.destination as?  FileViewerViewController {
        destVC.fileUrl = self.fileUrl
      }
    }
  }
  
}
