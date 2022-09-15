//
//  Factory.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 15.09.2022.
//

import Foundation
import UIKit

class Factory {
    
    lazy var dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
    
    func construct(from userModel: User?) -> FriendViewModel {
        guard let userModel = userModel else { return FriendViewModel(name: "", age: "", city: "", photo: UIImage(named: "bradly")!) }
        return changeFriendModel(from: userModel)
    }
    
    private func changeFriendModel(from model: User) -> FriendViewModel {
        let name = "\(model.firstName)" + " " + "\(model.lastName)"
        var age = ""
        let birthday = dateFormatter.date(from: model.age ?? "")
        
        if birthday != nil {
            let timeInterval = birthday!.timeIntervalSinceNow
            age = "\(abs(Int(timeInterval / 31556926.0)))"
        }
        let city = ""
        let photoUrl = URL(string: model.photo)
        var photo = UIImage(named: "bradly")!
        
        guard let photoUrl = photoUrl else { return FriendViewModel(name: "", age: "", city: "", photo: UIImage(named: "bradly")!) }
        let data = try? Data(contentsOf: photoUrl)
            if data != nil {
                photo = UIImage(data: data!)!
            }
        return FriendViewModel(name: name, age: age, city: city, photo: photo)
    }
    
}
