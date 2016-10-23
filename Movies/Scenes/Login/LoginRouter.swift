//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

class LoginRouter: Router {
    
    unowned let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    func route<T : RawRepresentable>(
        to route: T,
        from source: UIViewController)
        -> UIViewController?
    {
        guard let route = route as? LoginViewController.Route else {
            return nil
        }
        switch route {
        case .login:
            if viewModel.shouldChangePassword {
                let vc = LoginRouter.makeDummyViewController(withTitle: "Change Password")
                source.navigationController?.pushViewController(vc, animated: true)
                return vc
            } else {
                let nc = LoginRouter.makeMoviesViewController()
                source.present(nc, animated: true, completion: nil)
                return nc.viewControllers.first!
            }
            
        case .forgotPassword:
            let vc = LoginRouter.makeDummyViewController(withTitle: "Forgot Password")
            source.navigationController?.pushViewController(vc, animated: true)
            return vc
            
        case .signUp:
            let vc = LoginRouter.makeDummyViewController(withTitle: "Sign Up")
            source.navigationController?.pushViewController(vc, animated: true)
            return vc
        }
    }
}

// MARK: Helpers

private extension LoginRouter {
    
    class DestinationMoviesRouter: Router {
        func route<T : RawRepresentable>(to route: T, from source: UIViewController) -> UIViewController? {
            guard let route = route as? DummyViewController.Route else {
                return nil
            }
            switch route {
            case .next:
                let nc = LoginRouter.makeMoviesViewController()
                source.present(nc, animated: true, completion: nil)
                return nc.viewControllers.first!
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
