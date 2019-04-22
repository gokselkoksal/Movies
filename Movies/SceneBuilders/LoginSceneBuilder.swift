//
//  LoginSceneBuilder.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class LoginSceneBuilder {
  
  static func build() -> LoginViewController {
    let vc = LoginViewController.instantiate()
    vc.viewModel = LoginViewModel()
    vc.router = DefaultLoginRouter()
    return vc
  }
}
