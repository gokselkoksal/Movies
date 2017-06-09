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
    let loginFlow = LoginFlow(
        service: MockLoginService(),
        state: LoginState(),
        navigator: navigator
    )
    navigator.flow = loginFlow
    return Coordinator(rootFlow: loginFlow)
}()

// MARK: - Flow IDs

enum MoviesFlowID: FlowID {
    case login
    case forgotPassword
    case changePassword
    case signUp
    case movieList
}

// MARK: - ViewComponent

protocol ViewComponent: NavigationPerformer { }

extension ViewComponent where Self: UIViewController {
    
    func perform(_ navigation: Navigation) {
        guard let navigation = navigation as? BasicNavigation else { return }
        switch navigation {
        case .push(let flow, from: _):
            guard let vc = viewController(for: flow) else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .pop(_):
            // TODO: Validate vc's flow.
            
            navigationController?.popViewController(animated: true)
        case .present(let flow, from: _):
            guard let vc = viewController(for: flow) else { return }
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true, completion: nil)
        case .dismiss(_):
            // TODO: Validate vc's flow.
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func viewController(for flow: AnyFlow) -> UIViewController? {
        let vc: UIViewController?
        if let flow = flow as? LoginFlow {
            vc = LoginViewController.instantiate(with: flow)
        } else if let flow = flow as? SignUpFlow {
            vc = SignUpViewController.instantiate(with: flow)
        } else if let flow = flow as? ForgotPasswordFlow {
            vc = ForgotPasswordViewController.instantiate(with: flow)
        } else if let flow = flow as? ChangePasswordFlow {
            vc = ChangePasswordViewController.instantiate(with: flow)
        } else if let flow = flow as? MovieListFlow {
            vc = MovieListViewController.instantiate(with: flow)
        } else {
            vc = nil
        }
        return vc
    }
}
