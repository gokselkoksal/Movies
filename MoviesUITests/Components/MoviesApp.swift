//
//  App.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class MoviesApp: XCUIApplication {
  private(set) lazy var loginView: LoginView = LoginView(app: self)
  private(set) lazy var movieListView: MovieListView = MovieListView(app: self)
  private(set) lazy var changePasswordView: ChangePasswordView = ChangePasswordView(app: self)
}

// MARK: - Helpers

class MoviesAppContext {
  
  let app: MoviesApp
  let stickyElements: [XCUIElement]
  
  init(app: MoviesApp, stickyElements: XCUIElement...) {
    self.app = app
    self.stickyElements = stickyElements
  }
  
  func assertExistence(timeout: TimeInterval, file: StaticString = #file, line: UInt = #line) {
    for element in stickyElements {
      XCTAssertTrue(element.waitForExistence(timeout: timeout), "Expected \(element) to exist.", file: file, line: line)
    }
  }
}

class MoviesUIElement {
  
  let app: MoviesApp
  let element: XCUIElement
  
  init(app: MoviesApp, element: XCUIElement) {
    self.app = app
    self.element = element
  }
}
