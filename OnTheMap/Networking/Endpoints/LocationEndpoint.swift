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
    
    var baseUrl: String {
        "https://onthemap-api.udacity.com/v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .add:
            return .post
        }
    }
    
    var path: String {
        "/StudentLocation"
    }
    
    var headers: [String : String] {
        [:]
    }
}
