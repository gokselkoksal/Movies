//
//  MovieListComponent.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import CoreArchitecture

// MARK: - State

struct MovieListState: State {
    
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

// MARK: - Actions

enum MovieListAction: Action {
    case reloadMovies([Movie])
    case addMovie(Movie)
    case removeMovie(index: Int)
    case addActivity
    case removeActivity
    case error(Error)
}

enum MovieListNavigatorAction: Action {
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
            guard let action = action as? MovieListAction else { return }
            var state = self.state
            state.changelog = []
            
            switch action {
            case .addActivity:
                state.loadingState.addActivity()
                state.changelog = [.loadingState]
            case .removeActivity:
                state.loadingState.removeActivity()
                state.changelog = [.loadingState]
            case .reloadMovies(let newMovies):
                state.movies = newMovies
                state.changelog = [.movies(.reload)]
            case .addMovie(let movie):
                state.movies.insert(movie, at: 0)
                state.changelog = [.movies(.insertion(0))]
            case .removeMovie(index: let index):
                guard index >= 0 && index < state.movies.count else { return }
                state.movies.remove(at: index)
                state.changelog = [.movies(.deletion(index))]
            case .error(let error):
                state.error = error
                state.changelog = [.error]
            }
            
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
