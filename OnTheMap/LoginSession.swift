//
//  LoginSession.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

final class UdacitySession {
    
    private var session: UdacitySession? 
    
    static let current: UdacitySession? = UdacitySession()
    
    private init() {}
    
    func set(_ session: UdacitySession) {
        self.session = session
    }
    
    func get() -> UdacitySession? {
        session
    }
}
