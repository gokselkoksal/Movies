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
        case error
    }
    
    var loadingState = ActivityTracker()
    var movies: [Movie] = []
    var error: Error? = nil
    var changelog: [Change] = [.loadingState, .movies(.reload), .error]
}

// MARK: - Reducer

extension MovieListState: State {
    
    mutating func react(to action: Action) {
        guard let action = action as? MovieListAction else { return }
        changelog = []
        switch action {
        case .addActivity:
            loadingState.addActivity()
            changelog = [.loadingState]
        case .removeActivity:
            loadingState.removeActivity()
            changelog = [.loadingState]
        case .reloadMovies(let newMovies):
            movies = newMovies
            changelog = [.movies(.reload)]
        case .addMovie(let movie):
            movies.insert(movie, at: 0)
            changelog = [.movies(.insertion(0))]
        case .removeMovie(index: let index):
            guard index >= 0 && index < movies.count else { return }
            movies.remove(at: index)
            changelog = [.movies(.deletion(index))]
        case .error(let error):
            self.error = error
            changelog = [.error]
        }
    }
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
