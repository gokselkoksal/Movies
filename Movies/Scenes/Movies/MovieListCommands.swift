//
//  MovieListCommands.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MovieListFetchCommand: Command {
    
    typealias StateType = AppState
    
    private let service = MockMoviesService(delay: 1.5)
    
    func execute(state: StateType, store: Store<StateType>) {
        store.fire(action: MovieListAction.addActivity)
        service.fetchMovies { (result) in
            store.fire(action: MovieListAction.removeActivity)
            switch result {
            case .success(let movies):
                store.fire(action: MovieListAction.reloadMovies(movies))
            case .failure(let error):
                store.fire(reaction: MovieListReaction.error(error))
            }
        }
    }
}
