//
//  Launcher.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

class Launcher {
    
    static func launch(with window: UIWindow?) {
        if let nc = window?.rootViewController as? UINavigationController,
           let loginVC = nc.viewControllers.first as? LoginViewController {
            loginVC.flow = coordinator.flows.first as! LoginFlow
        }
    }
}
