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
    let dataController = LoginDataController()
    let router = LoginRouter(context: vc)
    let presenter = LoginPresenter(dataController: dataController, router: router)
    vc.presenter = presenter
    return vc
  }
}
