//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
import MoviesCore
import Lightning
import Rasat
@testable import Movies

final class MovieListTests: XCTestCase {
  
  private var dataController: MovieListDataController!
  private var presenter: MovieListPresenter!
  private var view: MockMovieListView!
  private var service: MockMoviesService!
  private var router: MovieListRouter!
  
  override func setUp() {
    service = MockMoviesService(delay: nil)
    view = MockMovieListView()
    dataController = MovieListDataController(service: service)
    router = MovieListRouter(context: nil)
    presenter = MovieListPresenter(view: view, dataController: dataController, router: router)
  }
  
  func testStart() {
    // given:
    let expectedMovies = service.movies.map(MoviePresentation.init)
    let expectedActions: [MovieListViewAction] = [
      .setTitle("Movies"),
      .setLoading(true),
      .updateMovies(expectedMovies, change: .reload),
      .setLoading(false)
    ]
    // when:
    presenter.start()
    // then:
    XCTAssertEqual(view.actions, expectedActions)
  }
  
  func testAddMovie() {
    // given:
    let movie = Movie(name: "Test", year: 2000, rating: 4.5)
    let expectedActions: [MovieListViewAction] = [
      .updateMovies([MoviePresentation(movie: movie)], change: .insertion(0))
    ]
    // when:
    presenter.addMovie(name: movie.name, year: "\(movie.year)", rating: "\(movie.rating)")
    // then:
    XCTAssertEqual(view.actions, expectedActions)
  }
  
  func testRemoveMovie() {
    // given:
    presenter.start()
    view.reset()
    let expectedMovies = service.movies.dropFirst().map(MoviePresentation.init)
    // when:
    presenter.removeMovie(at: 0)
    // then:
    XCTAssertEqual(view.actions, [.updateMovies(expectedMovies, change: .deletion(0))])
  }
}

private final class MockMovieListView: MovieListViewProtocol {
  
  private(set) var actions: [MovieListViewAction] = []
  
  func handle(_ action: MovieListViewAction) {
    self.actions.append(action)
  }
  
  func reset() {
    self.actions.removeAll()
  }
}
