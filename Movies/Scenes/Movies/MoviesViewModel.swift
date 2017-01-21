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
    
    enum Change {
        case loadingState
        case movies(CollectionChange)
    }
    
    fileprivate(set) var loadingState = ActivityTracker() {
        didSet { onChange?(.loadingState) }
    }
    private(set) var movies: [Movie] = []
    
    var onChange: ((Change) -> Void)?
    
    mutating func reloadMovies(_ movies: [Movie]) {
        self.movies = movies
        onChange?(.movies(.reload))
    }
    
    mutating func addMovie(_ movie: Movie) {
        movies.append(movie)
        onChange?(.movies(.insertion(movies.count - 1)))
    }
    
    mutating func removeMovie(at index: Int) {
        guard index >= 0 && index < movies.count else { return }
        movies.remove(at: index)
        onChange?(.movies(.deletion(index)))
    }
}

// MARK: Store

class MoviesViewModel {
    
    var service: MoviesService = MockMoviesService(delay: 1.5)
    
    private(set) var state = MoviesState()
    var stateChangeHandler: ((MoviesState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }
    
    // MARK: Actions
    
    func fetchMovies() {
        state.loadingState.addActivity()
        service.fetchMovies { [weak self] (movies) in
            guard let strongSelf = self else { return }
            strongSelf.state.reloadMovies(movies)
            strongSelf.state.loadingState.removeActivity()
        }
    }
    
    func addMovie(withName name: String, year: UInt, rating: Float) {
        let movie = Movie(name: name, year: year, rating: rating)
        state.addMovie(movie)
    }
    
    func removeMovie(at index: Int) {
        state.removeMovie(at: index)
    }
}


// MARK: Equatable

func ==(lhs: MoviesState.Change, rhs: MoviesState.Change) -> Bool {
    
    switch (lhs, rhs) {
    case (.movies(let update1), .movies(let update2)):
        return update1 == update2
    case (.loadingState, .loadingState):
        return true
    default:
        return false
    }
}
