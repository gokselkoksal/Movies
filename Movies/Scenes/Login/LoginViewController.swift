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

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        bindViewModel()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.login(
            username: usernameField.text,
            password: passwordField.text
        )
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        router.perform(.forgotPassword, from: self)
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        router.perform(.signUp, from: self)
    }
}

private extension LoginViewController {
    
    func bindViewModel() {
        viewModel.actionHandler = { [weak self] action in
            guard let strongSelf = self else { return }
            switch action {
            case .loggedIn:
                strongSelf.router.perform(.login, from: strongSelf)
            }
        }
        viewModel.errorHandler = { error in
            print(error)
        }
    }
}
