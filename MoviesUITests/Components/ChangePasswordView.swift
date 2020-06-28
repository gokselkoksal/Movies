//
//  ChangePasswordView.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class ChangePasswordView: MoviesAppContext {
  
  let nextButton: XCUIElement
  
  init(app: MoviesApp) {
    self.nextButton = app.buttons["dummy.button.next"]
    super.init(app: app, stickyElements: nextButton)
  }
}
