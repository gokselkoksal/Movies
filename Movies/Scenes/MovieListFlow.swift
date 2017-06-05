//
//  MovieListFlow.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

// MARK: - Actions

enum MovieListAction: Action {
    case reloadMovies([Movie])
    case addMovie(Movie)
    case removeMovie(index: Int)
    case addActivity
    case removeActivity
    case error(Error)
}

enum MovieListNavigatorAction: NavigatorAction {
    case detail(Movie)
    case logout
}

// MARK: - Flow

class MovieListFlow: Flow<MovieListState> {
    
    let service: MoviesService
    
    init(service: MoviesService, navigator: Navigator) {
        self.service = service
        super.init(id: MoviesFlowID.movieList, state: MovieListState(), navigator: navigator)
    }
    
    func fetchCommand() -> MovieListFetchCommand {
        return MovieListFetchCommand(service: service)
    }
}

// MARK: - Commands

class MovieListFetchCommand: Command {
    
    let service: MoviesService
    
    init(service: MoviesService) {
        self.service = service
    }
    
    func execute(on flow: Flow<MovieListState>, coordinator: Coordinator) {
        flow.dispatch(MovieListAction.addActivity)
        service.fetchMovies { (result) in
            flow.dispatch(MovieListAction.removeActivity)
            switch result {
            case .success(let movies):
                flow.dispatch(MovieListAction.reloadMovies(movies))
            case .failure(let error):
                flow.dispatch(MovieListAction.error(error))
            }
        }
    }
}
