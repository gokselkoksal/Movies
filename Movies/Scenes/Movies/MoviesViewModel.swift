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
    var loadingState = ActivityTracker()
    var movies: [Movie] = []
}

// MARK: Store

class MoviesViewModel {
    
    fileprivate(set) var state = MoviesState()
    var stateChangeHandler: ((MoviesState.Change) -> Void)?
    
    // MARK: Actions
    
    func fetchMovies() {
        emit(state.addActivity())
        let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.emit(strongSelf.state.reloadMovies(strongSelf.mockedMovies()))
            strongSelf.emit(strongSelf.state.removeActivity())
        }
    }
    
    func appendMovie(name: String, year: UInt, rating: Float) {
        let movie = Movie(name: name, year: year, rating: rating)
        emit(state.appendMovie(movie))
    }
    
    func removeMovieAtIndex(_ index: Int) {
        emit(state.removeMovieAtIndex(index))
    }
}

// MARK: Reducers

extension MoviesState {
    
    enum Change: Equatable {
        case none
        case movies(CollectionChange)
        case loading(ActivityTracker)
    }
    
    mutating func addActivity() -> Change {
        loadingState.addActivity()
        return Change.loading(loadingState)
    }
    
    mutating func removeActivity() -> Change {
        loadingState.removeActivity()
        return .loading(loadingState)
    }
    
    mutating func reloadMovies(_ movies: [Movie]) -> Change {
        self.movies = movies
        return .movies(.reload)
    }
    
    mutating func appendMovie(_ movie: Movie) -> Change {
        movies.append(movie)
        return .movies(.insertion(movies.count - 1))
    }
    
    mutating func removeMovieAtIndex(_ index: Int) -> Change {
        guard index >= 0 && index < movies.count else {
            return .none
        }
        movies.remove(at: index)
        return .movies(.deletion(index))
    }
}

// MARK: - Helpers

private extension MoviesViewModel {
    
    func mockedMovies() -> [Movie] {
        return [
            Movie(name: "Inception", year: 2010, rating: 4.5),
            Movie(name: "Shutter Island", year: 2008, rating: 4.2),
            Movie(name: "A Beautiful Mind", year: 2003, rating: 4.8),
            Movie(name: "Fury", year: 2015, rating: 4.0)
        ]
    }
    
    func emit(_ change: MoviesState.Change) {
        stateChangeHandler?(change)
    }
}

// MARK: Equatable

func ==(lhs: MoviesState.Change, rhs: MoviesState.Change) -> Bool {
    
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.movies(let update1), .movies(let update2)):
        return update1 == update2
    case (.loading(let loadingState1), .loading(let loadingState2)):
        return loadingState1 == loadingState2
    default:
        return false
    }
}

