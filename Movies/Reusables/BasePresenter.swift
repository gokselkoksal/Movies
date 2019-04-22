//
//  BasePresenter.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import Rasat

class BasePresenter<DataControllerOutput> {
  
  let disposeBag = DisposeBag()
  
  init(observable: Observable<DataControllerOutput>) {
    disposeBag += observable.subscribe { [weak self] (output) in
      self?.handleOutput(output)
    }
  }
  
  deinit {
    disposeBag.dispose()
  }
  
  func handleOutput(_ output: DataControllerOutput) {
    // Should be implemented by subclasses.
  }
}
