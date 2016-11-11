//
//  MZDownloadedViewController.swift
//  MZDownloadManager
//
//  Created by Muhammad Zeeshan on 23/10/2014.
//  Copyright (c) 2014 ideamakerz. All rights reserved.
//

import UIKit

class MZDownloadedViewController: UITableViewController {
    
    var downloadedFilesArray : [String] = []
    var selectedIndexPath    : IndexPath?
    let cellIdentifier       = "DownloadedFileCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let contentOfDir = try FileManager.default.contentsOfDirectory(atPath: MZUtility.baseFilePath as String)
            downloadedFilesArray.append(contentsOf: contentOfDir)
            
            let index = downloadedFilesArray.index(of: ".DS_Store")
            if let index = index {
                downloadedFilesArray.remove(at: index)
            }
        } catch let error as NSError {
            print("Error while getting directory content \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadFinishedNotification(_:)), name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NSNotification Methods -
    
    func downloadFinishedNotification(_ notification : Notification) {
        let fileName : String = notification.object as! String
        downloadedFilesArray.append(fileName)
        tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.fade)
    }
}

//MARK: UITableViewDataSource Handler Extension

extension MZDownloadedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedFilesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = downloadedFilesArray[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate Handler Extension

extension MZDownloadedViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let fileName : String = downloadedFilesArray[indexPath.row]
        let fileURL  : URL = URL(fileURLWithPath: "\(MZUtility.baseFilePath)/\(fileName)")
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            downloadedFilesArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        } catch let error as NSError {
            debugPrint("Error while deleting file: \(error)")
        }
    }
}
