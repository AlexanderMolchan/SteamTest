//
//  Models.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import Foundation

// MARK: -
// MARK: - Game Models

struct ResultModel: Decodable {
    var applist: AppsModel
}

struct AppsModel: Decodable {
    var apps: [GameModel]
}

struct GameModel: Decodable {
    var appid: Int
    var name: String
}

// MARK: -
// MARK: - News Models

struct NewsResult: Decodable {
    var appnews: NewsItems
}

struct NewsItems: Decodable {
    var newsitems: [NewsModel]
}

struct NewsModel: Decodable {
    var title: String
    var contents: String
}
