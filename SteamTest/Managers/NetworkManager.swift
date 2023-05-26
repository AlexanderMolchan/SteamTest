//
//  NetworkManager.swift
//  SteamTest
//
//  Created by Александр Молчан on 26.05.23.
//

import Foundation
import Moya

typealias ObjectBlock<T: Decodable> = ((T) -> Void)
typealias Failure = ((Error) -> Void)

final class NetworkManager {
    private let provider = MoyaProvider<ApiManager>(plugins: [NetworkLoggerPlugin()])
    
    func getGamesListData(success: ObjectBlock<ResultModel>?, failure: Failure?) {
        provider.request(.getAppsList) { result in
            switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(ResultModel.self, from: response.data)
                        success?(data)
                    } catch let error {
                        failure?(error)
                    }
                case .failure(let error):
                    failure?(error)
            }
        }
    }
    
    func getNewsForAppWith(id: Int, success: ObjectBlock<NewsResult>?, failure: Failure?) {
        provider.request(.getNewsFor(id: id)) { result in
            switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(NewsResult.self, from: response.data)
                        success?(data)
                    } catch let error {
                        failure?(error)
                    }
                case .failure(let error):
                    failure?(error)
            }
        }
    }
    
}
