//
//  TableViewController.swift
//  SwiftyDropDataListing
//
//  Created by Administrator on 18/04/17.
//  Copyright © 2017 SammyOne. All rights reserved.
//

import UIKit
import SwiftyDropbox

protocol SelectedDropboxData {
    func getDropboxSelectedData(_ dataArr: [String])
}


class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var filesArr: [Files.Metadata] = []
    var searchActive : Bool = false
    var delegate:SelectedDropboxData?
    var request: DownloadRequestFile<Files.FileMetadataSerializer, Files.DownloadErrorSerializer>?
    var cache:NSCache<AnyObject, AnyObject> = NSCache()
    var loaderBGView: UIView!
    var progressView: UIProgressView!
    var lblPercentage: UILabel!
    var cancelBtn: UIButton!
    var searchBar:UISearchBar!



    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        makeLoader()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.searchActive {
            return 0//self.filtered.count
        }
        return filesArr.count//dropboxData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropboxListingCell") as! DropboxListingCell
        cell.listImageView.image = UIImage(named: "folder_icon")
        let fileInfo = filesArr[indexPath.row]
        
        switch (fileInfo.name as NSString).pathExtension {
        case "bmp" , "cr2", "gif", "ico", "ithmb", "jpeg", "jpg", "nef", "png", "raw", "svg", "tif", "tiff", "wbmp", "webp":
            if self.cache.object(forKey: fileInfo.dpID as AnyObject) != nil {
                cell.listImageView.image = self.cache.object(forKey: fileInfo.dpID as AnyObject) as? UIImage
            }else{
                if let client = DropboxClientsManager.authorizedClient {
                    client.files.download(path: fileInfo.pathLower!)
                        .response(completionHandler: { (file, error) in
                            cell.listImageView.image = UIImage(data: (file?.1)!)
                            self.cache.setObject(cell.listImageView.image!, forKey: file?.0.id as AnyObject)
                        })
                }
            }
            break
        default:
            break
        }
        cell.fileName.text = fileInfo.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
       /* if self.searchActive {
            currentFile = filtered[indexPath.row]
            path = filteredDataPath[indexPath.row]
        } else {
            currentFile = filesArr[indexPath.row].name
            path = filesArr[indexPath.row].pathLower!
        }*/
        
        
        
        // get current file as NSString to check extension
    //    let filename = currentFile as NSString
        
        // if fileExtenstion is folder
        // add folder's data in dropboxData and dropboxDataPath variable and delete old data.
        // else download the file from dropbox'
        
        if (filesArr[indexPath.row].name as NSString).pathExtension == "" {
            if let client = DropboxClientsManager.authorizedClient {
                
                // List folder
                client.files.listFolder(path: filesArr[indexPath.row].pathLower!).response { response, error in
                    // delet old data
                    //          self.dropboxData.removeAll()
                    //          self.dropboxDataPath.removeAll()
                    
                    print("*** List folder ***")
                    
                    if let result = response {
                        print(result)
                        print("Folder contents:")
                        let dropboxListingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
                        dropboxListingViewController.filesArr = result.entries
                        self.navigationController?.pushViewController(dropboxListingViewController, animated: true)
                    } else {
                        
                        //TODO: show message here to user
                    }
                }
            }
        } else {
            loaderBGView.isHidden = false
            progressView.progress = 0
            lblPercentage.text = "\(progressView.progress) %"
            
            //[self.downloadButton startProgressing];
            if let client = DropboxClientsManager.authorizedClient {
                let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    let fileManager = FileManager.default
                    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
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
                    let path = pathComponent.appendingPathComponent(self.filesArr[indexPath.row].name)
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
                
                request = client.files.download(path: self.filesArr[indexPath.row].pathLower!, destination: destination)
                
                
                
                
                request?.progress{ progressData in
                    self.progressView.progress = Float(progressData.fractionCompleted)
                    self.lblPercentage.text = String(format: "%.0f %%", (progressData.fractionCompleted*100))
                }
                
                
                
                request?.response { response, error in
                    self.loaderBGView.isHidden = true
                    if let (metadata, url) = response {
                        
                        print(url.pathExtension)
                        print(url)
                        
                       // self.fileUrl = url
                        //self.fileName = metadata.name
                        
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
            
            client.files.listFolder(path: "", recursive: false, includeMediaInfo: true, includeDeleted: false, includeHasExplicitSharedMembers: true)
                .response { response, error in
                    print("*** List folder ***")
                    
                    if let result = response {
                        print("Folder contents:")
                        self.filesArr = result.entries
                        self.tableView.reloadData()
                    } else {
                        //show error message
                        print("error")
                    }
            }
        }
    }
    
    //MARK: IBACTIONS
    
    func downloadProgressed(progress: CGFloat){
        //self.downloadButton.setProgress(progress, animated: true)
    }
    
    func cancelBtnClicked(_ sender: AnyObject){
        request?.cancel()
    }
    
    //MARK: CUSTOM METHODS
    
    func getDBClient() -> DropboxClient?{
        return DropboxClientsManager.authorizedClient
    }
    
    func addSearchBar(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44.0))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func makeLoader(){
       
        loaderBGView = UIView(frame: self.view.frame)
        loaderBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        progressView = UIProgressView(frame: CGRect(x: 30, y: ((self.view.frame.size.height/2) - 10), width: self.view.frame.size.width-60, height: 10.0))
        progressView.progress = 0.0
        progressView.tintColor = UIColor(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.white
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        
        let lblDownload = UILabel(frame: CGRect(x: 30, y: progressView.frame.origin.y-30, width: self.view.frame.size.width-60, height: 20.0))
        lblDownload.text = "Downloading"
        lblDownload.textColor = UIColor.white
        lblDownload.textAlignment = .center
        
        lblPercentage = UILabel(frame: CGRect(x: 30, y: progressView.frame.size.height + progressView.frame.origin.y+5, width: self.view.frame.size.width-60, height: 15.0))
        lblPercentage.textColor = UIColor.white
        lblPercentage.textAlignment = .center
        lblPercentage.font = UIFont.systemFont(ofSize: 15.0)
        
        cancelBtn = UIButton(frame: CGRect(x: self.view.frame.size.width-120, y: 20, width: 100, height: 50))
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.tintColor = UIColor.white
        cancelBtn.addTarget(self, action: #selector(TableViewController.cancelBtnClicked(_:)), for: .touchUpInside)
        
        loaderBGView.addSubview(cancelBtn)
        loaderBGView.addSubview(lblDownload)
        loaderBGView.addSubview(progressView)
        loaderBGView.addSubview(lblPercentage)
        self.view.addSubview(loaderBGView)
        loaderBGView.isHidden = true
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
       /*
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
        self.tableView.reloadData()*/
    }
    

   
}
