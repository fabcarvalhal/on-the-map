//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    let results: [StudentLocationResponseItem]?
}

struct StudentLocationResponseItem: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
