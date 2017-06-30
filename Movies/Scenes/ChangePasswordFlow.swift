//
//  ChangePasswordFlow.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct ChangePasswordState: State {
    func react(to action: Action) { }
}

class ChangePasswordFlow: Flow<ChangePasswordState> {
    
    convenience init() {
        self.init(state: ChangePasswordState())
    }
}
