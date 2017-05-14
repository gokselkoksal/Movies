//
//  LoginUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol LoginViewInterface: class, ErrorHandler {
    var router: LoginRouter! { get }
    func setLoading(_ isLoading: Bool)
}

class LoginUpdater: Subscriber {
    
    unowned let view: LoginViewInterface
    
    init(view: LoginViewInterface) {
        self.view = view
    }
    
    func update(with state: LoginState) {
        if state.loadingState.needsUpdate {
            view.setLoading(state.loadingState.isActive)
        }
    }
    
    func handle(reactions: [LoginReaction]) {
        reactions.forEach { handle(reaction: $0) }
    }
    
    private func handle(reaction: LoginReaction) {
        switch reaction {
        case .segue(let segue):
            view.router.perform(segue: segue)
        case .error(let error):
            view.handle(error: error)
        }
    }
}
