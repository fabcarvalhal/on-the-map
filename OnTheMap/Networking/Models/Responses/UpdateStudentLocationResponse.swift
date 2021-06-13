//
//  UpdateStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import Foundation

struct UpdateStudnetLocationResponse: Codable {
    
    let updatedAt: Date
    
    enum CodingKeys: CodingKey {
        case updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(String.self, forKey: .updatedAt)
        let formatter = ISO8601DateFormatter()
        updatedAt = formatter.date(from: date) ?? Date()
    }
}
