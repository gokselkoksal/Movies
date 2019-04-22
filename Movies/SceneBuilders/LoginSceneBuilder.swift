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
    let vm = LoginViewModel()
    vc.viewModel = vm
    vc.router = LoginRouter(context: vc, dataSource: vm)
    return vc
  }
}
