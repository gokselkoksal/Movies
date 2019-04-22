//
//  ObservableRecorder.swift
//  MoviesTests
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import Rasat

final class ObservableRecorder<Value> {
  
  private(set) var values: [Value] = []
  private let disposeBag = DisposeBag()
  
  init() { }
  
  convenience init(observable: Observable<Value>) {
    self.init()
    observe(observable)
  }
  
  func observe(_ observable: Observable<Value>) {
    disposeBag += observable.subscribe { [weak self] (value) in
      self?.values.append(value)
    }
  }
  
  func reset() {
    values.removeAll()
  }
}
