//
//  ApiManager.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import Foundation
import Moya

// MARK: -
// MARK: - Api

enum AppListApi {
    case getAppsList
}

enum NewsApi {
    case getNewsFor(id: Int)
}

// MARK: -
// MARK: - Api extensions

extension AppListApi: TargetType {
    var baseURL: URL {
        URL(string: "https://api.steampowered.com/")!
    }
    
    var path: String {
        return "ISteamApps/GetAppList/v2/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        guard let parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var parameters: [String: Any]? {
        nil
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
    
}

extension NewsApi: TargetType {
    var baseURL: URL {
        URL(string: "https://api.steampowered.com/")!
    }
    
    var path: String {
        return "/ISteamNews/GetNewsForApp/v2/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        guard let parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var parameters: [String: Any]? {
        var parameters = [String: Any]()
        switch self {
            case .getNewsFor(let id):
                parameters["appid"] = id
        }
        return parameters
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
    
}
