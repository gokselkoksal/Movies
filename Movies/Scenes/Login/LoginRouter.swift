//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol LoginRouter {
    func perform(segue: LoginReaction.Segue)
}

class DefaultLoginRouter: LoginRouter {
    
    unowned var source: UIViewController
    
    init(source: UIViewController) {
        self.source = source
    }
    
    func perform(segue: LoginReaction.Segue) {
        switch segue {
        case .login(let response):
            if response.isPasswordExpired {
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
    
    // TODO: Reduxify
    
    static func makeMoviesViewController() -> UINavigationController {
        let vc = MovieListViewController.instantiate()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func makeDummyViewController(withTitle title: String) -> DummyViewController {
        let vc = DummyViewController()
        let router = DestinationMovieListRouter(source: vc)
        vc.title = title
        vc.dependencies = DummyViewController.Depedencies(router: router)
        return vc
    }
    
    class DestinationMovieListRouter: DummyRouter {
        
        unowned let source: UIViewController
        
        init(source: UIViewController) {
            self.source = source
        }
        
        func perform(segue: DummySegue) {
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
}
