//
//  LoginPresenter.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
  func login(username: String?, password: String?)
  func signUp()
  func forgotPassword()
}

// MARK: - Implementation

final class LoginPresenter: BasePresenter<LoginOutput>, LoginPresenterProtocol {
  
  private let dataController: LoginDataControllerProtocol
  private let router: LoginRouterProtocol!
  
  init(dataController: LoginDataControllerProtocol, router: LoginRouterProtocol) {
    self.dataController = dataController
    self.router = router
    super.init(observable: dataController.observable)
  }
  
  func login(username: String?, password: String?) {
    dataController.login(username: username, password: password)
  }
  
  func signUp() {
    router.route(to: .signUp)
  }
  
  func forgotPassword() {
    router.route(to: .changePassword)
  }
  
  override func handleOutput(_ output: LoginOutput) {
    switch output {
    case .change(let change):
      switch change {
      case .loggedIn:
        if dataController.state.shouldChangePassword {
          router.route(to: .changePassword)
        } else {
          router.route(to: .movieList)
        }
      }
    case .error(let error):
      switch error {
      case .wrongCredentials:
        print("Wrong credentials!")
      }
    }
  }
}
