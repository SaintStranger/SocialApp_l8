//
//  GroupsParser.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 11.03.2021.
//

import Foundation
import RealmSwift

//Делаем уже через Decode

//Цитата из Vk: "Параметры могут передаваться как методом GET, так и POST", поэтому пробуем оба

func getUserGroups() {
    
    var separatedUrl = URLComponents()
    
    separatedUrl.scheme = "https"
    separatedUrl.host = "api.vk.com"
    separatedUrl.path = "/method/groups.get"
    separatedUrl.queryItems = [
        URLQueryItem(name: "extended", value: "1"),
        URLQueryItem(name: "v", value: "5.131"),
        URLQueryItem(name: "access_token", value: "\(session.token)")]

    var request = URLRequest(url: separatedUrl.url!)
    request.httpMethod = "POST"
    
    let task = vkSession.dataTask(with: request) { (data, response, error) in
        
        do {
            
            guard let data = data else { return }
            
            let groups = try JSONDecoder().decode(GroupsResponse.self, from: data)
            
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups.response.items, update: .modified)
            try realm.commitWrite()
            print("говорит и показывает  \(groups.response.items)")
//            print("Смотреть вот тут группы пользователя --> " + "\(user)")
            
        } catch {
            print("ААААХТУНГ \(error)")
        }
        
        
    }

    task.resume()

}

func loadGroups() {
    do {
        let realm = try Realm()
        let groups = realm.objects(Group.self)
        userGroups = Array(groups)
        print("база \(String(describing: realm.configuration.fileURL ?? nil))")
        print("Группы из банки")
    } catch {
        print(error)
    }
}


func getSearchGroups(to search: String, completionHandler: @escaping ([Group]) -> Void) {
    
    var separatedUrl = URLComponents()
    
    separatedUrl.scheme = "https"
    separatedUrl.host = "api.vk.com"
    separatedUrl.path = "/method/groups.search"
    separatedUrl.queryItems = [
        URLQueryItem(name: "q", value: "\(search)"),
        URLQueryItem(name: "v", value: "5.130"),
        URLQueryItem(name: "access_token", value: "\(session.token)")]

    var request = URLRequest(url: separatedUrl.url!)
    request.httpMethod = "POST"
    
    let task = vkSession.dataTask(with: request) { (data, response, error) in
        
        do {
            
            guard let data = data else { return }
            
            let groups = try JSONDecoder().decode(GroupsResponse.self, from: data)
            
            completionHandler(groups.response.items)
            
        } catch {
            print("ААААХТУНГ \(error)")
        }
        
        
    }

    task.resume()

}
