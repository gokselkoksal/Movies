//
//  LoginViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import Rasat

final class LoginViewController: UIViewController, StoryboardInstantiatable {
  
  static var defaultStoryboardName: String = "Main"
  
  var presenter: LoginPresenterProtocol!
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    configureAccessibilityIdentifiers()
  }
  
  private func configureAccessibilityIdentifiers() {
    usernameField.accessibilityIdentifier = "login.textField.username"
    passwordField.accessibilityIdentifier = "login.textField.password"
    loginButton.accessibilityIdentifier = "login.button.login"
    forgotPasswordButton.accessibilityIdentifier = "login.button.forgotPassword"
    signUpButton.accessibilityIdentifier = "login.button.signUp"
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    presenter.login(username: usernameField.text, password: passwordField.text)
  }
  
  @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    presenter.forgotPassword()
  }
  
  @IBAction func signUpTapped(_ sender: AnyObject) {
    presenter.signUp()
  }
}
