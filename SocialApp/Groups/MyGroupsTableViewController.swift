//
//  MyGroupsTableViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 21.10.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    var adapter = Adapter()
    var groups: [NewGroup] = []
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.getGroups(table: self.tableView) { [weak self] newGroups in
            guard let self = self else { return }
            self.groups = newGroups
            self.tableView.reloadData()
        }
        tableView.register(UINib(nibName: "UniTableViewCell", bundle: nil), forCellReuseIdentifier: "uniCell")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uniCell", for: indexPath) as! UniTableViewCell
        
        if let url = URL(string: (groups[indexPath.row].photo)) {
            cell.name.text = groups[indexPath.row].name
            let data = try? Data(contentsOf: url)
            if let data = data {
                cell.avatarView.image = UIImage(data: data)
            }
        }
        return cell
    }
}


