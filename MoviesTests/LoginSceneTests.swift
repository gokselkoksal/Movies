//
//  LoginSceneTests.swift
//  MoviesTests
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import XCTest
@testable import Movies

class LoginSceneTests: XCTestCase {
  
  private var dataController: LoginDataController!
  private var presenter: LoginPresenter!
  private var router: MockLoginRouter!
  private var outputRecorder: ObservableRecorder<LoginOutput>!
  
  private var outputs: [LoginOutput] {
    return outputRecorder.values
  }
  
  private var state: LoginState {
    return dataController.state
  }
  
  override func setUp() {
    router = MockLoginRouter()
    dataController = LoginDataController()
    presenter = LoginPresenter(dataController: dataController, router: router)
    outputRecorder = ObservableRecorder(observable: dataController.observable)
  }
  
  func testLogin_success() {
    // when:
    presenter.login(username: "gokselkk", password: "123")
    // then:
    XCTAssertEqual(outputs, [.change(.loggedIn)])
    XCTAssertEqual(state.shouldChangePassword, false)
    XCTAssertEqual(router.latestDestination, .movieList)
  }
  
  func testLogin_expired() {
    // when:
    presenter.login(username: "gokselkk", password: "qwe")
    // then:
    XCTAssertEqual(outputs, [.change(.loggedIn)])
    XCTAssertEqual(state.shouldChangePassword, true)
    XCTAssertEqual(router.latestDestination, .changePassword)
  }
  
  func testLogin_error() {
    // when:
    presenter.login(username: "x", password: "y")
    // then:
    XCTAssertEqual(outputs, [.error(.wrongCredentials)])
    XCTAssertEqual(router.latestDestination, nil)
  }
  
  func testSignUp() {
    // when:
    presenter.forgotPassword()
    // then:
    XCTAssertEqual(outputs.count, 0)
    XCTAssertEqual(router.latestDestination, .changePassword)
  }
  
  func testForgotPassword() {
    // when:
    presenter.forgotPassword()
    // then:
    XCTAssertEqual(outputs.count, 0)
    XCTAssertEqual(router.latestDestination, .changePassword)
  }
}

private final class MockLoginRouter: LoginRouterProtocol {
  
  var latestDestination: LoginDestination?
  
  func route(to destination: LoginDestination) {
    latestDestination = destination
  }
}
