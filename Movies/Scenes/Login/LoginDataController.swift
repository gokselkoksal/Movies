//
//  LoginDataController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation
import Rasat

struct LoginState {
  var shouldChangePassword: Bool
}

enum LoginOutput: Equatable {
  
  enum Change: Equatable {
    case loggedIn
  }
  
  enum Error: Swift.Error, Equatable {
    case wrongCredentials
  }
  
  case change(Change)
  case error(Error)
}

protocol LoginDataControllerProtocol {
  var state: LoginState { get }
  var observable: Observable<LoginOutput> { get }
  
  func login(username: String?, password: String?)
}

// MARK: - Implementation

final class LoginDataController: BaseDataController<LoginState, LoginOutput>, LoginDataControllerProtocol {
  
  private enum Credentials {
    static let username = "gokselkk"
    static let password = "123"
    static let expiredPassword = "qwe"
  }
  
  init() {
    super.init(state: LoginState(shouldChangePassword: false))
  }
  
  func login(username: String?, password: String?) {
    guard let username = username, username == Credentials.username, let password = password else {
      broadcast(.error(.wrongCredentials))
      return
    }
    switch password {
    case Credentials.password:
      state.shouldChangePassword = false
      broadcast(.change(.loggedIn))
    case Credentials.expiredPassword:
      state.shouldChangePassword = true
      broadcast(.change(.loggedIn))
    default:
      broadcast(.error(.wrongCredentials))
    }
  }
}
