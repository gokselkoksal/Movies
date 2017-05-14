//
//  UIViewController+Removal.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var zap_isBeingRemoved: Bool {
        return (navigationController?.isBeingDismissed ?? false) || isBeingDismissed || isMovingFromParentViewController
    }
}
