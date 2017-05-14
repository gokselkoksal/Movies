//
//  MockCredentials.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

extension Credentials {
    static let directLogin = Credentials(username: "gokselkk", password: "123")
    static let expiredPassword = Credentials(username: "gokselkk", password: "asd")
}
