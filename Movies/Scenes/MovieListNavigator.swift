//
//  MovieListNavigator.swift
//  Movies
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MovieListNavigator: Navigator {
    
    weak var flow: MovieListFlow?
    
    func resolve(_ action: NavigatorAction) -> Navigation? {
        guard let flow = flow, let action = action as? MovieListNavigatorAction else { return nil }
        switch action {
        case .logout:
            return BasicNavigation.dismiss(flow)
        case .detail(_):
            // TODO: Navigate to details screen.
            return nil
        }
    }
}
