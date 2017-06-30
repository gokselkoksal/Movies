//
//  ForgotPasswordComponent.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct ForgotPasswordState: State {
    func react(to action: Action) { }
}

class ForgotPasswordComponent: Component<ForgotPasswordState> {
    
    convenience init() {
        self.init(state: ForgotPasswordState())
    }
}
