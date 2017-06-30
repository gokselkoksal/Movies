//
//  LoginComponent.swift
//  Movies
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

// MARK: - Actions

enum LoginAction: Action {
    case addActivity
    case removeActivity
    case error(Error)
}

enum LoginNavigatorAction: NavigatorAction {
    case login(LoginResponse)
    case signUp
    case forgotPassword
}

// MARK: - Component

class LoginComponent: Component<LoginState> {
    
    let service: LoginService
    
    init(service: LoginService, state: LoginState, navigator: Navigator) {
        self.service = service
        super.init(state: state, navigator: navigator)
    }
    
    func loginCommand(with credentials: Credentials) -> LoginCommand {
        return LoginCommand(service: service, credentials: credentials)
    }
}

// MARK: - Commands

class LoginCommand: Command {
    
    let service: LoginService
    let credentials: Credentials
    
    init(service: LoginService, credentials: Credentials) {
        self.service = service
        self.credentials = credentials
    }
    
    func execute(on component: Component<LoginState>) {
        component.dispatch(LoginAction.addActivity)
        service.login(with: credentials) { (result) in
            component.dispatch(LoginAction.removeActivity)
            switch result {
            case .success(let response):
                component.dispatch(LoginNavigatorAction.login(response))
            case .failure(let error):
                component.dispatch(LoginAction.error(error))
            }
        }
    }
}
