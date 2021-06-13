//
//  StudenLocationRequest.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import Foundation

struct StudentLocationRequest: DictionaryConvertible {
    
    let limit: Int
    let skip: Int
    let order: String
    let userId: String
}
