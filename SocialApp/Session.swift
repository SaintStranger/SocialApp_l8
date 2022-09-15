//
//  Session.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 02.02.2021.
//

import Foundation


class Session {
    
    static var instance = Session()
    
    private init() {}
    
    var token: String = ""
    var userId: Int = 0
    
}




