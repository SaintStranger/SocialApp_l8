//
//  BuildVkUrl.swift
//  SocialApp
//
//  Created by test on 21.06.2022.
//

import Foundation

enum methodsVk: String {
    case friends = "friends.get"
    case groups = "groups.get"
}


func mergeURL(methodVK: methodsVk) -> URL {
 
    var separatedUrl = URLComponents()

        separatedUrl.scheme = "https"
        separatedUrl.host = "api.vk.com"
        separatedUrl.path = "/method/\(methodVK.rawValue)"
        separatedUrl.queryItems = [
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: "\(session.token)")
        ]
    
    
    switch methodVK {
        
    case .friends:
        let param1 = URLQueryItem(name: "fields", value: "nickname,bdate,city,photo_100")
        let param2 = URLQueryItem(name: "order", value: "name")
        separatedUrl.queryItems?.append(param1)
        separatedUrl.queryItems?.append(param2)
        print(separatedUrl)
        print("Смотри курлы")
    case .groups:
        let param1 = URLQueryItem(name: "extended", value: "1")
        separatedUrl.queryItems?.append(param1)
    }
    
    return separatedUrl.url!
}
