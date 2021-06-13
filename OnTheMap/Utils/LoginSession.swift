//
//  LoginSession.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

struct UserDataSession {
    
    let firstName: String
    let lastName: String
}

final class LoginSession {
    
    private var session: UserDataSession?
    
    static let current: LoginSession? = LoginSession()
    
    private init() {}
    
    func set(_ session: UserDataSession) {
        self.session = session
    }
    
    func get() -> UserDataSession? {
        session
    }
}
