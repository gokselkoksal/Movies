//
//  MoviesStore.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

// MARK: - Coordinator

let coordinator: Coordinator = {
    let navigator = LoginNavigator()
    let loginComponent = LoginComponent(
        service: MockLoginService(),
        state: LoginState(),
        navigator: navigator
    )
    navigator.component = loginComponent
    return Coordinator(
        rootComponent: loginComponent,
        middlewares: [LoggerMiddleware()]
    )
}()

// MARK: - ViewComponent

protocol ViewComponent: NavigationPerformer { }

extension ViewComponent where Self: UIViewController {
    
    func perform(_ navigation: Navigation) {
        guard let navigation = navigation as? BasicNavigation else { return }
        switch navigation {
        case .push(let component, from: _):
            guard let vc = viewController(for: component) else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .pop(_):
            // TODO: Validate vc's component.
            navigationController?.popViewController(animated: true)
        case .present(let component, from: _):
            guard let vc = viewController(for: component) else { return }
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true, completion: nil)
        case .dismiss(_):
            // TODO: Validate vc's component.
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func viewController(for component: AnyComponent) -> UIViewController? {
        let vc: UIViewController?
        if let component = component as? LoginComponent {
            vc = LoginViewController.instantiate(with: component)
        } else if let component = component as? SignUpComponent {
            vc = SignUpViewController.instantiate(with: component)
        } else if let component = component as? ForgotPasswordComponent {
            vc = ForgotPasswordViewController.instantiate(with: component)
        } else if let component = component as? ChangePasswordComponent {
            vc = ChangePasswordViewController.instantiate(with: component)
        } else if let component = component as? MovieListComponent {
            vc = MovieListViewController.instantiate(with: component)
        } else {
            vc = nil
        }
        return vc
    }
}
