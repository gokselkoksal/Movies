//
//  LoginViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum Route: String {
        case login
        case forgotPassword
        case signUp
    }
    
    var router: LoginRouter!
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        router.perform(.login, from: self)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        router.perform(.forgotPassword, from: self)
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        router.perform(.signUp, from: self)
    }
}
