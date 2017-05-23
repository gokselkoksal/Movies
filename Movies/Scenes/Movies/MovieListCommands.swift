//
//  MovieListCommands.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

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
