//
//  ViewController.swift
//  Project1
//
//  Created by Tony Capelli on 21/02/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var pictDict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        

        
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
            pictDict[item] = 0
        }
        pictures.sort()
    }
    
    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture
        cell.detailTextLabel?.text = "Viewed \(pictDict[picture]!) times."
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            
            let picture = pictures[indexPath.row]
            pictDict[picture]! += 1
            save()
            tableView.reloadData()
            
            vc.selectedImage = pictures[indexPath.row]
            vc.totalPictures = pictures.count
            vc.selectedPictureNumber = indexPath.row + 1
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareApp() {
        
        let vc = UIActivityViewController(activityItems: ["URL App"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictDict),
            let savedPictures = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictDict")
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("Failed to save data.")
        }
    }
    
}

