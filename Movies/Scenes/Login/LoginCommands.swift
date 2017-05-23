//
//  LoginCommands.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

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
                flow.dispatch(LoginSegue.login(response))
            case .failure(let error):
                flow.dispatch(LoginAction.error(error))
            }
        }
    }
}
