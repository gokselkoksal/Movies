//
//  ChangePasswordViewController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    var flow: ChangePasswordFlow!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Password"
        view.backgroundColor = .white
    }
}

extension ChangePasswordViewController {
    
    static func instantiate(with flow: ChangePasswordFlow) -> ChangePasswordViewController? {
        let vc = ChangePasswordViewController()
        vc.flow = flow
        return vc
    }
}
