//
//  LoginUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol LoginViewInterface: class, ErrorHandler, FlowComponent {
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
        } else if let error = state.error {
            view.handle(error: error)
        }
    }
    
    func proceed(to nextFlow: AnyFlow) {
        view.proceed(to: nextFlow)
    }
}
