//
//  NetworkManager.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Moya
import Alamofire

public typealias NetworkProvider = MoyaProvider
enum NetworkRouter {
    case getData(resourceId: String, limit: Int, query: String)
}
extension NetworkRouter: TargetType {
    var baseURL: URL { return URL(string: "https://data.gov.sg/api/action/")! }
    var path: String {
        switch self {
        case .getData:
            return "datastore_search"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getData:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .getData(resourceId, limit, query):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["resource_id": resourceId, "limit": limit, "q": query], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .getData(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".data(using: String.Encoding.utf8)!
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
struct AppProvider {
    static let networkManager: NetworkProvider<NetworkRouter> = {
        return MoyaProvider<NetworkRouter>(endpointClosure: networkEndPointClousure, manager: DefaultAlamofireManager.sharedManager)
    }()
}
var networkEndPointClousure = { (target: NetworkRouter) -> Endpoint in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}
class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy
        let instance = DefaultAlamofireManager (
            configuration: configuration
        )
        return instance
    }()
}

