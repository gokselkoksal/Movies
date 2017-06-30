//
//  LoginViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

final class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var component: LoginComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        let mockCredentials = Credentials.directLogin
        usernameField.text = mockCredentials.username
        passwordField.text = mockCredentials.password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        component.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if zap_isBeingRemoved {
            component.unsubscribe(self)
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let credentials = Credentials(username: usernameField.text, password: passwordField.text)
        core.dispatch(component.loginCommand(with: credentials))
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        core.dispatch(LoginNavigatorAction.forgotPassword)
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        core.dispatch(LoginNavigatorAction.signUp)
    }
}

extension LoginViewController {
    
    static func instantiate(with component: LoginComponent) -> LoginViewController {
        let sb = Storyboard.main
        let id = String(describing: self)
        let vc = sb.instantiateViewController(withIdentifier: id) as! LoginViewController
        vc.component = component
        return vc
    }
}

// MARK: - Updates

extension LoginViewController: Subscriber {
    
    func update(with state: LoginState) {
        state.changelog.forEach { (change) in
            switch change {
            case .loadingState:
                if state.loadingState.needsUpdate {
                    setLoading(state.loadingState.isActive)
                }
            case .error:
                if let error = state.error {
                    handle(error: error)
                }
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}
