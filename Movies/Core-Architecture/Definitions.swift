//
//  Definitions.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol Dispatcher {
    func dispatch(_ action: Action)
    func dispatch<C: Command>(_ command: C)
}
