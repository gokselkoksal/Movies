//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Movies

class MoviesTests: XCTestCase {
    
    class Recorder {
        let model: MoviesViewModel
        var changes: [(change: MoviesState.Change, snapshot: MoviesState)] = []
        var service = MockMoviesService()
        init() {
            model = MoviesViewModel()
            model.service = service
            model.stateChangeHandler = { [unowned model] id in
                self.changes.append((id, model.state))
            }
        }
    }
    
    func testFetchMovies() {
        let r = Recorder()
        r.model.fetchMovies()
        XCTAssert(r.changes.count == 3)
        XCTAssert(r.changes[0].change == .loadingState)
        XCTAssert(r.changes[0].snapshot.loadingState.activityCount == 1)
        XCTAssert(r.changes[1].change == .movies(.reload))
        XCTAssert(r.changes[1].snapshot.movies == r.service.movies)
        XCTAssert(r.changes[2].change == .loadingState)
        XCTAssert(r.changes[2].snapshot.loadingState.activityCount == 0)
    }
    
    func testAddMovie() {
        let r = Recorder()
        r.model.addMovie(withName: "Test", year: 2000, rating: 4.5)
        XCTAssert(r.changes.count == 1)
        XCTAssert(r.changes[0].change == .movies(.insertion(0)))
        XCTAssert(r.changes[0].snapshot.movies.count == 1)
        XCTAssert(r.changes[0].snapshot.movies[0].name == "Test")
    }
    
    func testRemoveMovie() {
        let r = Recorder()
        r.model.fetchMovies()
        r.changes.removeAll()
        r.model.removeMovie(at: 0)
        var movies = r.service.movies
        movies.remove(at: 0)
        XCTAssert(r.model.state.movies == movies)
        XCTAssert(r.changes.count == 1)
        XCTAssert(r.changes[0].change == .movies(.deletion(0)))
    }
}
