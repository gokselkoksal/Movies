//
//  MoviePresentation.swift
//  Movies
//
//  Created by Göksel Köksal on 14/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

struct MoviePresentation {
    
    let title, subtitle: String
    
    init(movie: Movie) {
        self.title = movie.name
        self.subtitle = "Year: \(movie.year) | Rating: \(movie.rating)"
    }
}
