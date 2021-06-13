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
    
    var baseUrl: String {
        "https://onthemap-api.udacity.com/v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .getUserData:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create:
            return "/session"
        case .getUserData(let userId):
            return "/users/\(userId)"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .create:
            return [HTTPHeaderField.accept.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        default:
            return [:]
        }
    }
}
