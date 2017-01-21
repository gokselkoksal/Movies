//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

// MARK: State

struct MoviesState {
    
    enum ID {
        case loadingState, movies
    }
    
    fileprivate(set) var loadingState = Property(ActivityTracker(), ID.loadingState)
    fileprivate(set) var movies = CollectionProperty([Movie](), ID.movies)
}

// MARK: Store

class MoviesViewModel {
    
    private(set) var state = MoviesState()
    var service: MoviesService = MockMoviesService(delay: 1.5)
    var stateChangeHandler: ((MoviesState.ID, Any?) -> Void)? {
        didSet {
            state.loadingState.register(stateChangeHandler)
            state.movies.register(stateChangeHandler)
        }
    }
    
    // MARK: Actions
    
    func fetchMovies() {
        state.loadingState.value.addActivity()
        service.fetchMovies { [weak self] (movies) in
            guard let strongSelf = self else { return }
            strongSelf.state.movies <- (movies, .reload)
            strongSelf.state.loadingState.value.removeActivity()
        }
    }
    
    func appendMovie(withName name: String, year: UInt, rating: Float) {
        let movie = Movie(name: name, year: year, rating: rating)
        var movies = state.movies.value
        movies.append(movie)
        state.movies <- (movies, .insertion(movies.count - 1))
    }
    
    func removeMovie(at index: Int) {
        var movies = state.movies.value
        guard index >= 0 && index < movies.count else { return }
        movies.remove(at: index)
        state.movies <- (movies, .deletion(index))
    }
}
