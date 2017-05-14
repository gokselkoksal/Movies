//
//  LoginState.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct LoginState {
    
    enum Change {
        case loadingState
    }
    
    var loadingState = ActivityTracker()
}

enum LoginAction: Action {
    case addActivity
    case removeActivity
}

enum LoginReaction: Reaction {
    
    enum Segue {
        case login(LoginResponse)
        case signUp
        case forgotPassword
    }
    
    case error(Error)
    case segue(Segue)
}

// MARK: - Reducer

extension LoginState: State {
    
    mutating func react(to action: Action) -> [Reaction] {
        guard let action = action as? LoginAction else { return [] }
        switch action {
        case .addActivity:
            loadingState.addActivity()
        case .removeActivity:
            loadingState.removeActivity()
        }
        return []
    }
    
    mutating func cleanUp() {
        self = LoginState()
    }
}

// MARK: - Helpers

extension LoginState.Change: Equatable {
    static func ==(a: LoginState.Change, b: LoginState.Change) -> Bool {
        switch (a, b) {
        case (.loadingState, .loadingState):
            return true
        }
    }
}
