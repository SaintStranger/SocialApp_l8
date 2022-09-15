//
//  FriendsInfoCollectionViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 20.10.2020.
//

import UIKit
import RealmSwift

class FriendsInfoCollectionViewController: UICollectionViewController {
    
    var friendInfo: User?
    
    var token: NotificationToken?
    
    lazy var dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
    
    var age: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let birthday = dateFormatter.date(from: friendInfo?.age ?? "")
        let timeInterval = birthday?.timeIntervalSinceNow

        guard birthday != nil else { return }
        age = abs(Int(timeInterval! / 31556926.0))
        
        token = friendInfo?.observe{ change in
            switch change {
            case .error(let error):
                print(error)
            case .deleted:
                print("object was deleted")
            case .change(_, let properties):
                print(properties)
            }
        }
        
        testUpdate()
        
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendInfoItem", for: indexPath) as! FriendsInfoCollectionViewCell
        
        
        
        cell.infoName.text = friendInfo?.name ?? ""
        if age == 0 {
            cell.infoAge.text = ""
        } else {
            cell.infoAge.text = "\(age)"
        }
        cell.infoNativeCity.text = ""
        let urlPhoto = URL(string: friendInfo?.photo ?? "")
        
        if urlPhoto != nil {
            let data = try? Data(contentsOf: urlPhoto!)
            cell.photoView.photoImage.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    
    //Просто для проверки
    
    func testUpdate() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            friendInfo?.age = "\(1)"
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}





