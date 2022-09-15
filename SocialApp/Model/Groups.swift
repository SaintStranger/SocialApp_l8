//
//  test.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 21.10.2020.
//

import Foundation
import RealmSwift

var userGroups = [Group]()

class GroupsResponse: Decodable {
    var response: Groups
}

class Groups: Decodable {
    var count: Int = 0
    var items: [Group]
}

class Group: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
//    var added: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    enum GroupCodingKeys: String, CodingKey {
        case photo = "photo_100"
        case name
        case id
//        case added = "is_member"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let info = try decoder.container(keyedBy: GroupCodingKeys.self)
        self.photo = try info.decode(String.self, forKey: .photo)
        self.name = try info.decode(String.self, forKey: .name)
        self.id = try info.decode(Int.self, forKey: .id)
//        self.added = try info.decode(Int.self, forKey: .added)
    }
    
}


