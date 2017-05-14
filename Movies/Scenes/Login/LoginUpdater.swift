//
//  LoginUpdater.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol LoginNavigator {
    func perform(segue: LoginReaction.Segue)
}

protocol LoginViewInterface: class, ErrorHandler {
    var navigator: LoginNavigator! { get }
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
            view.navigator.perform(segue: segue)
        case .error(let error):
            view.handle(error: error)
        }
    }
}

class DefaultLoginNavigator: LoginNavigator {
    
    unowned var source: UIViewController
    
    init(source: UIViewController) {
        self.source = source
    }
    
    func perform(segue: LoginReaction.Segue) {
        switch segue {
        case .login(let response):
            if response.isPasswordExpired {
                let vc = DefaultLoginNavigator.makeDummyViewController(withTitle: "Change Password")
                source.navigationController?.pushViewController(vc, animated: true)
            } else {
                let nc = DefaultLoginNavigator.makeMoviesViewController()
                weak var weakSource = source
                source.present(nc, animated: true) {
                    _ = weakSource?.navigationController?.popToRootViewController(animated: false)
                }
            }
        case .forgotPassword:
            let vc = DefaultLoginNavigator.makeDummyViewController(withTitle: "Forgot Password")
            source.navigationController?.pushViewController(vc, animated: true)
            
        case .signUp:
            let vc = DefaultLoginNavigator.makeDummyViewController(withTitle: "Sign Up")
            source.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // TODO: Reduxify
    
    class DestinationMoviesRouter: DummyRouter {
        func perform(_ segue: DummySegue, from source: DummyViewController) {
            switch segue {
            case .next:
                let nc = DefaultLoginNavigator.makeMoviesViewController()
                weak var weakSource = source
                source.present(nc, animated: true) {
                    _ = weakSource?.navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }
    
    static func makeMoviesViewController() -> UINavigationController {
        let vc = MovieListViewController.instantiate()
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
