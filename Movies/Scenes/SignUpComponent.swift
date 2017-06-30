//
//  SignUpComponent.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct SignUpState: State { }

class SignUpComponent: Component<SignUpState> {
    
    convenience init() {
        self.init(state: SignUpState())
    }
}
