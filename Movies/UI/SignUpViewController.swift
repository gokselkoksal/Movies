//
//  SignUpViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

final class SignUpViewController: BaseViewController {
    
    var component: SignUpComponent!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .white
    }
}

extension SignUpViewController {
    
    static func instantiate(with component: SignUpComponent) -> SignUpViewController {
        let vc = SignUpViewController()
        vc.component = component
        return vc
    }
}
