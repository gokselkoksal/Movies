//
//  LoginRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit
import MoviesCore

enum LoginSegue {
  case login
  case forgotPassword
  case signUp
}

protocol LoginRouterProtocol: class {
  var dataSource: LoginRouterDataSource? { get set }
  func perform(_ segue: LoginSegue)
}

protocol LoginRouterDataSource: class {
  func loginRouterShouldChangePassword() -> Bool
}

// MARK: - Implementation

class LoginRouter: LoginRouterProtocol {
  
  weak var dataSource: LoginRouterDataSource?
  private unowned let context: UIViewController
  
  init(context: UIViewController, dataSource: LoginRouterDataSource?) {
    self.context = context
    self.dataSource = dataSource
  }
  
  func perform(_ segue: LoginSegue) {
    switch segue {
    case .login:
      if let dataSource = dataSource, dataSource.loginRouterShouldChangePassword() {
        let vc = ChangePasswordSceneBuilder.build()
        context.navigationController?.pushViewController(vc, animated: true)
      } else {
        let vc = MovieListSceneBuilder.build()
        context.present(vc.embedInNavigationController(), animated: true, completion: nil)
      }
    case .forgotPassword:
      let vc = ChangePasswordSceneBuilder.build()
      context.navigationController?.pushViewController(vc, animated: true)
    case .signUp:
      let vc = SignUpSceneBuilder.build()
      context.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
