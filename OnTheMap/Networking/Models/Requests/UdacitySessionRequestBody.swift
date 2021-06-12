//
//  UdacityRequestBody.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

struct UdacitySessionRequestBody: Codable {
    
    let udacity: UdacityLoginInfo
}

struct UdacityLoginInfo: Codable {
    
    let username: String
    let password: String
}
