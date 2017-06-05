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
    
    func resolve(_ action: NavigatorAction) -> Navigation? {
        guard let flow = flow, let action = action as? LoginNavigatorAction else { return nil }
        switch action {
        case .signUp:
            let newFlow = SignUpFlow()
            return Navigation.stepForward(from: flow, to: newFlow)
        case .login(let response):
            if response.isPasswordExpired {
                let newFlow = ChangePasswordFlow()
                return Navigation.stepForward(from: flow, to: newFlow)
            } else {
                let navigator = MovieListNavigator()
                let newFlow = MovieListFlow(service: MockMoviesService(delay: 1.5), navigator: navigator)
                navigator.flow = newFlow
                return Navigation.stepForward(from: flow, to: newFlow)
            }
        case .forgotPassword:
            let newFlow = ForgotPasswordFlow()
            return Navigation.stepForward(from: flow, to: newFlow)
        }
    }
}
