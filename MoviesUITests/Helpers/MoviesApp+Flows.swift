//
//  MoviesApp+Flows.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

extension MoviesApp {
  func login(file: StaticString = #file, line: UInt = #line) {
    // WHEN the user logs in with the correct credentials
    loginView.assertExistence(timeout: 5.0, file: file, line: line)
    loginView.usernameField.tapAndTypeText("gokselkk")
    loginView.passwordField.tapAndTypeText("123")
    loginView.loginButton.tap()
  }
}
