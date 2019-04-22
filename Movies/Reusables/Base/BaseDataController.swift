//
//  BaseDataController.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import Rasat

class BaseDataController<State, Output> {
  
  var state: State
  var observable: Observable<Output> {
    return channel.observable
  }
  
  private let channel: Channel<Output>
  
  init(state: State) {
    self.state = state
    self.channel = Channel()
  }
  
  func broadcast(_ output: Output) {
    channel.broadcast(output)
  }
}
