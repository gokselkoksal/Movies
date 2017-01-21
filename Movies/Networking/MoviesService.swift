//
//  MoviesService.swift
//  Movies
//
//  Created by Göksel Köksal on 21/01/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol MoviesService {
    func fetchMovies(_ completion: @escaping (([Movie]) -> Void))
}
