//
//  LoginViewModel.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

struct LoginState {
    var shouldChangePassword = false
}

class LoginViewModel {
    
    enum Const {
        static let username = "gokselkk"
        static let password = "123"
        static let expiredPassword = "qwe"
    }
    
    enum Exception: Error {
        case wrongCredentials
    }
    
    enum Action {
        case loggedIn
    }
    
    var state = LoginState()
    var actionHandler: ((Action) -> Void)?
    var errorHandler: ((Exception) -> Void)?
    
    func login(username: String?, password: String?) {
        guard let username = username, username == Const.username, let password = password else {
            errorHandler?(.wrongCredentials)
            return
        }
        switch password {
        case Const.password:
            state.shouldChangePassword = false
            actionHandler?(.loggedIn)
        case Const.expiredPassword:
            state.shouldChangePassword = true
            actionHandler?(.loggedIn)
        default:
            errorHandler?(.wrongCredentials)
        }
    }
}
