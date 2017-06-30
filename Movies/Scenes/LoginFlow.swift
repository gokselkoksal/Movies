//
//  LoginFlow.swift
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

// MARK: - Flow

class LoginFlow: Flow<LoginState> {
    
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
    
    func execute(on flow: Flow<LoginState>, coordinator: Coordinator) {
        flow.dispatch(LoginAction.addActivity)
        service.login(with: credentials) { (result) in
            flow.dispatch(LoginAction.removeActivity)
            switch result {
            case .success(let response):
                flow.dispatch(LoginNavigatorAction.login(response))
            case .failure(let error):
                flow.dispatch(LoginAction.error(error))
            }
        }
    }
}
