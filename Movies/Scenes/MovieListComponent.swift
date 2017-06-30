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
    let navigator: Navigator
    
    init(service: MoviesService, navigator: Navigator) {
        self.service = service
        self.navigator = navigator
        super.init(state: MovieListState())
    }
    
    override func process(_ action: Action) {
        if let navigation = navigator.resolve(action) {
            commit(navigation)
        } else {
            var state = self.state
            state.react(to: action)
            commit(state)
        }
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
    
    func execute(on component: Component<MovieListState>, core: Core) {
        core.dispatch(MovieListAction.addActivity)
        service.fetchMovies { (result) in
            core.dispatch(MovieListAction.removeActivity)
            switch result {
            case .success(let movies):
                core.dispatch(MovieListAction.reloadMovies(movies))
            case .failure(let error):
                core.dispatch(MovieListAction.error(error))
            }
        }
    }
}
