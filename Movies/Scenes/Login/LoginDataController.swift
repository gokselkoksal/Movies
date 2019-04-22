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
  var shouldChangePassword = false
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

final class LoginDataController: LoginDataControllerProtocol {
  
  private enum Credentials {
    static let username = "gokselkk"
    static let password = "123"
    static let expiredPassword = "qwe"
  }
  
  var observable: Observable<LoginOutput> { return channel.observable }
  
  private(set) var state: LoginState = LoginState()
  private let channel = Channel<LoginOutput>()
  
  func login(username: String?, password: String?) {
    guard let username = username, username == Credentials.username, let password = password else {
      channel.broadcast(.error(.wrongCredentials))
      return
    }
    switch password {
    case Credentials.password:
      state.shouldChangePassword = false
      channel.broadcast(.change(.loggedIn))
    case Credentials.expiredPassword:
      state.shouldChangePassword = true
      channel.broadcast(.change(.loggedIn))
    default:
      channel.broadcast(.error(.wrongCredentials))
    }
  }
}
