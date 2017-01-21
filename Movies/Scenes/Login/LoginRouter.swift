//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

enum LoginSegue {
    case login
    case forgotPassword
    case signUp
}

protocol LoginRouter {
    func perform(_ segue: LoginSegue, from source: LoginViewController)
}

class DefaultLoginRouter: LoginRouter {
    
    func perform(_ segue: LoginSegue, from source: LoginViewController) {
        switch segue {
        case .login:
            if source.viewModel.state.shouldChangePassword {
                let vc = DefaultLoginRouter.makeDummyViewController(withTitle: "Change Password")
                source.navigationController?.pushViewController(vc, animated: true)
            } else {
                let nc = DefaultLoginRouter.makeMoviesViewController()
                weak var weakSource = source
                source.present(nc, animated: true) {
                    _ = weakSource?.navigationController?.popToRootViewController(animated: false)
                }
            }
            
        case .forgotPassword:
            let vc = DefaultLoginRouter.makeDummyViewController(withTitle: "Forgot Password")
            source.navigationController?.pushViewController(vc, animated: true)
        case .signUp:
            let vc = DefaultLoginRouter.makeDummyViewController(withTitle: "Sign Up")
            source.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Helpers

private extension DefaultLoginRouter {
    
    class DestinationMoviesRouter: DummyRouter {
        func perform(_ segue: DummySegue, from source: DummyViewController) {
            switch segue {
            case .next:
                let nc = DefaultLoginRouter.makeMoviesViewController()
                weak var weakSource = source
                source.present(nc, animated: true) {
                    _ = weakSource?.navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }
    
    static func makeMoviesViewController() -> UINavigationController {
        let vc = MoviesViewController.instantiate()
        vc.viewModel = MoviesViewModel()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func makeDummyViewController(withTitle title: String) -> DummyViewController {
        let vc = DummyViewController()
        vc.title = title
        vc.router = DestinationMoviesRouter()
        return vc
    }
}
