//
//  BaseViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 12/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewComponent, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}

class BaseTableViewController: UITableViewController, ViewComponent, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}

class BaseCollectionViewController: UITableViewController, ViewComponent, ErrorHandler {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let viewControllers = navigationController?.viewControllers, viewControllers.index(of: self) == nil {
            backButtonTapped()
        }
    }
    
    func backButtonTapped() { }
}
