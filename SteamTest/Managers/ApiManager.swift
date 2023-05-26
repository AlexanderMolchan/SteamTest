//
//  ApiManager.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import Foundation
import Moya

enum ApiManager {
    case getAppsList
    case getNewsFor(id: Int)
}

extension ApiManager: TargetType {
    var baseURL: URL {
        URL(string: "https://api.steampowered.com/")!
    }
    
    var path: String {
        switch self {
            case .getAppsList:
                return "ISteamApps/GetAppList/v2/"
            case .getNewsFor:
                return "/ISteamNews/GetNewsForApp/v2/"
        }
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
            default: return nil
        }
        return parameters
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
    
}
