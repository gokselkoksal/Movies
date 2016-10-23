//
//  Movie.swift
//  Reduxy
//
//  Created by Goksel Koksal on 05/08/16.
//  Copyright (c) 2003-2016 Monitise Group Limited. All rights reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Monitise Group Limited.
//  Any reproduction of this material must contain this notice.
//

import Foundation

struct Movie: Equatable {
    
    private struct Const {
        struct Year {
            static let min = UInt(1800)
            static let max = UInt(2100)
        }
        struct Rating {
            static let min = Float(1.0)
            static let max = Float(5.0)
        }
    }
    
    let name: String
    let year: UInt
    let rating: Float
    
    init(name: String, year: UInt, rating: Float) {
        
        self.name = name
        
        if year > Const.Year.max {
            self.year = Const.Year.max
        }
        else if year < Const.Year.min {
            self.year = Const.Year.min
        }
        else {
            self.year = year
        }
        
        if rating > Const.Rating.max {
            self.rating = Const.Rating.max
        }
        else if rating < Const.Rating.min {
            self.rating = Const.Rating.min
        }
        else {
            self.rating = rating
        }
    }
}

// MARK: Movie Equatable

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.name == rhs.name && lhs.year == rhs.year
}
