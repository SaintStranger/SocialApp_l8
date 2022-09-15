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
    var viewModel: FriendViewModel?
    var token: NotificationToken?
    let viewModelFactory = Factory()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = viewModelFactory.construct(from: friendInfo)
        
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
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendInfoItem", for: indexPath) as! FriendsInfoCollectionViewCell
        if viewModel != nil {
            cell.configure(viewModel: viewModel!)
            return cell
        } else {
            return UICollectionViewCell()
        }
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

}





