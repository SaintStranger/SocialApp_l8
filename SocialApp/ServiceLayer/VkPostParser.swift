//
//  VkPostParser.swift
//  SocialApp
//
//  Created by test on 10.06.2022.
//

import Foundation
import UIKit

class VkPostParser {
    
    var news: NewsModel!
    
    let dispatchGroup = DispatchGroup()
    
    var asyncQueue = DispatchQueue(label: "OrderItemsQueue", qos: .default, attributes: .concurrent)
    
    func reloadData(table: UITableView) {
        table.reloadData()
        print("cccccc")
    }
    
    
    func urlForNews() -> URL? {
     
        var separatedUrl = URLComponents()

            separatedUrl.scheme = "https"
            separatedUrl.host = "api.vk.com"
            separatedUrl.path = "/method/newsfeed.get"
            separatedUrl.queryItems = [
                URLQueryItem(name: "v", value: "5.131"),
                URLQueryItem(name: "count", value: "20"),
                URLQueryItem(name: "access_token", value: "\(session.token)"),
                URLQueryItem(name: "filters", value: "post")
            ]
        
        return separatedUrl.url
    }

    func urlForRecentNews(latestTime: String) -> URL? {
     
        var separatedUrl = URLComponents()

            separatedUrl.scheme = "https"
            separatedUrl.host = "api.vk.com"
            separatedUrl.path = "/method/newsfeed.get"
            separatedUrl.queryItems = [
                URLQueryItem(name: "v", value: "5.131"),
                URLQueryItem(name: "count", value: "1"),
                URLQueryItem(name: "start_time", value: latestTime),
                URLQueryItem(name: "access_token", value: "\(session.token)"),
                URLQueryItem(name: "filters", value: "post")
            ]
        
        return separatedUrl.url
    }
    
    func urlForUpdationNews(from: String) -> URL? {
     
        var separatedUrl = URLComponents()

            separatedUrl.scheme = "https"
            separatedUrl.host = "api.vk.com"
            separatedUrl.path = "/method/newsfeed.get"
            separatedUrl.queryItems = [
                URLQueryItem(name: "v", value: "5.131"),
                URLQueryItem(name: "count", value: "20"),
                URLQueryItem(name: "start_from", value: from),
                URLQueryItem(name: "access_token", value: "\(session.token)"),
                URLQueryItem(name: "filters", value: "post")
            ]
        
        return separatedUrl.url
    }
    
    func getUpdatedNews(table: UITableView, url: URL?, completion: @escaping ([Item]) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let url = url else { return }
        var request = URLRequest(url: url)
        print("тут написан ньюз URL \(request)")
        request.httpMethod = "POST"

        // 2. Создаем запрос
        let task = vkSession.dataTask(with: request) {  (data, response, error) in

            // 3. Ловим ошибку
            if error != nil {
                onError(PostGettingError.errorTask)
            }
            // 4 Проверяем есть ли data
            guard let data = data else {
                onError(PostGettingError.noData)
                return
            }
            // 5 Парсим data
            
            guard var news = try? JSONDecoder().decode(NewsModel.self, from: data).response.items else {
                onError(PostGettingError.failedToDecode)
                print("Error profiles")
                return
            }

            guard let profiles = try? JSONDecoder().decode(NewsModel.self, from: data).response.profiles else {
                onError(PostGettingError.failedToDecode)
                print("Error profiles")
                return
            }
            
            
            guard let groups = try? JSONDecoder().decode(NewsModel.self, from: data).response.groups else {
                onError(PostGettingError.failedToDecode)
                print("Error groups")
                return
            }
            
            for item in 0..<news.count {
                if news[item].sourceId < 0 {
                    let group = groups.first(where: { $0.id == -news[item].sourceId })
                    news[item].sourceAvatar = group?.photo50 ?? ""
                    news[item].sourceName = group?.name ?? ""
                    print("dhgjkhgjkh")
                    print(news[item].sourceName)
                } else {
                    let profile = profiles.first(where: { $0.id == news[item].sourceId })
                    news[item].sourceAvatar = profile?.photo50 ?? ""
                    news[item].sourceName = profile?.mergeName() ?? ""
                    
                    print("cxbcvxbcxvxb")
                    print(news[item].sourceName)
                }
            }

    

            // 6 Объединяю массивы


            DispatchQueue.main.async {
                completion(news)
                self.reloadData(table: table)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    func getNews(table: UITableView, url: URL?, completion: @escaping ([Item], String) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let url = url else { return }
        var request = URLRequest(url: url)
        print("тут написан ньюз URL \(request)")
        request.httpMethod = "POST"

        // 2. Создаем запрос
        let task = vkSession.dataTask(with: request) {  (data, response, error) in

            // 3. Ловим ошибку
            if error != nil {
                onError(PostGettingError.errorTask)
            }
            // 4 Проверяем есть ли data
            guard let data = data else {
                onError(PostGettingError.noData)
                return
            }
            // 5 Парсим data
            
            guard var news = try? JSONDecoder().decode(NewsModel.self, from: data).response.items else {
                onError(PostGettingError.failedToDecode)
                print("Error profiles")
                return
            }

            guard let profiles = try? JSONDecoder().decode(NewsModel.self, from: data).response.profiles else {
                onError(PostGettingError.failedToDecode)
                print("Error profiles")
                return
            }
            
            
            guard let groups = try? JSONDecoder().decode(NewsModel.self, from: data).response.groups else {
                onError(PostGettingError.failedToDecode)
                print("Error groups")
                return
            }
            
            for item in 0..<news.count {
                if news[item].sourceId < 0 {
                    let group = groups.first(where: { $0.id == -news[item].sourceId })
                    news[item].sourceAvatar = group?.photo50 ?? ""
                    news[item].sourceName = group?.name ?? ""
                    print("dhgjkhgjkh")
                    print(news[item].sourceName)
                } else {
                    let profile = profiles.first(where: { $0.id == news[item].sourceId })
                    news[item].sourceAvatar = profile?.photo50 ?? ""
                    news[item].sourceName = profile?.mergeName() ?? ""
                    
                    print("cxbcvxbcxvxb")
                    print(news[item].sourceName)
                }
            }

            
            guard let nextFrom = try? JSONDecoder().decode(NewsModel.self, from: data).response.nextFrom else {
                print("Error nextForm")
                return
            }

            // 6 Объединяю массивы


            DispatchQueue.main.async {
                completion(news, nextFrom)
                self.reloadData(table: table)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
}









enum PostGettingError: Error {
    case noResponse
    case errorTask
    case noData
    case failedToDecode
    case nextFromFailed
}

extension PostGettingError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noResponse:
            return "Не получен ответ от сервера"
        case .errorTask:
            return "Ошибка запроса"
        case .noData:
            return "Данные постов не получены"
        case .failedToDecode:
            return "Ошибка парсинга"
        case .nextFromFailed:
            return "Некстформа отвалилась"
        }
    }
}


//MARK: Старый код

//func getNews(table: UITableView, completion: @escaping ([Item]) -> ()) {
//
//    separatedUrl.scheme = "https"
//    separatedUrl.host = "api.vk.com"
//    separatedUrl.path = "/method/newsfeed.get"
//    separatedUrl.queryItems = [
//        URLQueryItem(name: "v", value: "5.131"),
//        URLQueryItem(name: "access_token", value: "\(session.token)"),
//        URLQueryItem(name: "filters", value: "post")
//    ]
//
//    var request = URLRequest(url: separatedUrl.url!)
//    print("тут написан ньюз URL \(request)")
//    request.httpMethod = "POST"
//
//    let task = vkSession.dataTask(with: request) { [weak self] (data, response, error) in
//        guard let self = self else { return }
//        do {
//            guard let data = data else { return }
//            self.news = try JSONDecoder().decode(NewsModel.self, from: data)
//            print("Смотрим новости")
//            print(data)
//
//        } catch {
//            print("ААААХТУНГ нет новостей \(error)")
//
//        }
//
//        var items = self.news.response.items
//        let profiles = self.news.response.profiles
//        let groups = self.news.response.groups
//
//        //MARK: По идее +/- об этом шла речь в ДЗ. Но может я неверно понял
//        for index in 0..<items.count {
//            self.asyncQueue.async(flags: .barrier) {
//                let item = items[index]
//                let isGroup = item.sourceId < 0
//                if isGroup {
//                    let group = groups.first(where: { $0.id == -item.sourceId} )
//                    items[index].sourceName = group?.name ?? ""
//                    items[index].sourceAvatar = group?.photo50 ?? ""
//                } else {
//                    let profile = profiles.first(where: { $0.id == item.sourceId })
//                    items[index].sourceName = "\(profile?.firstName ?? "")" + " " + "\(profile?.lastName ?? "")"
//                    items[index].sourceAvatar = profile?.photo50 ?? ""
//                }
//            }
//
//
//        }
//
//        completion(items)
//
//        self.dispatchGroup.notify(queue: .main) {
//            self.reloadData(table: table)
//        }
//
//    }
//
//    task.resume()
//}
