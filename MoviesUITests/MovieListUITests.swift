//
//  MovieListUITests.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

class MovieListUITests: XCTestCase {
  
  private var app: MoviesApp!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    app = MoviesApp()
    app.launch()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_listContent() throws {
    // GIVEN the user is logged in
    app.login()
    
    // WHEN the movie list loads
    app.movieListView.assertExistence(timeout: 5.0)
    
    // THEN expect "Fury 10" to be visible in the list
    let result = app.movieListView.tableView.findVisibleElement(direction: .down, retryLimit: 5) {
      $0.cells.containing(.staticText, identifier: "Fury 10")
    }
    let element = try XCTUnwrap(result, "Expected Fury 10 to be visible.")
    element.tap()
  }
}
