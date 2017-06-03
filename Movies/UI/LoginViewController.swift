//
//  LoginViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var flow: LoginFlow!
    
    private var updater: LoginUpdater!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        let mockCredentials = Credentials.directLogin
        usernameField.text = mockCredentials.username
        passwordField.text = mockCredentials.password
        updater = LoginUpdater(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flow.subscribe(updater)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if zap_isBeingRemoved {
            flow.unsubscribe(updater)
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let credentials = Credentials(username: usernameField.text, password: passwordField.text)
        flow.dispatch(flow.loginCommand(with: credentials))
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        flow.dispatch(LoginNavigatorAction.forgotPassword)
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        flow.dispatch(LoginNavigatorAction.signUp)
    }
}

extension LoginViewController: LoginViewComponent {
    
    func setLoading(_ isLoading: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}

extension LoginViewController {
    
    static func instantiate(with flow: LoginFlow) -> LoginViewController {
        let sb = Storyboard.main
        let id = String(describing: self)
        let vc = sb.instantiateViewController(withIdentifier: id) as! LoginViewController
        vc.flow = flow
        return vc
    }
}
