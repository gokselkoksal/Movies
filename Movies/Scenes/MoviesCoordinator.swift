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
    let resolver = LoginNavigationResolver()
    let loginFlow = LoginFlow(
        service: MockLoginService(),
        state: LoginState(),
        navigationResolver: resolver
    )
    resolver.flow = loginFlow
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
    
    func perform(_ request: NavigationRequest) {
        let flow = request.to
        
        let vc: UIViewController?
        if let flow = flow as? LoginFlow {
            vc = LoginViewController.instantiate(with: flow)
        } else if let flow = flow as? SignUpFlow {
            vc = SignUpViewController.instantiate(with: flow)
        } else if let flow = flow as? ForgotPasswordFlow {
            vc = ForgotPasswordViewController.instantiate(with: flow)
        } else if let flow = flow as? MovieListFlow {
            vc = MovieListViewController.instantiate(with: flow)
            let nc = UINavigationController(rootViewController: vc!)
            present(nc, animated: true, completion: nil)
            return
        } else {
            vc = nil
        }
        if let safeVC = vc {
            navigationController?.pushViewController(safeVC, animated: true)
        }
    }
}
