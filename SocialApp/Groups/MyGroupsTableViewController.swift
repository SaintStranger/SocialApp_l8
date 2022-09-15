//
//  MyGroupsTableViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 21.10.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
    
    var getGroups = GetGroupsByPromise()
    
    var groups: Results<Group>?
    
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroups.mergeUrl()
            .then(on: .global(), getGroups.getData(request:))
            .then(getGroups.parseData(data:))
            .then({ groups in
                self.getGroups.saveData(groups: groups)
            })
            .done(on: .main) { groups in
                guard let realm = try? Realm() else { return }
                self.groups = realm.objects(Group.self)
                self.token = self.groups?.observe({ [weak self] (changes: RealmCollectionChange) in
                    guard let tableView = self?.tableView else { return }
                    switch changes {
                    case .initial:
                        tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        tableView.beginUpdates()
                        tableView.insertRows(at: insertions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        tableView.deleteRows(at: deletions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        tableView.reloadRows(at: modifications.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        tableView.endUpdates()
                    case .error(let error):
                        print("\(error)")
                    }
                })
                print("Цепочка прошла")
            }.catch { error in
                print(error)
                print("Цепочка не прошла")
            }
        
        
        
        tableView.register(UINib(nibName: "UniTableViewCell", bundle: nil), forCellReuseIdentifier: "uniCell")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uniCell", for: indexPath) as! UniTableViewCell
        
        
        guard let groups = groups else { return cell }
        
        if let url = URL(string: (groups[indexPath.row].photo)) {
            cell.name.text = groups[indexPath.row].name
            let data = try? Data(contentsOf: url)
            if let data = data {
                cell.avatarView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
                
                guard let groups = groups else { return }
                let group = groups[indexPath.row]
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    //MARK: Перенесли код в цепочку промисов
//    func updateGroupsFromRealm() {
//        guard let realm = try? Realm() else { return }
//        groups = realm.objects(Group.self)
//        token = groups?.observe({ [weak self] (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
//                tableView.deleteRows(at: deletions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
//                tableView.reloadRows(at: modifications.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
//                tableView.endUpdates()
//            case .error(let error):
//                print("\(error)")
//            }
//        })
//    }
    
}


