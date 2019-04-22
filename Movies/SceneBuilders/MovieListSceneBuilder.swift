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
  
  static func build() -> MovieListViewController {
    let vc = MovieListViewController.instantiate()
    let dataController = MovieListDataController(service: MockMoviesService(delay: 1))
    let presenter = MovieListPresenter(view: vc, dataController: dataController)
    vc.presenter = presenter
    return vc
  }
}
