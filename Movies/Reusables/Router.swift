//
//  Router.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import UIKit

protocol Router {
    @discardableResult func route<T: RawRepresentable>(
        to route: T,
        from source: UIViewController
        ) -> UIViewController?
}
