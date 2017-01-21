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
    
    enum Change: Equatable {
        case moviesChanged(CollectionChange)
        case loadingStateChanged
    }
    
    fileprivate(set) var loadingState = ActivityTracker() {
        didSet { onChange?(.loadingStateChanged) }
    }
    private(set) var movies: [Movie] = []
    fileprivate var onChange: ((Change) -> Void)?
    
    fileprivate mutating func reloadMovies(_ movies: [Movie]) {
        self.movies = movies
        onChange?(.moviesChanged(.reload))
    }
    
    fileprivate mutating func appendMovie(withName name: String, year: UInt, rating: Float) {
        let movie = Movie(name: name, year: year, rating: rating)
        movies.append(movie)
        onChange?(.moviesChanged(.insertion(movies.count - 1)))
    }
    
    fileprivate mutating func removeMovie(at index: Int) {
        guard index >= 0 && index < movies.count else { return }
        movies.remove(at: index)
        onChange?(.moviesChanged(.deletion(index)))
    }
}

// MARK: Store

class MoviesViewModel {
    
    private(set) var state = MoviesState()
    var stateChangeHandler: ((MoviesState.Change) -> Void)? {
        didSet { state.onChange = stateChangeHandler }
    }
    
    // MARK: Actions
    
    func fetchMovies() {
        state.loadingState.addActivity()
        let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.state.reloadMovies(strongSelf.mockedMovies())
            strongSelf.state.loadingState.removeActivity()
        }
    }
    
    func appendMovie(withName name: String, year: UInt, rating: Float) {
        state.appendMovie(withName: name, year: year, rating: rating)
    }
    
    func removeMovie(at index: Int) {
        state.removeMovie(at: index)
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
}

// MARK: Equatable

func ==(lhs: MoviesState.Change, rhs: MoviesState.Change) -> Bool {
    
    switch (lhs, rhs) {
    case (.moviesChanged(let update1), .moviesChanged(let update2)):
        return update1 == update2
    case (.loadingStateChanged, .loadingStateChanged):
        return true
    default:
        return false
    }
}

