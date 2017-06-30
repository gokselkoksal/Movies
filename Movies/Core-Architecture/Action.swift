//
//  Action.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol Action { }

protocol NavigatorAction: Action { }

protocol Command {
    associatedtype StateType: State
    func execute(on component: Component<StateType>, core: Core)
}
