//
//  MovieListFlow.swift
//  Movies
//
//  Created by Göksel Köksal on 23/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MovieListFlow: Flow<MovieListState> {
    
    let service: MoviesService
    
    init(service: MoviesService) {
        self.service = service
        super.init(state: MovieListState())
    }
    
    func fetchCommand() -> MovieListFetchCommand {
        return MovieListFetchCommand(service: service)
    }
}
