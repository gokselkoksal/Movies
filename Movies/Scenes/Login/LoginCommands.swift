//
//  LoginCommands.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

extension Credentials {
    static let directLogin = Credentials(username: "gokselkk", password: "123")
    static let expiredPassword = Credentials(username: "gokselkk", password: "asd")
}

class LoginCommand: Command {
    
    let service: LoginService
    let credentials: Credentials
    
    init(service: LoginService, credentials: Credentials) {
        self.service = service
        self.credentials = credentials
    }
    
    func execute(state: AppState, store: Store<AppState>) {
        store.fire(action: LoginAction.addActivity)
        service.login(with: credentials) { (result) in
            store.fire(action: LoginAction.removeActivity)
            switch result {
            case .success(let response):
                store.fire(reaction: LoginReaction.segue(.login(response)))
            case .failure(let error):
                store.fire(reaction: LoginReaction.error(error))
            }
        }
    }
}
