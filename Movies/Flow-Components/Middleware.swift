//
//  Middleware.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol Middleware {
    func willProcess(_ action: Action)
    func didProcess(_ action: Action)
}
