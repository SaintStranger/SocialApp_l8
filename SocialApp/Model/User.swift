//
//  User.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 15.10.2020.
//

import Foundation
import RealmSwift

var friendsList = [User]()

var filteredFriends: Results<User>?

class FriendsResponse: Decodable {
    var response: Friends
}

class Friends: Decodable {
    var count: Int = 0
    var items: [User]
}

class User: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var age: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum UserCodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_100"
        case age = "bdate"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let info = try decoder.container(keyedBy: UserCodingKeys.self)
        self.id = try info.decode(Int.self, forKey: .id)
        self.firstName = try info.decode(String.self, forKey: .firstName)
        self.lastName = try info.decode(String.self, forKey: .lastName)
        self.name = "\(firstName)" + " " + "\(lastName)"
        self.age = try? info.decode(String.self, forKey: .age)
        self.photo = try info.decode(String.self, forKey: .photo)
    }
    
}





// MARK: - Item
//struct User: Codable {
//    let id: Int
//    let nickname, bdate: String?
//    let city: City?
//    let trackCode: String
//    let photo100: String
//    let firstName, lastName: String
//    let canAccessClosed, isClosed: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case id, nickname, bdate, city
//        case trackCode = "track_code"
//        case photo100 = "photo_100"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case canAccessClosed = "can_access_closed"
//        case isClosed = "is_closed"
//    }
//}
//
//// MARK: - City
//struct City: Codable {
//    let id: Int
//    let title: String
//}

