//
//  ChangePasswordSceneBuilder.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

final class ChangePasswordSceneBuilder {
  
  static func build() -> UIViewController {
    // This screen has not been implemented yet. We use a dummy view controller
    // instead. This also serves as an exercise to showcase how to use routers
    // with reusable view controllers like DummyViewController.
    let vc = DummyViewController()
    vc.title = "Change Password"
    vc.router = ChangePasswordSceneRouter(context: vc)
    return vc
  }
}

private final class ChangePasswordSceneRouter: BaseRouter<DummySegue>, DummyRouterProtocol {
  
  override func perform(_ segue: DummySegue) {
    switch segue {
    case .next:
      let vc = MovieListSceneBuilder.build()
      context.present(vc.embedInNavigationController(), animated: true) { [weak context] in
        context?.navigationController?.popToRootViewController(animated: false)
      }
    }
  }
}
