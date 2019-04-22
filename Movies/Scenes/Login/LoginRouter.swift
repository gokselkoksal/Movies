//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import MoviesCore

enum LoginDestination {
  case movieList
  case changePassword
  case signUp
}

protocol LoginRouterProtocol: class {
  func route(to destination: LoginDestination)
}

// MARK: - Implementation

class LoginRouter: LoginRouterProtocol {
  
  private unowned let context: UIViewController
  
  init(context: UIViewController) {
    self.context = context
  }
  
  func route(to destination: LoginDestination) {
    switch destination {
    case .movieList:
      let vc = MovieListSceneBuilder.build()
      context.present(vc.embedInNavigationController(), animated: true, completion: nil)
    case .changePassword:
      let vc = ChangePasswordSceneBuilder.build()
      context.navigationController?.pushViewController(vc, animated: true)
    case .signUp:
      let vc = SignUpSceneBuilder.build()
      context.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
