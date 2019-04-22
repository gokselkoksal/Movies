//
//  AppRouter.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

final class AppRouter {
  
  private lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
  
  func start() {
    let vc = LoginSceneBuilder.build()
    let nc = UINavigationController(rootViewController: vc)
    
    window?.rootViewController = nc
    window?.makeKeyAndVisible()
  }
}
