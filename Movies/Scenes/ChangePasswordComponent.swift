//
//  ChangePasswordComponent.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct ChangePasswordState: State { }

class ChangePasswordComponent: Component<ChangePasswordState> {
    
    convenience init() {
        self.init(state: ChangePasswordState())
    }
}
