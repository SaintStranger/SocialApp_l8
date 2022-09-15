//
//  DataParsing.swift
//  SocialApp
//
//  Created by test on 21.06.2022.
//

import Foundation
import RealmSwift

enum Model {
    case user
    case groups
}


class DataParsing: Operation {
    
    var model: Model
    var data: Data?
    
    init(model: Model) {
        self.model = model
    }
    
    var outputData: [Any] = []
    
    override func main() {
        print("Данные из первой операции")
        guard let getFriendsOperation = dependencies.first as? GetDataFromVK,
              let data = getFriendsOperation.data else { return }
        do {
            switch model {
            case .user:
                let parsedObjects = try JSONDecoder().decode(FriendsResponse.self, from: data)
                outputData = parsedObjects.response.items
                print("Получены данные пользователей")
            case .groups:
                let parsedObjects = try JSONDecoder().decode(GroupsResponse.self, from: data)
                outputData = parsedObjects.response.items		
                print("Получены данные групп")
            }
            
        } catch {
            print(error)
            print("Данные не получены")
        }
        
    }
    
}
