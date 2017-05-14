//
//  MockMoviesService.swift
//  Movies
//
//  Created by Göksel Köksal on 21/01/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MockMoviesService: MoviesService {
    
    enum Error: Swift.Error {
        case fetchFailed
    }
    
    let delay: TimeInterval?
    let movies: [Movie]
    let errorRate: Float
    
    init(movies: [Movie] = MockMoviesService.makeMockMovies(),
         delay: TimeInterval? = nil,
         errorRate: Float = 0.0) {
        self.delay = delay
        self.movies = movies
        self.errorRate = errorRate
    }
    
    func fetchMovies(_ completion: @escaping ((Result<[Movie]>) -> Void)) {
        executeInMock(afterDelay: delay) { [weak self] in
            guard let strongSelf = self else { return }
            if randomizer.randomBool(withRate: strongSelf.errorRate) {
                completion(Result.failure(Error.fetchFailed))
            } else {
                completion(Result.success(strongSelf.movies))
            }
        }
    }
    
    static func makeMockMovies() -> [Movie] {
        return [
            Movie(name: "Inception", year: 2010, rating: 4.5),
            Movie(name: "Shutter Island", year: 2008, rating: 4.2),
            Movie(name: "A Beautiful Mind", year: 2003, rating: 4.8),
            Movie(name: "Fury", year: 2015, rating: 4.0)
        ]
    }
}
