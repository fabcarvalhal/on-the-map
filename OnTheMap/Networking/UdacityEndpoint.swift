//
//  UdacityEndpoint.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import Foundation

enum UdacityEndpoint: Endpoint {
    
    case createSession
    
    var baseUrl: String {
        switch self {
        case .createSession:
            return "https://onthemap-api.udacity.com/v1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createSession:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createSession:
            return "/session"
        }
    }
    
    var headers: [String : String] {
        [HTTPHeaderField.accept.rawValue: ContentType.json.rawValue,
         HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
    }
}
