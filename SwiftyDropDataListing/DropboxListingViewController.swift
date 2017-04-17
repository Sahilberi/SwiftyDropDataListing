//
//  DropboxListingViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit
import SwiftyDropbox


protocol SelectedData {
    func getDropboxSelectedData(_ dataArr: [String])
}



class DropboxListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var fileUrl:URL?
    var fileName :String?
    var filesArr: [Files.Metadata] = []
    
    ///store dropbox entity's namek
    var dropboxData = [String]()
    
    ///store dropbox entity's path
    var dropboxDataPath = [String]()
    
    var searchActive : Bool = false
    
    var filtered:[String] = []
    var filteredDataPath = [String]()
    var getSelectedData:(([String])->())?
    var delegate:SelectedData?
    var downloadData:[Files.Metadata] = []
    /*
     Files.FileMetadataSerializer
     Files.DownloadErrorSerializer
     */
    var request: DownloadRequestFile<Files.FileMetadataSerializer, Files.DownloadErrorSerializer>?
    var hud : MBProgressHUD?
    
    
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var  downloadButton: GBKUIButtonProgressView!// *downloadButton;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.showDropboxData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  downloadButton.isHidden = true
    }
    
    //MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchActive {
            return self.filtered.count
        }
        return filesArr.count//dropboxData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropboxListingCell") as! DropboxListingCell
        var currentfile = ""
        //var fileInfo:
        
        //    if self.searchActive {
        //      currentfile = filtered[indexPath.row]
        //    } else {
        //      // get current file name
        //      currentfile = filesArr[indexPath.row]//dropboxData[indexPath.row]
        //    }
        cell.listImageView.image = UIImage(named: "folder_icon")
        
        let fileInfo = filesArr[indexPath.row]
        
        switch (fileInfo.name as NSString).pathExtension {
        case "bmp" , "cr2", "gif", "ico", "ithmb", "jpeg", "jpg", "nef", "png", "raw", "svg", "tif", "tiff", "wbmp", "webp":
            
            if let client = DropboxClientsManager.authorizedClient {
                
                
                client.files.download(path: fileInfo.pathLower!)
                    .response(completionHandler: { (file, error) in
                        //                cell.listImageView.image = file
                        cell.listImageView.image = UIImage(data: (file?.1)!)
                    })
                //            client.users.getCurrentAccount().response { response, error in
                //                print("*** Get current account ***")
                //                if let account = response {
                //                    print("Hello \(account.name.givenName)!")
                //                } else {
                //                    print(error!)
                //                }
                //            }
            }
            
            break
        default:
            break
        }
        
        cell.fileName.text = fileInfo.name
        
        
        
        
        // get current file extension
        //    let currentfileExtension = currentfile as NSString
        //
        //    let pathExtension = currentfileExtension.pathExtension
        //
        //    //set filename
        //    cell.fileName.text = currentfile
        //
        //    // check if current file is pdf show pdf icon in cell
        //    // else if current file is doc show doc icon in cell
        //    //else show folder icon in cell
        //    if pathExtension == "pdf" {
        //      cell.listImageView.image = UIImage(named: "pdf_icon")
        //    } else if pathExtension == "doc" {
        //      cell.listImageView.image = UIImage(named: "doc_icon")
        //    } else if pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
        //      cell.listImageView.image = UIImage(named: "Image_icon")
        //    } else {
        //      cell.listImageView.image = UIImage(named: "folder_icon")
        //    }
        
        
        
        
        
        //    switch fileName?.pathExtension {
        //    case ".bmp" , ".cr2", ".gif", ".ico", ".ithmb", ".jpeg", ".jpg", ".nef", ".png", ".raw", ".svg", ".tif", ".tiff", ".wbmp", ".webp":
        //        break
        //    default:
        //        break
        //    }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var currentFile = ""
        var path = ""
        
        if self.searchActive {
            currentFile = filtered[indexPath.row]
            path = filteredDataPath[indexPath.row]
        } else {
            currentFile = filesArr[indexPath.row].name
            path = filesArr[indexPath.row].pathLower!
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
                    //          self.dropboxData.removeAll()
                    //          self.dropboxDataPath.removeAll()
                    
                    print("*** List folder ***")
                    
                    if let result = response {
                        print(result)
                        print("Folder contents:")
                        let dropboxListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DropboxListingViewController") as! DropboxListingViewController
                        dropboxListingViewController.filesArr = result.entries
                        self.navigationController?.pushViewController(dropboxListingViewController, animated: true)
                        //            self.downloadData = result.entries
                        //            self.performSegue(withIdentifier: "DropboxListingViewController", sender: self)
                        //            for entry in result.entries {
                        //
                        //              let str  = entry.name as NSString
                        //              let pathExtension = str.pathExtension
                        //
                        //              // check pathExtension of entity's and append data
                        //              if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
                        //
                        //                self.dropboxDataPath.append(entry.pathLower!)
                        //                self.dropboxData.append(entry.name)
                        //              }
                        //            }
                        //reload tableview
                        //  self.tableView.reloadData()
                    } else {
                        
                        //TODO: show message here to user
                    }
                }
            }
        } else {
            /*MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeAnnularDeterminate;
             hud.labelText = @"Loading";
             [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
             hud.progress = progress;
             } completionCallback:^{
             [hud hide:YES];
             }];
             */
            
            hud = MBProgressHUD.showAdded(to: self.view,animated: true)
            hud?.mode = .annularDeterminate
            hud?.label.text = "Downloading"
            hud?.button.setTitle("Cancel", for: UIControlState.normal)
            hud?.button.addTarget(self, action: #selector(DropboxListingViewController.cancelBtnClicked(_:)), for: .touchUpInside)
            
            //[self.downloadButton startProgressing];
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
                
                // let request =
                
                request = client.files.download(path: path, destination: destination)
                
                
                
                
                request?.progress{ progressData in
                    
                    print("bytesRead = totalUnitCount: \(progressData.totalUnitCount)")
                    print("totalBytesRead = completedUnitCount: \(progressData.completedUnitCount)")
                    
                    print("totalBytesExpectedToRead (Has to sub): \(progressData.totalUnitCount - progressData.completedUnitCount)")
                    
                    print("progressData.fractionCompleted (New)  = \(progressData.fractionCompleted)")
                    //   self.downloadProgressed(progress: CGFloat(progressData.fractionCompleted))
                    self.hud?.progress = Float(progressData.fractionCompleted)
                    
                    
                }
                
                
                
                request?.response { response, error in
                    self.hud?.hide(animated: true)
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
                        self.delegate?.getDropboxSelectedData([url.absoluteString])
                        //  self.getSelectedData!([url.absoluteString])
                        let _ = self.navigationController?.popViewController(animated: true)
                        //self.performSegue(withIdentifier: "FileViewerViewController", sender: nil)
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
            //        client.sharing.listSharedLinks(path: "", cursor: nil, directOnly: nil)
            //            .response { response, error in
            //                print("*** List folder ***")
            //                print(response)
            //
            //                if let result = response {
            //                    print("Folder contents:")
            //
            ////                    for entry in result.entries {
            ////                        let entryName  = entry.name as NSString
            ////                        let pathExtension = entryName.pathExtension
            ////
            ////                        // check pathExtension of entity's and append data
            ////                        if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
            ////                            self.dropboxDataPath.append(entry.pathLower!)
            ////                            self.dropboxData.append(entry.name)
            ////                        }
            ////                    }
            //                    //reload tableview
            //                    self.tableView.reloadData()
            //                } else {
            //                    //show error message
            //                    print("error")
            //                }
            //        }
            //        client.files.listFolder(path: <#T##String#>, recursive: <#T##Bool#>, includeMediaInfo: <#T##Bool#>, includeDeleted: <#T##Bool#>, includeHasExplicitSharedMembers: <#T##Bool#>)
            //        client.files.listFolder(path: "", recursive: false, includeMediaInfo: true, includeDeleted: false, includeHasExplicitSharedMembers: false)
            // client.sharing.listSharedLinks()
            //            .response { response, error in
            //            print("*** List folder ***")
            //            print(response)
            //
            //            if let result = response {
            //                print("Folder contents:")
            //
            ////                for entry in result.entries {
            ////                    let entryName  = entry.name as NSString
            ////                    let pathExtension = entryName.pathExtension
            ////
            ////                    // check pathExtension of entity's and append data
            ////                    if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
            ////                        self.dropboxDataPath.append(entry.pathLower!)
            ////                        self.dropboxData.append(entry.name)
            ////                    }
            ////                }
            //                //reload tableview
            //                self.tableView.reloadData()
            //            } else {
            //                //show error message
            //                print("error")
            //            }
            //        }
            
            
            //        client.sharing.listFolders().response { response, error in
            //            print("*** List folder ***")
            //            print(response)
            //
            //            if let result = response {
            //                print("Folder contents:")
            //
            //                for entry in result.entries {
            //                    let entryName  = entry.name as NSString
            //                    let pathExtension = entryName.pathExtension
            //
            //                    // check pathExtension of entity's and append data
            //                    if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
            //                        self.dropboxDataPath.append(entry.pathLower!)
            //                        self.dropboxData.append(entry.name)
            //                    }
            //                }
            //                //reload tableview
            //                self.tableView.reloadData()
            //            } else {
            //                //show error message
            //                print("error")
            //            }
            //        }
            client.files.listFolder(path: "")//getMetadata(path: "/")
                //client.files.listFolder(path: "")
                .response { response, error in
                    print("*** List folder ***")
                    print(response)
                    
                    if let result = response {
                        print("Folder contents:")
                        self.filesArr = result.entries
                        for entry in result.entries {
                            let entryName  = entry.name as NSString
                            let pathExtension = entryName.pathExtension
                            
                            // check pathExtension of entity's and append data
                            // filesArr =
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
    
    //MARK: SEGUE DELEGATES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DropboxListingViewController"{
            let dropboxListingViewController = segue.destination  as! DropboxListingViewController
            dropboxListingViewController.filesArr = self.downloadData
        }
    }
    
    //MARK: IBACTIONS
    
    func downloadProgressed(progress: CGFloat){
        //self.downloadButton.setProgress(progress, animated: true)
    }
    
    func cancelBtnClicked(_ sender: AnyObject){
        // request.ca
        hud?.hide(animated: true)
        request?.cancel()
        //print("cancel btn clicked")
    }
    
    //MARK: CUSTOM METHODS
    
    func getDBClient() -> DropboxClient?{
        return DropboxClientsManager.authorizedClient
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
    
    //  override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
    //    
    //    if segue.identifier == "FileViewerViewController" {
    //      if let destVC = segue.destination as?  FileViewerViewController {
    //        destVC.fileUrl = self.fileUrl
    //      }
    //    }
    //  }
    
}
