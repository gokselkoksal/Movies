//
//  MovieListTests.swift
//  MoviesTests
//
//  Created by Göksel Köksal on 23/10/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Movies

class MovieListTests: XCTestCase {

    func testMovieListFlow() {
        let service = MockMoviesService(delay: nil)
        let flow = MovieListFlow(service: service)
        let c = Coordinator(rootFlow: flow)
        let r = Recorder<MovieListState>()
        flow.subscribe(r)
        
        c.dispatch(flow.fetchCommand())
        XCTAssert(r.snapshots.count == 3)
        XCTAssert(r.snapshots[0].loadingState.activityCount == 1)
        XCTAssert(r.snapshots[1].loadingState.activityCount == 0)
        XCTAssert(r.snapshots[2].movies.count == service.movies.count)
        
        r.reset()
        let movie = Movie(name: "GK", year: 2005, rating: 5)
        c.dispatch(MovieListAction.addMovie(movie))
        XCTAssert(r.snapshots.count == 1)
        XCTAssert(r.snapshots[0].movies.count == service.movies.count + 1)
        XCTAssert(r.snapshots[0].movies[0] == movie)
    }
}
