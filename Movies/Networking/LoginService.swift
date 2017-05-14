//
//  LoginService.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct Credentials {
    let username: String?
    let password: String?
}

struct LoginResponse {
    var isPasswordExpired: Bool
}

protocol LoginService {
    func login(with credentials: Credentials, completion: @escaping (Result<LoginResponse>) -> Void)
}

// MARK: - Helpers

extension Credentials: Equatable {
    static func ==(a: Credentials, b: Credentials) -> Bool {
        return a.username == b.username && a.password == b.password
    }
}
