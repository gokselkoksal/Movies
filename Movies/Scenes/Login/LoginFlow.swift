//
//  LoginFlow.swift
//  Movies
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class LoginFlow: Flow<LoginState> {
    
    let service: LoginService
    
    init(service: LoginService, state: LoginState, router: Router) {
        self.service = service
        super.init(state: state, router: router)
    }
    
    func loginCommand(with credentials: Credentials) -> LoginCommand {
        return LoginCommand(service: service, credentials: credentials)
    }
}
