//
//  AllGroupsTableViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 21.10.2020.
//

import UIKit
import RealmSwift

class AllGroupsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var filteredGroups = [Group]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "UniTableViewCell", bundle: nil), forCellReuseIdentifier: "uniCell")

    }
    
    //Ищем группы по запросу
    
    internal func searchBar(_: UISearchBar, textDidChange searchedText: String) {
        guard searchedText != "" else { return }
        let searchText = searchedText.lowercased()
        print("ищем тут группы по запросу -> \(searchText)")
        getSearchGroups(to: "\(searchText)") { [weak self] (data) in
            guard let self = self else { return }
            self.filteredGroups = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard filteredGroups.count > 0 else { return 0}
        return filteredGroups.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uniCell", for: indexPath) as! UniTableViewCell

        var nameArray = [String]()
        var photoArray = [String]()
        
        for group in filteredGroups {
            
            let name = group.name
            nameArray.append(name)
            
            let photo = group.photo
            photoArray.append(photo)
            
        }
        
        cell.name.text = nameArray[indexPath.row]
        let data = try? Data(contentsOf: URL(string: photoArray[indexPath.row])!)
        cell.avatarView.image = UIImage(data: data!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.popViewController(animated: true)
        
        do {
            let realm = try Realm()
            let group = filteredGroups[indexPath.row]
            realm.beginWrite()
            realm.add(group, update: .modified)
            try realm.commitWrite()
            print("Группа \(group.name) добавлена")
        } catch {
            print("\(error)")
        }
        
        
    }
    
    
}
