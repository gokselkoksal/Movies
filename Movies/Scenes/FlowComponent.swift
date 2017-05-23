//
//  ViewCreator.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

protocol FlowComponent {
    func proceed(to flow: AnyFlow)
}

extension FlowComponent where Self: UIViewController {
    
    func proceed(to flow: AnyFlow) {
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
