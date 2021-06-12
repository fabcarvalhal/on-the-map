//
//  LocationEndpoint.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

enum LocationEndpoint: Endpoint {
    
    case list
    
    var baseUrl: String {
        switch self {
        case .list:
            return "https://onthemap-api.udacity.com/v1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/StudentLocation"
        }
    }
    
    var headers: [String : String] {
        [:]
    }
}
