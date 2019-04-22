//
//  BaseRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class BaseRouter<Destination> {
  
  unowned let context: UIViewController
  
  init(context: UIViewController) {
    self.context = context
  }
  
  func route(to destination: Destination) {
    // Should be implemented by subclasses.
  }
}
