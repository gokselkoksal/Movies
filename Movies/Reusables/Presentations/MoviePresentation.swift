//
//  MoviePresentation.swift
//  Movies
//
//  Created by Göksel Köksal on 22.04.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import MoviesCore

struct MoviePresentation: Equatable {
  
  let title, subtitle: String
  
  init(movie: Movie) {
    self.title = movie.name
    self.subtitle = "Year: \(movie.year) | Rating: \(movie.rating)"
  }
}

extension MoviePresentation: CustomStringConvertible {
  var description: String {
    return "\(title) | \(subtitle)"
  }
}
