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
        let vc: UIViewController?
        
        switch navigation {
        case .stepForward(from: _, to: let to):
            if let flow = to as? LoginFlow {
                vc = LoginViewController.instantiate(with: flow)
            } else if let flow = to as? SignUpFlow {
                vc = SignUpViewController.instantiate(with: flow)
            } else if let flow = to as? ForgotPasswordFlow {
                vc = ForgotPasswordViewController.instantiate(with: flow)
            } else if let flow = to as? ChangePasswordFlow {
                vc = ChangePasswordViewController.instantiate(with: flow)
            } else if let flow = to as? MovieListFlow {
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
        case .stepBackward(from: let from):
            // TODO: Improve.
            if from is MovieListFlow {
                presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
}
