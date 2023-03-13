//
//  ViewController.swift
//  Project7
//
//  Created by Tony Capelli on 07/03/23.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitons = [Petition]()
    var textSearched = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "credits", style: .plain, target: self, action: #selector(showCredit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url){
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
    }
    
    @objc func searchPetition(){
        let ac = UIAlertController(title: "Cerca petizioni", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let search = ac?.textFields?[0].text else { return }
            self?.submit(search)
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Hello", message: "The data you are seeing comes from We The People API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func submit(_ seacrh: String){
        DispatchQueue.global(qos: .background).async {
            self.filteredPetitons = self.petitions.filter({ petition in
                petition.title.lowercased().contains(seacrh)
            })
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredPetitons = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showError(){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = filteredPetitons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

