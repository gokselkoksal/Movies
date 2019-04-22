//
//  UIViewController+Helpers.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

protocol StoryboardInstantiatable {
  static var defaultStoryboardName: String { get }
  static var defaultStoryboardId: String { get }
  static func instantiate(storyboardName: String?, storyboardId: String?, bundle: Bundle?) -> Self
}

extension StoryboardInstantiatable where Self: UIViewController {
  
  static var defaultStoryboardId: String {
    return String(describing: self)
  }
  
  static func instantiate() -> Self {
    return instantiate(storyboardName: nil, storyboardId: nil, bundle: nil)
  }
  
  static func instantiate(storyboardName: String?, storyboardId: String?, bundle: Bundle?) -> Self {
    let storyboardName: String = storyboardName ?? defaultStoryboardName
    let storyboardId: String = storyboardId ?? defaultStoryboardId
    let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
      fatalError("Could not instantiate view controller with id \"\(storyboardId)\" from storyboard with name \"\(storyboardName)\".")
    }
    return viewController
  }
}

extension UIViewController {
  func embedInNavigationController() -> UINavigationController {
    return UINavigationController(rootViewController: self)
  }
}
