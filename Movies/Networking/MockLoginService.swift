//
//  MockLoginService.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MockLoginService: LoginService {
    
    enum Error: Swift.Error {
        case invalidCredentials
        case couldNotConnect
    }
    
    let directLoginCredentials: Credentials = .directLogin
    let expiredPasswordCredentials: Credentials = .expiredPassword
    let delay: TimeInterval?
    let errorRate: Float
    
    init(delay: TimeInterval? = 1.5, errorRate: Float = 0.0) {
        self.delay = delay
        self.errorRate = errorRate
    }
    
    func login(with credentials: Credentials, completion: @escaping (Result<LoginResponse>) -> Void) {
        executeInMock(afterDelay: delay) { [weak self] in
            guard let strongSelf = self else { return }
            if randomizer.randomBool(withRate: strongSelf.errorRate) {
                completion(Result.failure(Error.couldNotConnect))
            } else {
                if credentials == strongSelf.directLoginCredentials {
                    completion(Result.success(LoginResponse(isPasswordExpired: false)))
                } else if credentials == strongSelf.expiredPasswordCredentials {
                    completion(Result.success(LoginResponse(isPasswordExpired: true)))
                } else {
                    completion(Result.failure(Error.invalidCredentials))
                }
            }
        }
    }
}
