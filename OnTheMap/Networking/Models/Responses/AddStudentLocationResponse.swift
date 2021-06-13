//
//  AddStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

struct AddStudentLocationResponse: Codable {
    
    let createdAt: Date
    let objectId: String
    
    enum CodingKeys: CodingKey {
        case createdAt
        case objectId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(String.self, forKey: .createdAt)
        let formatter = ISO8601DateFormatter()
        createdAt = formatter.date(from: date) ?? Date()
        objectId = try container.decode(String.self, forKey: .objectId)
    }
}
