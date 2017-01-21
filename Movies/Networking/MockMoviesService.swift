//
//  MockMoviesService.swift
//  Movies
//
//  Created by Göksel Köksal on 21/01/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class MockMoviesService: MoviesService {
    
    let delay: TimeInterval?
    let movies: [Movie]
    
    init(movies: [Movie] = MockMoviesService.makeMockMovies(),
         delay: TimeInterval? = nil) {
        self.delay = delay
        self.movies = movies
    }
    
    func fetchMovies(_ completion: @escaping (([Movie]) -> Void)) {
        if let delay = delay {
            let deadline = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
                guard let strongSelf = self else { return }
                completion(strongSelf.movies)
            }
        } else {
            completion(movies)
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
