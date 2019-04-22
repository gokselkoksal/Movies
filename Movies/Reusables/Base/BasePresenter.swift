//
//  BasePresenter.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import Rasat

class BasePresenter<DataController, DataControllerState, DataControllerOutput> {
  
  let dataController: DataController
  let disposeBag = DisposeBag()
  
  private let stateSelector: () -> DataControllerState
  
  init(dataController: DataController,
       stateSelector: @autoclosure @escaping () -> DataControllerState,
       observable: Observable<DataControllerOutput>)
  {
    self.dataController = dataController
    self.stateSelector = stateSelector
    disposeBag += observable.subscribe { [weak self] (output) in
      guard let self = self else { return }
      self.handleOutput(output, state: self.stateSelector())
    }
  }
  
  deinit {
    disposeBag.dispose()
  }
  
  func handleOutput(_ output: DataControllerOutput, state: DataControllerState) {
    // Should be implemented by subclasses.
  }
}
