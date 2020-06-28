//
//  ScrollableElement.swift
//  MoviesUITests
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import XCTest

final class ScrollableElement: ElementWrapper {
  
  func findVisibleElement(direction: UIAccessibilityScrollDirection = .down, retryLimit: Int = 5, query buildQuery: (XCUIElement) -> XCUIElementQuery) -> XCUIElement? {
    let query = buildQuery(element)
    
    var retryCount = 0
    while query.element.isHittable == false, retryCount < retryLimit {
      element.scroll(direction)
      retryCount += 1
    }
    
    let result = query.element
    return result.isHittable ? result : nil
  }
}
