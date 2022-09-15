//
//  WritingToRealm.swift
//  SocialApp
//
//  Created by test on 21.06.2022.
//

import Foundation
import RealmSwift

class WritingToRealm: Operation {
    
    var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    override func main() {
        
        print("Пошла запись")

        guard let parseFriends = dependencies.first as? DataParsing else { return }
        
        do {
            let realm = try Realm()
            realm.beginWrite()
            
            switch model {
            case .user:
                guard let data = parseFriends.outputData as? [User] else { return }
                realm.add(data, update: .modified)
            case .groups:
                guard let data = parseFriends.outputData as? [Group] else { return }
                realm.add(data, update: .modified)
            }
            
            
            try realm.commitWrite()
            print("Данные записаны")
        } catch {
            print(error)
            print("Данные не записаны")
        }
        
    }
    
}
