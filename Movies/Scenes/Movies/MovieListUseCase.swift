//
//  MovieListUseCase.swift
//  Movies
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation
import MoviesCore
import Lightning
import Rasat

enum MovieListUseCaseOutput: Equatable {
  case didLoadMovies([Movie])
  case didChangeMovies(_ movies: [Movie], change: CollectionChange)
  case didChangeLoadingState(ActivityState)
}

class MovieListUseCase {
  
  var outputObservable: Observable<MovieListUseCaseOutput> {
    return outputChannel.observable
  }
  
  private let outputChannel = Channel<MovieListUseCaseOutput>()
  private let service: MoviesService
  private var loadingState = ActivityState()
  private var movies: [Movie] = []
  
  init(service: MoviesService) {
    self.service = service
  }
  
  // MARK: Actions
  
  func fetchMovies() {
    addActivity()
    service.fetchMovies { [weak self] (movies) in
      guard let self = self else { return }
      self.movies = movies
      self.broadcast(.didLoadMovies(movies))
      self.removeActivity()
    }
  }
  
  private func addActivity() {
    loadingState.add()
    broadcast(.didChangeLoadingState(loadingState))
  }
  
  private func removeActivity() {
    do {
      try loadingState.remove()
      broadcast(.didChangeLoadingState(loadingState))
    } catch {
      // Noop.
    }
  }
  
  func addMovie(withName name: String, year: UInt, rating: Float) {
    let movie = Movie(name: name, year: year, rating: rating)
    movies.append(movie)
    broadcast(.didChangeMovies(movies, change: .insertion(movies.count - 1)))
  }
  
  func removeMovie(at index: Int) {
    guard index >= 0 && index < movies.count else { return }
    movies.remove(at: index)
    broadcast(.didChangeMovies(movies, change: .deletion(index)))
  }
  
  private func broadcast(_ output: MovieListUseCaseOutput) {
    outputChannel.broadcast(output)
  }
}
