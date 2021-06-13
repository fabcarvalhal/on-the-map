//
//  UdacityEndpoint.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import Foundation

enum UdacitySessionEndpoint: Endpoint {
    
    case create
    case getUserData(userId: String)
    case logout
    
    var baseUrl: String {
        "https://onthemap-api.udacity.com/v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .getUserData:
            return .get
        case .logout:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .create, .logout:
            return "/session"
        case .getUserData(let userId):
            return "/users/\(userId)"
        }
    }
    
    var headers: [String : Any] {
        switch self {
        case .create:
            return [HTTPHeaderField.accept.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        case .logout:
            let cookieStorage = HTTPCookieStorage.shared
            let cookie = cookieStorage.cookies?.filter { $0.name == "XSRF-TOKEN" }.first?.value ?? String()
            return [HTTPHeaderField.xsrfToken.rawValue: cookie]
        default:
            return [:]
        }
    }
}
