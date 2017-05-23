//
//  SignUpViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    var flow: SignUpFlow!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .white
    }
}

extension SignUpViewController {
    
    static func instantiate(with flow: SignUpFlow) -> SignUpViewController {
        let vc = SignUpViewController()
        vc.flow = flow
        return vc
    }
}
