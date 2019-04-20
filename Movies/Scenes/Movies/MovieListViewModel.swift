//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation
import MoviesCore
import Lightning

// MARK: State

struct MovieListState {
  
  enum Change: Equatable {
    case loadingState
    case movies(CollectionChange)
  }
  
  private(set) var loadingState = ActivityState()
  private(set) var movies: [Movie] = []
  
  mutating func addActivity() -> Change {
    loadingState.add()
    return .loadingState
  }
  
  mutating func removeActivity() -> Change? {
    do {
      try loadingState.remove()
      return .loadingState
    } catch {
      return nil
    }
  }
  
  mutating func reloadMovies(_ movies: [Movie]) -> Change {
    self.movies = movies
    return .movies(.reload)
  }
  
  mutating func addMovie(_ movie: Movie) -> Change {
    movies.append(movie)
    return .movies(.insertion(movies.count - 1))
  }
  
  mutating func removeMovie(at index: Int) -> Change? {
    guard index >= 0 && index < movies.count else { return nil }
    movies.remove(at: index)
    return .movies(.deletion(index))
  }
}

// MARK: Store

class MovieListViewModel {
  
  var service: MoviesService = MockMoviesService(delay: 1.5)
  
  private(set) var state = MovieListState()
  var stateChangeHandler: ((MovieListState.Change) -> Void)?
  
  // MARK: Actions
  
  func fetchMovies() {
    mutateState { $0.addActivity() }
    service.fetchMovies { [weak self] (movies) in
      guard let self = self else { return }
      self.mutateState { $0.reloadMovies(movies) }
      self.mutateState { $0.removeActivity() }
    }
  }
  
  func addMovie(withName name: String, year: UInt, rating: Float) {
    let movie = Movie(name: name, year: year, rating: rating)
    mutateState { $0.addMovie(movie) }
  }
  
  func removeMovie(at index: Int) {
    mutateState { $0.removeMovie(at: index) }
  }
  
  private func mutateState(block: (inout MovieListState) -> MovieListState.Change?) {
    if let change = block(&state) {
      stateChangeHandler?(change)
    }
  }
}
