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
        case error
    }
    
    var loadingState = ActivityTracker()
    var error: Error?
    var changelog: [Change] = []
}

// MARK: - Reducer

extension LoginState: State {
    
    mutating func react(to action: Action) {
        guard let action = action as? LoginAction else { return }
        switch action {
        case .addActivity:
            loadingState.addActivity()
            changelog = [.loadingState]
        case .removeActivity:
            loadingState.removeActivity()
            changelog = [.loadingState]
        case .error(let error):
            self.error = error
            changelog = [.error]
        }
    }
}

// MARK: - Helpers

extension LoginState.Change: Equatable {
    static func ==(a: LoginState.Change, b: LoginState.Change) -> Bool {
        switch (a, b) {
        case (.loadingState, .loadingState):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
