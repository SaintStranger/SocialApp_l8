//
//  Promise.swift
//  SocialApp
//
//  Created by test on 24.06.2022.
//

import Foundation
import PromiseKit
import RealmSwift


class GetGroupsByPromise {
    
    
    func mergeUrl() -> Promise<URLRequest> {
        
        var separatedUrl = URLComponents()
        
        separatedUrl.scheme = "https"
        separatedUrl.host = "api.vk.com"
        separatedUrl.path = "/method/groups.get"
        separatedUrl.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: "\(session.token)")]
        
        
        return Promise{ resolver in
            
            guard let url = separatedUrl.url else {
                resolver.reject(PromisErrors.wrongUrl)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            resolver.fulfill(request)
            print("Урл собран")
        }
        
    }

    func getData(request: URLRequest) -> Promise<Data> {
        
        return Promise{ resolver in
            
            vkSession.dataTask(with: request) { (data, response, error) in
                
                guard let data = data else {
                    return resolver.reject(PromisErrors.wrongData)
                }

                resolver.fulfill(data)
                print("Данные получены")
                
            }.resume()
            
        }
        
    }

    func parseData(data: Data) -> Promise<[Group]> {
        
        return Promise { resolver in
            
            do {
                
                let groups = try JSONDecoder().decode(GroupsResponse.self, from: data).response.items
                resolver.fulfill(groups)

                print("Данные распарсены")
                
            } catch {
                
                resolver.reject(PromisErrors.wrongParse)
                print(error)
            }
            
        }
        
    }


    func saveData(groups: [Group]) -> Promise<Realm> {
        
        return Promise { resolver in
            
            guard let realm = try? Realm() else { return }
            
            do {
                
                realm.beginWrite()
                
                for group in groups {
                    realm.add(group, update: .modified)
                }
                
                try realm.commitWrite()
                
                resolver.fulfill(realm)
                
                print("Данные сохранены в БД")
                
            } catch {
                
                resolver.reject(PromisErrors.wrongDB)
                
                print("Данные не сохранены")
                
            }
            
            
        }
        
        
    }
    
    
}


enum PromisErrors: Error {
    case wrongUrl
    case wrongData
    case wrongParse
    case wrongDB
}

extension PromisErrors: CustomStringConvertible {
    public var description: String {
        switch self {
        case .wrongUrl:
            return "Некорректный УРЛ."
        case .wrongData:
            return "Данные не получены."
        case .wrongParse:
            return "Данные не получилось распарсить."
        case .wrongDB:
            return "Данные не получилось сохранить."
        }
    }
}
