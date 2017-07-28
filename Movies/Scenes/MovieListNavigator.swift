//
//  MovieListNavigator.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import CoreArchitecture

class MovieListNavigator: Navigator {
    
    weak var component: MovieListComponent?
    
    func resolve(_ action: Action) -> Navigation? {
        guard let component = component, let action = action as? MovieListNavigatorAction else { return nil }
        switch action {
        case .logout:
            return BasicNavigation.dismiss(component)
        case .detail(_):
            // TODO: Navigate to details screen.
            return nil
        }
    }
}
