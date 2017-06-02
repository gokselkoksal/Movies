//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class LoginNavigationResolver: NavigationResolver {
    
    weak var flow: LoginFlow?
    
    func resolve(_ intent: NavigationIntent) -> NavigationRequest? {
        guard let flow = flow, let intent = intent as? LoginNavigationIntent else { return nil }
        switch intent {
        case .signUp:
            let newFlow = SignUpFlow()
            return NavigationRequest.proceed(from: flow, to: newFlow)
        case .login(let response):
            if response.isPasswordExpired {
                let newFlow = ChangePasswordFlow()
                return NavigationRequest.proceed(from: flow, to: newFlow)
            } else {
                let newFlow = MovieListFlow(service: MockMoviesService(delay: 1.5))
                return NavigationRequest.proceed(from: flow, to: newFlow)
            }
        case .forgotPassword:
            let newFlow = ForgotPasswordFlow()
            return NavigationRequest.proceed(from: flow, to: newFlow)
        }
    }
}
