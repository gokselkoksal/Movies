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
  
  override func setUp() {
    service = MockMoviesService(delay: nil)
    view = MockMovieListView()
    dataController = MovieListDataController(service: service)
    presenter = MovieListPresenter(view: view, dataController: dataController)
  }
  
  func testStart() {
    // given:
    let expectedMovies = service.movies.map(MoviePresentation.init)
    let expectedCommands: [MovieListViewCommand] = [
      .setTitle("Movies"),
      .setLoading(true),
      .updateMovies(expectedMovies, change: .reload),
      .setLoading(false)
    ]
    // when:
    presenter.start()
    // then:
    XCTAssertEqual(view.commands, expectedCommands)
  }
  
  func testAddMovie() {
    // given:
    let movie = Movie(name: "Test", year: 2000, rating: 4.5)
    let expectedCommands: [MovieListViewCommand] = [
      .updateMovies([MoviePresentation(movie: movie)], change: .insertion(0))
    ]
    // when:
    presenter.addMovie(name: movie.name, year: "\(movie.year)", rating: "\(movie.rating)")
    // then:
    XCTAssertEqual(view.commands, expectedCommands)
  }
  
  func testRemoveMovie() {
    // given:
    presenter.start()
    view.resetCommands()
    let expectedMovies = service.movies.dropFirst().map(MoviePresentation.init)
    // when:
    presenter.removeMovie(at: 0)
    // then:
    XCTAssertEqual(view.commands, [.updateMovies(expectedMovies, change: .deletion(0))])
  }
}

private final class MockMovieListView: MovieListViewProtocol {
  
  private(set) var commands: [MovieListViewCommand] = []
  
  func render(_ command: MovieListViewCommand) {
    self.commands.append(command)
  }
  
  func resetCommands() {
    self.commands.removeAll()
  }
}
