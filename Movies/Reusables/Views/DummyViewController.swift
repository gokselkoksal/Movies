//
//  DummyViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

enum DummyDestination {
  case next
}

protocol DummyRouterProtocol {
  func route(to destination: DummyDestination)
}

final class DummyViewController: UIViewController {
  
  var router: DummyRouterProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    let nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
    navigationItem.rightBarButtonItem = nextBarButton
  }
  
  @objc func nextButtonTapped() {
    router.route(to: .next)
  }
}
