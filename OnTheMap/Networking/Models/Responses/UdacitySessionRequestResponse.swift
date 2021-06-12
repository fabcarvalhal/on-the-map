//
//  UdacitySessionRequestResponse.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

struct UdacitySessionResponse: Codable {
    
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    
    let id: String
    let expiration: String
}
