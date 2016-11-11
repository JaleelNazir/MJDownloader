//
//  MZAvailableDownloadsViewController.swift
//  MZDownloadManager
//
//  Created by Muhammad Zeeshan on 23/10/2014.
//  Copyright (c) 2014 ideamakerz. All rights reserved.
//

import UIKit

class MZAvailableDownloadsViewController: UITableViewController {
    
    var mzDownloadingViewObj    : MZDownloadManagerViewController?
    var availableDownloadsArray: [URL] = []
    
    let myDownloadPath = MZUtility.baseFilePath + "/My Downloads"
    let cellIdentifier = "AvailableDownloadsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        do {
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: myDownloadPath)
            for filePath in filePaths {
                do {
                    try FileManager.default.removeItem(atPath: myDownloadPath + "/\(filePath)")
                }  catch let err {
                    print(err)
                }
            }
        } catch let err {
            print(err)
        }
        
        debugPrint("custom download path: \(myDownloadPath)")

        availableDownloadsArray.append(URL(string:"https://dl.dropboxusercontent.com/u/97700329/AlecrimCoreData-master.zip")!)
        availableDownloadsArray.append(URL(string:"https://dl.dropbox.com/u/97700329/file1.mp4")!)
        availableDownloadsArray.append(URL(string:"https://dl.dropbox.com/u/97700329/file2.mp4")!)
        availableDownloadsArray.append(URL(string:"https://dl.dropbox.com/u/97700329/file3.mp4")!)
        availableDownloadsArray.append(URL(string:"https://dl.dropbox.com/u/97700329/FileZilla_3.6.0.2_i686-apple-darwin9.app.tar.bz2")!)
        availableDownloadsArray.append(URL(string:"https://dl.dropbox.com/u/97700329/GCDExample-master.zip")!)
        
        self.setUpDownloadingViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpDownloadingViewController() {
        if let tabBarTabs = self.tabBarController?.viewControllers {
           let mzDownloadingNav : UINavigationController = tabBarTabs[1] as! UINavigationController
            mzDownloadingViewObj = mzDownloadingNav.viewControllers[0] as? MZDownloadManagerViewController
        }
    }
}

//MARK: UITableViewDataSource Handler Extension

extension MZAvailableDownloadsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableDownloadsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let fileURL   = availableDownloadsArray[indexPath.row]
        let fileName  = fileURL.lastPathComponent
        cell.textLabel?.text = fileName
        return cell
    }
}

//MARK: UITableViewDelegate Handler Extension

extension MZAvailableDownloadsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fileURL  = availableDownloadsArray[indexPath.row]
        let fileName = fileURL.lastPathComponent
        
        //Use it download at default path i.e document directory
        
        //        mzDownloadingViewObj?.downloadManager.addDownloadTask(fileName as String, fileURL: fileURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        mzDownloadingViewObj?.downloadManager.addDownloadTask(fileName , fileURL: fileURL, destinationPath: myDownloadPath)
        
        availableDownloadsArray.remove(at: (indexPath as NSIndexPath).row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right)
    }
}
