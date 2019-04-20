//
//  MoviesService.swift
//  MoviesCore
//
//  Created by Göksel Köksal on 21/01/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol MoviesService: class {
  func fetchMovies(_ completion: @escaping (([Movie]) -> Void))
}
