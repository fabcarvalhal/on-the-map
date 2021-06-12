//
//  LoginSession.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

final class LoginSession {
    
    private var session: UdacitySessionResponse?
    
    static let current: LoginSession? = LoginSession()
    
    private init() {}
    
    func set(_ session: UdacitySessionResponse) {
        self.session = session
    }
    
    func get() -> UdacitySessionResponse? {
        session
    }
}
