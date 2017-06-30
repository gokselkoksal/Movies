//
//  ForgotPasswordViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    var component: ForgotPasswordComponent!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        view.backgroundColor = .white
    }
}

extension ForgotPasswordViewController {
    
    static func instantiate(with component: ForgotPasswordComponent) -> ForgotPasswordViewController {
        let vc = ForgotPasswordViewController()
        vc.component = component
        return vc
    }
}
