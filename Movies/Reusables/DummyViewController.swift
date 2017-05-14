//
//  DummyViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

enum DummySegue {
    case next
}

protocol DummyRouter {
    func perform(segue: DummySegue)
}

class DummyViewController: UIViewController {
    
    struct Depedencies {
        let router: DummyRouter
    }
    
    var dependencies: Depedencies!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = nextBarButton
    }
    
    func nextButtonTapped() {
        dependencies.router.perform(segue: .next)
    }
}
