//
//  MovieListRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 28.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

enum MovieListDestination {
  case login
}

protocol MovieListRouterProtocol {
  func route(to destination: MovieListDestination)
}

// MARK: - Implementation

final class MovieListRouter: MovieListRouterProtocol {
  
  weak var context: UIViewController?
  
  init(context: UIViewController? = nil) {
    self.context = context
  }
  
  func route(to destination: MovieListDestination) {
    switch destination {
    case .login:
      let view = LoginViewController.instantiate()
      context?.navigationController?.setViewControllers([view], animated: false)
    }
  }
}
