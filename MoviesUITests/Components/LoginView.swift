//
//  LoginView.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class LoginView: MoviesAppContext {
  
  let usernameField: XCUIElement
  let passwordField: XCUIElement
  let loginButton: XCUIElement
  
  init(app: MoviesApp) {
    usernameField = app.textFields["login.textField.username"]
    passwordField = app.textFields["login.textField.password"]
    loginButton = app.buttons["login.button.login"]
    super.init(app: app, stickyElements: usernameField, passwordField, loginButton)
  }
}
