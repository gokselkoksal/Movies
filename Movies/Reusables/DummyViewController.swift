//
//  DummyViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {
    
    enum Route: String {
        case next
    }
    
    var router: Router!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = nextBarButton
    }
    
    func nextButtonTapped() {
        router.route(to: Route.next, from: self)
    }
}
