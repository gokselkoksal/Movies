//
//  ForgotPasswordViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: UIViewController {
    
    var flow: ForgotPasswordFlow!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        view.backgroundColor = .white
    }
}

extension ForgotPasswordViewController {
    
    static func instantiate(with flow: ForgotPasswordFlow) -> ForgotPasswordViewController {
        let vc = ForgotPasswordViewController()
        vc.flow = flow
        return vc
    }
}
