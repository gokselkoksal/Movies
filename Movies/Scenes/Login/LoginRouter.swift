//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class LoginRouter: Router {
    
    func perform(_ segue: Segue) -> AnyFlow? {
        guard let segue = segue as? LoginSegue else { return nil }
        switch segue {
        case .signUp:
            return SignUpFlow()
        case .login(let response):
            if response.isPasswordExpired {
                return ChangePasswordFlow()
            } else {
                return MovieListFlow(service: MockMoviesService(delay: 1.5))
            }
        case .forgotPassword:
            return ForgotPasswordFlow()
        }
    }
}
