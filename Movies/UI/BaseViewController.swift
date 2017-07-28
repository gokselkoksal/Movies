//
//  BaseViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 12/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import CoreArchitecture

class BaseViewController: UIViewController, NavigationPerformer, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}

class BaseTableViewController: UITableViewController, NavigationPerformer, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}

class BaseCollectionViewController: UITableViewController, NavigationPerformer, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}
