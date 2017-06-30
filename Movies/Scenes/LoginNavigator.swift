//
//  LoginNavigator.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class LoginNavigator: Navigator {
    
    weak var component: LoginComponent?
    
    func resolve(_ action: NavigatorAction) -> Navigation? {
        guard let component = component, let action = action as? LoginNavigatorAction else { return nil }
        switch action {
        case .signUp:
            let newComponent = SignUpComponent()
            return BasicNavigation.push(newComponent, from: component)
        case .login(let response):
            if response.isPasswordExpired {
                let newComponent = ChangePasswordComponent()
                return BasicNavigation.push(newComponent, from: component)
            } else {
                let navigator = MovieListNavigator()
                let newComponent = MovieListComponent(service: MockMoviesService(delay: 1.5), navigator: navigator)
                navigator.component = newComponent
                return BasicNavigation.present(newComponent, from: component)
            }
        case .forgotPassword:
            let newComponent = ForgotPasswordComponent()
            return BasicNavigation.push(newComponent, from: component)
        }
    }
}
