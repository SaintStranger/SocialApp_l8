//
//  AccountViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 25.02.2021.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoConfigure()
        
        let width = photo.layer.frame.width
        photo.layer.cornerRadius = width / 2
        photo.layer.masksToBounds = true
        photo.layer.setNeedsDisplay()
        
        nameConfigure()
            
    }
    
    
    
    //Извращаемся над сохранение фото
    func photoConfigure() {
        do {
            let realm = try Realm()
            let profiles = realm.objects(ProfilePhoto.self)
            let profile = profiles.first
            
            if profile == nil {
                getUserPhoto { json in
                    let profilePhoto = ProfilePhoto.init(json: json)
                    let url = profilePhoto.photo
                    let data = try? Data(contentsOf: URL(string: url)!)
                    DispatchQueue.main.async {
                        self.photo?.image = UIImage(data: data!)
                        self.photo.contentMode = .top
                        do {
                            let realm = try Realm()
                            realm.beginWrite()
                            realm.add(profilePhoto, update: .all)
                            try realm.commitWrite()
                        } catch {
                            print(error.localizedDescription)
                        }
                        print("Изображение пользователя из интернета")
                    }
                }
            } else {
                let url = profile!.photo
                let data = try? Data(contentsOf: URL(string: url)!)
                self.photo?.image = UIImage(data: data!)
                self.photo.contentMode = .top
                print("Изображение пользователя из базы")
            }
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    //Извращаемся над сохранение имени
    func nameConfigure() {
        do {
            let realm = try Realm()
            let profiles = realm.objects(Account.self)
            let profile = profiles.first
            
            if profile == nil {
                getUserInfo { json in
                    let profile = Account.init(json: json)
                    
                    DispatchQueue.main.async {
                        self.name.text = "\(profile.name)" + " " + "\(profile.secondName)"
                        print("Данные взяты из сети")
                        do {
                            let realm = try Realm()
                            realm.beginWrite()
                            realm.add(profile, update: .all)
                            try realm.commitWrite()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                self.name.text = "\(profile!.name)" + " " + "\(profile!.secondName)"
                print("Данные взяты из базы")
            }
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


