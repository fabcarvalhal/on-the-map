//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import Foundation

struct LogoutResponse: Codable {
    
    let session: SessionLogout
}

struct SessionLogout: Codable {
    
    let id: String
    let expiration: String
}
