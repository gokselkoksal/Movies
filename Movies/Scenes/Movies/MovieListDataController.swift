//
//  MovieListDataController.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation
import MoviesCore
import Lightning
import Rasat

struct MovieListState {
  var movies: [Movie]
  var loadingState: ActivityState
}

enum MovieListOutput {
  case didUpdateMovies(CollectionChange)
  case didChangeLoadingState
}

protocol MovieListDataControllerProtocol {
  var state: MovieListState { get }
  var observable: Observable<MovieListOutput> { get }
  
  func fetchMovies()
  func addMovie(_ movie: Movie)
  func removeMovie(at index: Int)
}

// MARK: - Implementation

final class MovieListDataController: BaseDataController<MovieListState, MovieListOutput>, MovieListDataControllerProtocol {
  
  private let service: MoviesService
  
  init(service: MoviesService) {
    self.service = service
    super.init(state: MovieListState(movies: [], loadingState: ActivityState()))
  }
  
  func fetchMovies() {
    addActivity()
    service.fetchMovies { [weak self] (movies) in
      guard let self = self else { return }
      self.state.movies = movies
      self.broadcast(.didUpdateMovies(.reload))
      self.removeActivity()
    }
  }
  
  func addMovie(_ movie: Movie) {
    state.movies.append(movie)
    broadcast(.didUpdateMovies(.insertion(state.movies.count - 1)))
  }
  
  func removeMovie(at index: Int) {
    guard index >= 0 && index < state.movies.count else { return }
    state.movies.remove(at: index)
    broadcast(.didUpdateMovies(.deletion(index)))
  }
  
  private func addActivity() {
    state.loadingState.add()
    broadcast(.didChangeLoadingState)
  }
  
  private func removeActivity() {
    do {
      try state.loadingState.remove()
      broadcast(.didChangeLoadingState)
    } catch {
      // Noop.
    }
  }
}
