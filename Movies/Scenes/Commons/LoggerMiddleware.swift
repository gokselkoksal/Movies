//
//  LoggerMiddleware.swift
//  Movies
//
//  Created by Göksel Köksal on 09/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import CoreArchitecture

class LoggerMiddleware: Middleware {
    
    func willProcess(_ action: Action) { }
    
    func didProcess(_ action: Action) {
        print(">", action)
    }
}
