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
    let navigator: Navigator
    
    init(service: LoginService, state: LoginState, navigator: Navigator) {
        self.service = service
        self.navigator = navigator
        super.init(state: state)
    }
    
    func loginCommand(with credentials: Credentials) -> LoginCommand {
        return LoginCommand(service: service, credentials: credentials)
    }
    
    override func process(_ action: Action) {
        if let navigation = navigator.resolve(action) {
            commit(navigation)
        } else {
            var state = self.state
            state.react(to: action)
            commit(state)
        }
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
    
    func execute(on component: Component<LoginState>, core: Coordinator) {
        core.dispatch(LoginAction.addActivity)
        service.login(with: credentials) { (result) in
            core.dispatch(LoginAction.removeActivity)
            switch result {
            case .success(let response):
                core.dispatch(LoginNavigatorAction.login(response))
            case .failure(let error):
                core.dispatch(LoginAction.error(error))
            }
        }
    }
}
