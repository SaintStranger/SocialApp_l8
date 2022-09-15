//
//  Network.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 26.02.2021.
//

import Foundation
import WebKit

//Обращаемся за данными по API

let session = Session.instance

let configuration = URLSessionConfiguration.default

let vkSession = URLSession(configuration: configuration)

