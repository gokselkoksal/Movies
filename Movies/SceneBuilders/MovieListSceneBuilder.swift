//
//  MovieListSceneBuilder.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit
import MoviesCore

final class MovieListSceneBuilder {
  
  func build() -> MovieListViewController {
    let vc = MovieListViewController.instantiate()
    vc.useCase = MovieListUseCase(service: MockMoviesService(delay: 1.5))
    return vc
  }
}
