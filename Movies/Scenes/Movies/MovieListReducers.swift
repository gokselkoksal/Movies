//
//  MovieListReducers.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

extension MovieListState: State {
    
    mutating func react(to action: Action) -> [Reaction] {
        guard let action = action as? MovieListAction else { return [] }
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
        case .addMovie(name: let name, year: let year, rating: let rating):
            let movie = Movie(name: name, year: year, rating: rating)
            movies.insert(movie, at: 0)
            changelog = [.movies(.insertion(0))]
        case .removeMovie(index: let index):
            guard index >= 0 && index < movies.count else { return [] }
            movies.remove(at: index)
            changelog = [.movies(.deletion(index))]
        case .showMovie(index: let index):
            let movie = movies[index]
            return [MovieListReaction.navigation(.detail(movie))] // React!
        }
        return []
    }
    
    mutating func cleanUp() {
        self = MovieListState()
    }
}
