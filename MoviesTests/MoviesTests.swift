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

final class MoviesTests: XCTestCase {
  
  private final class TestCase {
    
    let useCase: MovieListUseCase
    let service: MockMoviesService
    
    var outputs: [MovieListUseCaseOutput] {
      return recorder.values
    }
    
    private let recorder: ObservableRecorder<MovieListUseCaseOutput> = ObservableRecorder()
    private let disposeBag = DisposeBag()
    
    init() {
      service = MockMoviesService()
      useCase = MovieListUseCase(service: service)
      recorder.observe(useCase.outputObservable)
    }
    
    func reset() {
      recorder.reset()
    }
  }
  
  func testFetchMovies() {
    // given:
    let testCase = TestCase()
    // when:
    testCase.useCase.fetchMovies()
    // then:
    XCTAssertEqual(testCase.outputs[0], .didChangeLoadingState(makeActivityState(count: 1)))
    XCTAssertEqual(testCase.outputs[1], .didLoadMovies(testCase.service.movies))
    XCTAssertEqual(testCase.outputs[2], .didChangeLoadingState(makeActivityState(count: 0, toggled: true)))
  }
  
  func testAddMovie() {
    // given:
    let test = TestCase()
    let movie = Movie(name: "Test", year: 2000, rating: 4.5)
    // when:
    test.useCase.addMovie(withName: movie.name, year: movie.year, rating: movie.rating)
    // then:
    XCTAssertEqual(test.outputs[0], .didChangeMovies([movie], change: .insertion(0)))
  }

  func testRemoveMovie() {
    // given:
    let test = TestCase()
    test.useCase.fetchMovies()
    test.reset()
    // when:
    test.useCase.removeMovie(at: 0)
    var expectedMovies = test.service.movies
    expectedMovies.remove(at: 0)
    // then:
    XCTAssertEqual(test.outputs[0], .didChangeMovies(expectedMovies, change: .deletion(0)))
  }
  
  private func makeActivityState(count: Int, toggled: Bool = false) -> ActivityState {
    var state = ActivityState()
    
    for _ in 0..<count {
      state.add()
    }
    
    if toggled {
      state.add()
      try? state.remove()
    }
    
    return state
  }
}

final class ObservableRecorder<Value> {
  
  private(set) var values: [Value] = []
  private let disposeBag = DisposeBag()
  
  init() { }
  
  convenience init(observable: Observable<Value>) {
    self.init()
    observe(observable)
  }
  
  func observe(_ observable: Observable<Value>) {
    disposeBag += observable.subscribe { [weak self] (value) in
      self?.values.append(value)
    }
  }
  
  func reset() {
    values.removeAll()
  }
}
