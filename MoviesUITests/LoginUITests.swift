//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class LoginUITests: XCTestCase {
  
  private var app: MoviesApp!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    app = MoviesApp()
    app.launch()
  }
  
  func test_login_successful() throws {
    // WHEN the user logs in with the correct credentials
    app.loginView.assertExistence(timeout: 5.0)
    app.loginView.usernameField.tapAndTypeText("gokselkk")
    app.loginView.passwordField.tapAndTypeText("123")
    app.loginView.loginButton.tap()
    
    // THEN expect movie list view to appear
    app.movieListView.assertExistence(timeout: 5.0)
  }
  
  func test_login_expired() throws {
    // WHEN the user logs in with expired credentials
    app.loginView.assertExistence(timeout: 5.0)
    app.loginView.usernameField.tapAndTypeText("gokselkk")
    app.loginView.passwordField.tapAndTypeText("qwe")
    app.loginView.loginButton.tap()
    
    // THEN expect change-password view to appear
    app.changePasswordView.assertExistence(timeout: 5.0)
    
    // WHEN the user successfully changes the password
    app.changePasswordView.nextButton.tap()
    
    // THEN expect movie listView to appear
    app.movieListView.assertExistence(timeout: 5.0)
  }
}
