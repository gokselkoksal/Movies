//
//  LoginViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Dependencies {
        let store: Store<AppState>
        let service: LoginService
        let navigator: LoginNavigator
    }

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var dependencies: Dependencies!
    
    var store: Store<AppState> {
        return dependencies.store
    }
    
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
        store.add(
            subscriber: updater,
            selector: { $0.loginState },
            cleanUp: { (state) in
                var state = state
                state.loginState.cleanUp()
                return state
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if zap_isBeingRemoved {
            store.remove(subscriber: updater)
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let credentials = Credentials(username: usernameField.text, password: passwordField.text)
        store.fire(command: LoginCommand(service: dependencies.service, credentials: credentials))
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        store.fire(reaction: LoginReaction.segue(.forgotPassword))
    }
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        store.fire(reaction: LoginReaction.segue(.signUp))
    }
}

extension LoginViewController: LoginViewInterface {
    
    var navigator: LoginNavigator! {
        return dependencies.navigator
    }
    
    func setLoading(_ isLoading: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}
