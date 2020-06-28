//
//  XCUIElement+Helpers.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

extension XCUIElement {
  func tapAndTypeText(_ text: String) {
    tap()
    typeText(text)
  }
}

extension XCUIElement {
  func scroll(_ direction: UIAccessibilityScrollDirection) {
    switch direction {
    case .up:
      swipeDown()
    case .down:
      swipeUp()
    case .left:
      swipeRight()
    case .right:
      swipeLeft()
    case .next, .previous:
      fatalError("Scroll direction \(direction) is not supported.")
    @unknown default:
      fatalError("Scroll direction \(direction) is not supported.")
    }
  }
}
