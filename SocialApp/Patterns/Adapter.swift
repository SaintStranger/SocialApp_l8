//
//  Adapter.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 12.09.2022.
//

import Foundation
import UIKit
import RealmSwift

class Adapter {
    
    private var getGroups = GetGroupsByPromise()
    private var token: NotificationToken?
    
    func getGroups(table: UITableView, complition: @escaping ([NewGroup]) -> Void) {
        
        getGroups.mergeUrl()
            .then(on: .global(), getGroups.getData(request:))
            .then(getGroups.parseData(data:))
            .then({ groups in
                self.getGroups.saveData(groups: groups)
            })
            .done(on: .main) { groups in
                guard let realm = try? Realm() else { return }
                let groups = realm.objects(Group.self)
                
                var newGroups: [NewGroup] = []
                for group in groups {
                    newGroups.append(self.changeClass(oldGroup: group))
                }
                print("Смотреть сюды")
                self.token = groups.observe({ (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial:
                        table.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        table.beginUpdates()
                        table.insertRows(at: insertions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        table.deleteRows(at: deletions.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        table.reloadRows(at: modifications.map( { IndexPath(row: $0, section: 0) } ), with: .automatic)
                        table.endUpdates()
                    case .error(let error):
                        print("\(error)")
                    }
                })
                complition(newGroups)
                print("Цепочка прошла")
            }.catch { error in
                print(error)
                print("Цепочка не прошла")
            }
        
    }

    private func changeClass(oldGroup: Group) -> NewGroup {
        return NewGroup(id: oldGroup.id, name: oldGroup.name, photo: oldGroup.photo)
    }
    
}
