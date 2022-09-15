//
//  AccountParser.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 02.03.2021.
//

import Foundation
import RealmSwift


class Account: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var secondName: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(json: [String: Any]) {
        self.init()
        let values = json["response"] as! [String: Any]
        self.name = values["first_name"] as! String
        self.id = values["id"] as! Int
        self.secondName = values["last_name"] as! String
    }
}

class ProfilePhoto: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var photo: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }

    
    convenience required init(json: [String: Any]) {
        self.init()
        let values = json["response"] as! [String: Any]
        let infoArray = values["items"] as! [Any]
        let photoData = infoArray.first as! [String: Any]
        self.id = photoData["id"] as! Int
        let photoArray = photoData["sizes"] as! [Any]
        let photoUrl = photoArray.last as! [String: Any]
        self.photo = photoUrl["url"] as! String
    }
    
}

//Имя и фото парсим через JSONSerialization просто для пробы

func getUserInfo(completion: @escaping ([String: Any]) -> Void)  {
    
    var separatedUrl = URLComponents()
    
    separatedUrl.scheme = "https"
    separatedUrl.host = "api.vk.com"
    separatedUrl.path = "/method/account.getProfileInfo"
    separatedUrl.queryItems = [
        URLQueryItem(name: "extended", value: "1"),
        URLQueryItem(name: "v", value: "5.130"),
        URLQueryItem(name: "access_token", value: "\(session.token)")]

    var request = URLRequest(url: separatedUrl.url!)
    request.httpMethod = "POST"
    
    let task = vkSession.dataTask(with: request) { (data, response, error) in
        
        guard let data = data else { return }
        print("тут написан URL \(request)")
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        
        let accountJson = json as! [String: Any]
        
        completion(accountJson)
    }

    task.resume()

}

func getUserPhoto(completion: @escaping ([String: Any]) -> Void) {
    
    var separatedUrl = URLComponents()
    
    separatedUrl.scheme = "https"
    separatedUrl.host = "api.vk.com"
    separatedUrl.path = "/method/photos.getAll"
    separatedUrl.queryItems = [
        URLQueryItem(name: "extended", value: "1"),
        URLQueryItem(name: "v", value: "5.130"),
        URLQueryItem(name: "access_token", value: "\(session.token)")]

    var request = URLRequest(url: separatedUrl.url!)
    request.httpMethod = "GET"
    
    let task = vkSession.dataTask(with: request) { (data, response, error) in
        
        guard let data = data else { return }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        
        let accountPhotoJson = json as! [String: Any]

//        let values = accountPhotoJson["response"] as! [String: Any]
//        let infoArray = values["items"] as! [Any]
//        let photoData = infoArray.first as! [String: Any]
//        let photoArray = photoData["sizes"] as! [Any]
//        let photoUrl = photoArray.last as! [String: Any]
//        let urlPhoto = photoUrl["url"] as! String
        completion(accountPhotoJson)
//        
//        print("Смотреть вот тут фото --> " + "\(url)")
        
    }

    task.resume()


}

