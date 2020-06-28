//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import MoviesCore
import Lightning

protocol MovieListPresenterProtocol: class {
  func start()
  func addMovie(name: String, year: String, rating: String)
  func removeMovie(at index: Int)
  func logout()
}

// MARK: - Implementation

final class MovieListPresenter: BasePresenter<MovieListDataControllerProtocol, MovieListState, MovieListOutput>, MovieListPresenterProtocol {
  
  private unowned let view: MovieListViewProtocol
  
  private let router: MovieListRouterProtocol
  
  init(view: MovieListViewProtocol, dataController: MovieListDataControllerProtocol, router: MovieListRouterProtocol) {
    self.view = view
    self.router = router
    super.init(dataController: dataController, stateSelector: dataController.state, observable: dataController.observable)
  }
  
  func start() {
    view.handle(.setTitle("Movies"))
    dataController.fetchMovies()
  }
  
  func addMovie(name: String, year: String, rating: String) {
    guard let year = UInt(year), let rating = Float(rating) else { return }
    let movie = Movie(name: name, year: year, rating: rating)
    dataController.addMovie(movie)
  }
  
  func removeMovie(at index: Int) {
    dataController.removeMovie(at: index)
  }
  
  func logout() {
    router.route(to: .login)
  }
  
  override func handleOutput(_ output: MovieListOutput, state: MovieListState) {
    switch output {
    case .didChangeLoadingState:
      if state.loadingState.isToggled {
        view.handle(.setLoading(state.loadingState.isActive))
      }
    case .didUpdateMovies(let change):
      let presentations = state.movies.map(MoviePresentation.init)
      view.handle(.updateMovies(presentations, change: change))
    }
  }
}
