//
//  MoviesStore.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

let coordinator: Coordinator = {
    let loginFlow = LoginFlow(
        service: MockLoginService(),
        state: LoginState(),
        router: LoginRouter()
    )
    return Coordinator(rootFlow: loginFlow)
}()
