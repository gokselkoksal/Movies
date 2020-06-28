//
//  MovieListView.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class MovieListView: MoviesAppContext {
  
  let tableView: ScrollableElement
  let logoutButton: XCUIElement
  let addButton: XCUIElement
  let spinnerView: XCUIElement
  
  init(app: MoviesApp) {
    self.tableView = ScrollableElement(app.tables["movieList.tableView.movies"])
    self.logoutButton = app.buttons["movieList.button.logout"]
    self.addButton = app.buttons["movieList.button.add"]
    self.spinnerView = app.otherElements["common.view.spinner"]
    super.init(app: app, stickyElements: logoutButton, addButton)
  }
}
