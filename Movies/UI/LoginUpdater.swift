//
//  LoginUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol LoginViewComponent: class, ErrorHandler, ViewComponent {
    func setLoading(_ isLoading: Bool)
}

class LoginUpdater: Subscriber {
    
    unowned let view: LoginViewComponent
    
    init(view: LoginViewComponent) {
        self.view = view
    }
    
    func update(with state: LoginState) {
        state.changelog.forEach { (change) in
            switch change {
            case .loadingState:
                if state.loadingState.needsUpdate {
                    view.setLoading(state.loadingState.isActive)
                }
            case .error:
                if let error = state.error {
                    view.handle(error: error)
                }
            }
        }
    }
    
    func perform(_ navigation: Navigation) {
        view.perform(navigation)
    }
}
