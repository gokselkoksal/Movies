//
//  MovieListComponent.swift
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

// MARK: - Component

class MovieListComponent: Component<MovieListState> {
    
    let service: MoviesService
    
    init(service: MoviesService, navigator: Navigator? = nil) {
        self.service = service
        super.init(state: MovieListState(), navigator: navigator)
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
    
    func execute(on component: Component<MovieListState>) {
        component.dispatch(MovieListAction.addActivity)
        service.fetchMovies { (result) in
            component.dispatch(MovieListAction.removeActivity)
            switch result {
            case .success(let movies):
                component.dispatch(MovieListAction.reloadMovies(movies))
            case .failure(let error):
                component.dispatch(MovieListAction.error(error))
            }
        }
    }
}
