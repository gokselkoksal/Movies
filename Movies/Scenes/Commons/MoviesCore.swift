//
//  MoviesCore.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

let core: Core = {
    let navigator = LoginNavigator()
    let loginComponent = LoginComponent(
        service: MockLoginService(),
        state: LoginState(),
        navigator: navigator
    )
    navigator.component = loginComponent
    return Core(
        rootComponent: loginComponent,
        middlewares: [LoggerMiddleware()]
    )
}()
