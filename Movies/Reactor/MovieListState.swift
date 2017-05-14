//
//  RMovieListState.swift
//  Movies
//
//  Created by Göksel Köksal on 10/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import UIKit

struct MovieListState {
    
    enum Change {
        case loadingState
        case movies(CollectionChange)
    }
    
    var loadingState = ActivityTracker()
    var movies: [Movie] = []
    var changelog: [Change] = [.loadingState, .movies(.reload)]
}

enum MovieListAction: Action {
    case reloadMovies([Movie])
    case addMovie(name: String, year: UInt, rating: Float)
    case removeMovie(index: Int)
    case addActivity
    case removeActivity
    case showMovie(index: Int)
}

enum MovieListReaction: Reaction {
    
    enum Navigation {
        case detail(Movie)
    }
    
    case error(Error)
    case navigation(Navigation)
}

// MARK: - Helpers

extension MovieListState.Change: Equatable {
    
    static func ==(lhs: MovieListState.Change, rhs: MovieListState.Change) -> Bool {
        
        switch (lhs, rhs) {
        case (.movies(let update1), .movies(let update2)):
            return update1 == update2
        case (.loadingState, .loadingState):
            return true
        default:
            return false
        }
    }
}
