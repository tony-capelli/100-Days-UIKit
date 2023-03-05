//
//  WebsiteListController.swift
//  Project4
//
//  Created by Tony Capelli on 05/03/23.
//

import UIKit

class WebsiteListController: UITableViewController {
    
    var websites = ["google.com", "instagram.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Web pages"
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = websites[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as! ViewController
        vc.websites = websites
        vc.selectedWebsite = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
