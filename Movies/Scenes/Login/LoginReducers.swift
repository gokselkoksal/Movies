//
//  LoginReducers.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

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
