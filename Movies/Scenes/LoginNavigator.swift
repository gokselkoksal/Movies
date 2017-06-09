//
//  LoginNavigator.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class LoginNavigator: Navigator {
    
    weak var flow: LoginFlow?
    
    func resolve(_ action: NavigatorAction) -> Navigation? {
        guard let flow = flow, let action = action as? LoginNavigatorAction else { return nil }
        switch action {
        case .signUp:
            let newFlow = SignUpFlow()
            return BasicNavigation.push(newFlow, from: flow)
        case .login(let response):
            if response.isPasswordExpired {
                let newFlow = ChangePasswordFlow()
                return BasicNavigation.push(newFlow, from: flow)
            } else {
                let navigator = MovieListNavigator()
                let newFlow = MovieListFlow(service: MockMoviesService(delay: 1.5), navigator: navigator)
                navigator.flow = newFlow
                return BasicNavigation.present(newFlow, from: flow)
            }
        case .forgotPassword:
            let newFlow = ForgotPasswordFlow()
            return BasicNavigation.push(newFlow, from: flow)
        }
    }
}
