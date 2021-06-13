//
//  LocationEndpoint.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

enum LocationEndpoint: Endpoint {
    
    case list
    case add
    case update(id: String)
    
    var baseUrl: String {
        "https://onthemap-api.udacity.com/v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .add:
            return .post
        case .update:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .update(let id):
            return "/StudentLocation/\(id)"
        default:
            return "/StudentLocation"
        }
    }
    
    var headers: [String : Any] {
        return [HTTPHeaderField.accept.rawValue: ContentType.json.rawValue,
                HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
    }
}
