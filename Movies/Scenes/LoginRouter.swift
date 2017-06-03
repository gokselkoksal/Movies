//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class LoginNavigator: Navigator {
    
    weak var flow: LoginFlow?
    
    func resolve(_ intent: NavigatorAction) -> Navigation? {
        guard let flow = flow, let intent = intent as? LoginNavigatorAction else { return nil }
        switch intent {
        case .signUp:
            let newFlow = SignUpFlow()
            return Navigation.proceed(from: flow, to: newFlow)
        case .login(let response):
            if response.isPasswordExpired {
                let newFlow = ChangePasswordFlow()
                return Navigation.proceed(from: flow, to: newFlow)
            } else {
                let newFlow = MovieListFlow(service: MockMoviesService(delay: 1.5))
                return Navigation.proceed(from: flow, to: newFlow)
            }
        case .forgotPassword:
            let newFlow = ForgotPasswordFlow()
            return Navigation.proceed(from: flow, to: newFlow)
        }
    }
}
