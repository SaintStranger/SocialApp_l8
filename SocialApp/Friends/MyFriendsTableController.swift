//
//  MyFriendsTableController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 15.10.2020.
//

import UIKit
import RealmSwift
import Alamofire

class MyFriendsTableController: UITableViewController, UISearchBarDelegate {
    
    var friendsArray: Results<User>?
    
    let queue = OperationQueue()
    
    var friendsNameFilter: [String] = []
    
    var token: NotificationToken?
    
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "friendsDownload"
        operationQueue.maxConcurrentOperationCount = 3
        return operationQueue
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
            
        let request = AF.request(mergeURL(methodVK: .friends), method: HTTPMethod(rawValue: "POST"))
        sleep(3)
        print(request)

        
        
        let getFriendsOperation = GetDataFromVK(request: request)
        let parseFriends = DataParsing(model: .user)
        let writeFriends = WritingToRealm(model: .user)
        
        parseFriends.addDependency(getFriendsOperation)
        writeFriends.addDependency(parseFriends)
        
        operationQueue.addOperation(getFriendsOperation)
        operationQueue.addOperation(parseFriends)
        operationQueue.addOperation(writeFriends)

        
        

        
        updateFriendsFromRealm()
        

        
        
        tableView.register(UINib(nibName: "UniTableViewCell", bundle: nil), forCellReuseIdentifier: "uniCell")

    }
    
    func namesSorted () {

        var tempNameArray: [String] = []

        for i in filteredFriends! {

            tempNameArray.append(String(i.name.first!))

            friendsNameFilter = Array(Set(tempNameArray).sorted())

        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FriendsInfoCollectionViewController") as! FriendsInfoCollectionViewController
        
//        let friendInSection = filteredFriends!.filter { (friend) -> Bool in
//            self.friendsNameFilter[self.tableView.indexPathForSelectedRow!.section] == String(friend.name.first!)
//        }
        
        let clickedFriend = filteredFriends![indexPath.row]
        
        controller.friendInfo = clickedFriend
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    

    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return friendsNameFilter.count
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return String(friendsNameFilter[section])
//    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
//        let friendsInSection = filteredFriends!.filter { (friend) -> Bool in
//            self.friendsNameFilter[section] == String(friend.name.first!)
//        }
        
        guard filteredFriends?.count != nil else {
            return 0
        }
        return filteredFriends!.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uniCell", for: indexPath) as! UniTableViewCell
        
//        let friendsInSection = filteredFriends!.filter { (friend) -> Bool in
//            self.friendsNameFilter[indexPath.section] == String(friend.name.first!)
//        }

        var nameArray = [String]()
        var photoArray = [String]()
        
        for friend in filteredFriends! {

            let name = friend.name
            nameArray.append(name)

            let photo = friend.photo
            photoArray.append(photo)

        }
        
        cell.name.text = nameArray[indexPath.row]
        
        let data = try? Data(contentsOf: URL(string: photoArray[indexPath.row])!)
        cell.avatarView.image = UIImage(data: data!)
        
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let friend = friendsArray![indexPath.row]
                let filteredFriend = filteredFriends![indexPath.row]
                realm.beginWrite()
                realm.delete(friend)
                realm.delete(filteredFriend)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        } 
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return friendsNameFilter
//    }

    // SearchBar code
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredFriends = friendsArray?.sorted(byKeyPath: "name")
        } else {

            let text = searchText.lowercased()
            
            filteredFriends = friendsArray?.filter("name CONTAINS '\(text)' OR name CONTAINS '\(searchText)'")

        }
        self.tableView.reloadData()
    }
    
    
    
    //Friends Update
    
    func updateFriendsFromRealm() {
        
        guard let realm = try? Realm() else { return }
        friendsArray = realm.objects(User.self).sorted(byKeyPath: "name")
        filteredFriends = friendsArray
        token = friendsArray?.observe({ [weak self] (changes: RealmCollectionChange) in
            print("Проверяем токен")
            print(self!.token as Any)
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
    }
    
}
