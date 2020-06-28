//
//  MockMoviesService.swift
//  MoviesCore
//
//  Created by Göksel Köksal on 21/01/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public final class MockMoviesService: MoviesService {
  
  public let delay: TimeInterval?
  public let movies: [Movie]
  
  public init(movies: [Movie] = MockMoviesService.makeMockMovies(), delay: TimeInterval? = nil) {
    self.delay = delay
    self.movies = movies
  }
  
  public func fetchMovies(_ completion: @escaping (([Movie]) -> Void)) {
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
  
  public static func makeMockMovies() -> [Movie] {
    let base = [
      Movie(name: "Inception", year: 2010, rating: 4.5),
      Movie(name: "Shutter Island", year: 2008, rating: 4.2),
      Movie(name: "A Beautiful Mind", year: 2003, rating: 4.8),
      Movie(name: "Fury", year: 2015, rating: 4.0)
    ]
    
    var movies: [Movie] = []
    for index in 1...50 {
      let setForIndex = base.map({ Movie(name: $0.name + " \(index)", year: $0.year, rating: $0.rating) })
      movies.append(contentsOf: setForIndex)
    }
    
    return movies
  }
}
